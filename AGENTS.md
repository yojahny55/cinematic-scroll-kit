# Cinematic Scroll Kit — Agent Guide

A reusable methodology + assets for building **scroll-driven cinematic storytelling sites** with AI-generated video. Portable across Claude Code, OpenCode, Codex, Antigravity, Cursor, Aider, and any LLM agent that can read markdown + run shell.

> **Read this first**, then read the skill for the specific phase you're on.

---

## What this kit produces

A single-page site where:
- A narrative (the brand's "story") is split into **N scenes** (typically 6–10).
- Each scene has a **paired AI video clip** (start frame → end frame → I2V).
- The user scrolls through **one continuous cinematic reel**: videos crossfade between scenes, copy fades in over the active frame.
- On **desktop**: scroll position drives `video.currentTime` (frame-perfect scrub).
- On **mobile**: scenes autoplay-loop with portrait reframed videos (no scroll hijacking).

---

## The pipeline (5 phases)

```
1. NARRATIVE       →  2. STORYBOARD      →  3. GENERATE         →  4. PROCESS          →  5. BUILD
   storytelling.md     scene-by-scene        text-to-video         re-encode for scrub    HTML/CSS/JS
                       start+end prompts     (Kling, Runway,       portrait reframe       continuous reel
                                              Sora, Luma)          for mobile             adaptive
```

Each phase has a dedicated skill in `skills/`. The slash-commands in `commands/` chain phases together.

---

## Quick start (for any agent)

If a user says *"build me a scroll-driven cinematic site for X"*:

1. **Phase 1 — Narrative.** If they don't have one, generate the storytelling using `skills/01-narrative-from-brand.md`.
2. **Phase 2 — Storyboard.** Read `skills/02-storyboard-from-narrative.md`. Produce a numbered list of 6–10 scenes, each with: scene beat, start frame prompt, end frame prompt, motion description, duration. Save as `video-prompts.md`.
3. **Phase 3 — Generate.** The user generates clips externally (Kling/Runway/Sora). Once they drop them into a folder, you proceed.
4. **Phase 4 — Process videos.** Run `scripts/encode-keyframe.sh` on the desktop set (all-keyframe MP4 for scrub) and `scripts/encode-mobile-portrait.sh` for the mobile set (9:16 center-crop). See `skills/03-video-preprocessing.md`.
5. **Phase 5 — Build.** Use `templates/index.html`, `templates/style.css`, `templates/main.js` as the skeleton. Customize copy + scene heights. See `skills/04-build-cinematic-scroll-site.md` and `skills/05-adaptive-mobile-strategy.md`.

---

## Architectural decisions worth remembering

These are non-obvious choices we learned the hard way:

| Decision | Why |
|---|---|
| **One persistent `.stage` for all videos** (not per-scene) | Hard cuts between sticky pins always read as "page break." A shared fixed stage with crossfades reads as one continuous reel. |
| **All-keyframe MP4 encoding (`-g 1 -bframes 0`)** | Standard MP4s only have a keyframe every ~48 frames. `currentTime = X` stutters between them. All-keyframe = frame-perfect seek. ~30% file size bump. |
| **9:16 portrait videos for mobile** (center-crop from 16:9) | Landscape video on phones leaves 60% of screen black; portrait fills the canvas and feels native. |
| **Scrub on desktop, autoplay-loop on mobile** | Scroll-scrubbing on touch devices is awful (jittery, drains battery, conflicts with momentum scrolling). Mobile users expect read-and-scroll. |
| **Lenis on desktop only** | Smooth-scroll libraries hijack mobile gestures. Native momentum scroll is better on iOS/Android. |
| **`rootMargin: '-35% 0% -35% 0%'` on mobile IO** | Activates a scene's video only when its center is in the viewport's center band — prevents the next video flickering in as scene boundary peeks. |
| **No `crossorigin` attribute on `<video>`** | Triggers a CORS check even on same-origin, blocks `file://` testing. Drop it unless you genuinely need CORS. |
| **Editorial typography (serif display + mono labels)** | Default "AI generic" sites use Inter everywhere. Pairing Fraunces/serif + JetBrains Mono labels + italic emphasis = doesn't look AI-generated. |
| **Asymmetric layouts (alternating L/R/center)** | Default is centered cards. Editorial magazine alternation feels human. |
| **`prefers-reduced-motion` killswitch** | All transforms, blurs, grain animations off. WCAG 2.3.3 + saves users with vestibular sensitivity. |

---

## File map of a built site

```
project-root/
├── index.html                  # single page, all scenes
├── assets/
│   ├── css/style.css           # ~500 lines, design system + scene primitives
│   └── js/main.js              # adaptive controller (desktop scrub / mobile loop)
├── videos/                     # all-keyframe landscape MP4s
│   ├── 01.mp4 ... 09.mp4
│   ├── _orig/                  # untouched source files
│   └── mobile/                 # 9:16 portrait variants
│       └── 01.mp4 ... 09.mp4
└── info/
    ├── storytelling.md         # the narrative (English)
    ├── content.md              # all body copy + pricing + audience
    └── video-prompts.md        # the storyboard
```

---

## Conventions used across all skills

- **Always** check `prefers-reduced-motion` and provide a static fallback.
- **Always** lazy-load videos (`data-src` → JS sets `src` when scene approaches viewport).
- **Always** test at three viewports: 375px (iPhone), 820px (iPad), 1440px (desktop).
- **Never** use the same gradient direction in adjacent scenes (alternate `data-veil="left|right|center"`).
- **Never** ship a `<video>` with `controls` visible in this design pattern — they break the cinematic frame.

---

## Per-agent invocation

- **Claude Code / Claude.ai**: copy `skills/*.md` to `.claude/skills/` (they auto-register from the frontmatter). Or invoke directly: *"Use the storyboard-from-narrative skill on storytelling.md"*.
- **OpenCode / Codex**: feed `commands/*.md` as system prompts or slash-commands.
- **Antigravity**: drop `AGENTS.md` at the repo root — Antigravity reads it automatically.
- **Cursor / Aider / generic**: paste `AGENTS.md` + the relevant skill into the chat as context.

---

## License / attribution

Internal methodology pack. No external dependencies beyond Lenis (MIT) + GSAP (free for non-commercial; license required for commercial).
