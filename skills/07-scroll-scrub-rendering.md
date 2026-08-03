---
name: scroll-scrub-rendering
description: Use when deciding HOW to render scroll-driven video frames — before building the scrub loop in skill 04. Covers the three rendering engines (video.currentTime, WebCodecs→canvas, image-sequence→canvas), why video.currentTime fails for cinematic scrub, and a decision tree for picking the right one. Read this if a built site shows "stuck frames", "jumps to the end", or "reverse scroll stutters".
---

# Scroll-Scrub Rendering Engines

There are three ways to put a scroll-driven frame on screen. Picking the wrong one is the single most common reason a cinematic scroll site "feels broken" no matter how you tune scene heights or smoothing. This skill exists because **`video.currentTime` scrubbing — the obvious approach, and what most tutorials teach — is structurally unsuited to cinematic scroll**, and no amount of encoding or easing fixes it.

## The core finding (field consensus, 2025–2026)

`HTMLVideoElement.currentTime` is **the wrong primitive for scroll-scrub**:

- It is **not frame-accurate**. The browser snaps to the nearest decodable point, so distinct scroll positions can paint the same frame, then jump.
- It **cannot scrub backward smoothly**. No mainstream codec (H.264 / VP9 / AV1) decodes in reverse. Reverse playback = seek to the nearest keyframe, then re-decode forward to the target. That re-decode is why **reverse scroll always feels worse than forward** — it is structural, not a tuning bug.
- Even **all-keyframe encoding (`-g 1`) does not fully fix it** — it makes every frame independently decodable (helps reverse), but `currentTime` still doesn't guarantee the browser paints *the* frame you asked for at *the* moment you asked.

Top studios already bypass it. Lusion's own case study reports they "couldn't get the accurate timestamp via `video.currentTime`" and resorted to encoding a frame counter into the video pixels and reading it back with WebGL `readPixels()` — because the timeline API is not trustworthy for sync-critical work.

**Sources:** [web.dev — rVFC](https://web.dev/articles/requestvideoframecallback-rvfc) · [MDN — requestVideoFrameCallback](https://developer.mozilla.org/en-US/docs/Web/API/HTMLVideoElement/requestVideoFrameCallback) · [Lusion Awwwards case study](https://www.awwwards.com/case-study-for-lusion-by-lusion-winner-of-site-of-the-month-may.html) · [CSS-Tricks — Apple-style scroll](https://css-tricks.com/lets-make-one-of-those-fancy-scrolling-animations-used-on-apple-product-pages/)

## The three engines

| Engine | How it works | Frame-accurate? | Reverse? | Bytes | Effort |
|---|---|---|---|---|---|
| **A. `video.currentTime`** | Set `video.currentTime` from scroll, browser seeks+paints | ❌ no | ❌ stutters | smallest (MP4) | trivial |
| **B. WebCodecs → canvas** | Demux MP4 (MP4Box), `VideoDecoder` emits frames, paint to `<canvas>` | ✅ yes | ✅ yes | same as MP4 | medium (one-time module) |
| **C. Image sequence → canvas** | Numbered JPGs (`0001.jpg…`), draw indexed frame to `<canvas>` | ✅ yes | ✅ yes | ~20–30× MP4 | low code, heavy assets |

### A — `video.currentTime` (legacy / fallback only)

The pattern skill 04 used to teach. Keep it **only as a fallback** for browsers without WebCodecs (Safari < 16.4, Firefox < 132). Symptoms when used as the primary path: stuck frames on fast scroll, jump-to-end-and-freeze, reverse stutter. If you must ship it as primary (no build budget), the only mitigation is **long scene runways** (`data-scrub` ≥ 3.5) so the stutter is masked by lots of scroll — which is exactly the "too much scroll" complaint clients raise.

### B — WebCodecs → canvas (RECOMMENDED default)

The modern path. `VideoDecoder` decodes the exact frame you ask for; you paint it to a `<canvas>` mirroring the video's position. Same file size as the MP4 you already encoded. Reached **Baseline (cross-browser) in October 2024** — Chrome/Edge since 2020, Safari 16.4+, Firefox 132+. Use `templates/cinematic-scrubber.js` from this kit — it's a drop-in `class CinematicScrubber { init(); scrubTo(progress); destroy() }` with a `CinematicScrubber.isSupported()` feature-detect.

Because all-keyframe encoding means every frame is independently decodable, the decoder feeds one sample per requested frame — no keyframe walk-back needed. Forward and reverse cost the same.

### C — image sequence → canvas (Apple's approach)

Pre-render numbered JPGs, draw the scroll-indexed frame to canvas. Rock-solid, simplest code, frame-perfect both directions. The catch is **bytes**: CSS-Tricks measured 90 frames ≈ 56 MB as images vs ~1.9 MB as a 3s/30fps video — a ~29× penalty. For a 9-scene reel that's hundreds of MB. Only viable for **short hero sequences** (one scene, ≤150 frames), not a full multi-scene reel.

## Decision tree

```
Is this ONE short hero animation (≤150 frames, one scene)?
├── YES → C. Image sequence on canvas. Simplest, bulletproof, bytes are fine at this size.
└── NO (multi-scene cinematic reel)
    │
    Do you have build budget for a one-time JS module (~250 LOC)?
    ├── YES → B. WebCodecs → canvas.  ◄── DEFAULT for this kit.
    │         Ship A as the automatic fallback for old browsers.
    └── NO  → A. video.currentTime, but accept LONG scene runways
              (data-scrub ≥ 3.5). Set client expectations: less scroll = more stutter.
```

## Encoding still matters (for B and A)

Both video paths need **all-keyframe MP4** (`scripts/encode-keyframe.sh`, `-g 1 -bframes 0`). For WebCodecs it means every frame is a self-contained decode (no walk-back). For `currentTime` it means seeks land closer to target. Image sequence (C) sidesteps codecs entirely.

Do **not** chase exotic per-clip tuning (odd GOPs like `-g 2`, codec swaps to VP9/AV1 "for smoothness"). The deep-research verification round refuted those as folklore — they don't fix the `currentTime` problem because the problem isn't the encode, it's the primitive.

## Mobile

None of this applies on mobile. Touch devices should **autoplay-loop** the portrait video while a scene is centered (IntersectionObserver) — never scrub. Scrubbing on touch is jittery, drains battery, and fights momentum scroll. WebCodecs is desktop-only in this kit by design.

## Accessibility

`prefers-reduced-motion: reduce` must disable the scrub loop entirely and show a **static poster frame** (paint frame 0 once, or a `<picture>` fallback). Don't animate the reel for users who opted out. This is in addition to killing the dolly transforms and grain (skill 04 / 06 already cover those).

## What to hand the user

When you build with engine B, tell the user:
- Which path is active (the module logs `[scrubber] WebCodecs` or `video.currentTime (legacy)` — keep that console line).
- That `data-scrub` can now go **lower** (1.5–2.0) without stutter, because the scrub is no longer the bottleneck. This is the lever for "less scroll" that engine A could never give them.
- That reverse and forward now feel identical (the headline win).

Proceed to `skills/04-build-cinematic-scroll-site.md` for the build, which now wires engine B by default with engine A fallback.
