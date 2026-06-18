---
name: build-cinematic-scroll-site
description: Use after videos are preprocessed and the storyboard exists. Generates the full HTML/CSS/JS for a continuous-reel scroll-driven cinematic site with a persistent video stage, scroll-scrub on desktop, and editorial typography. Outputs three files - index.html, style.css, main.js.
---

# Build Cinematic Scroll Site

You are scaffolding a complete single-page site. The architecture is a **continuous cinematic reel**: one persistent fixed-position `.stage` holds all N videos stacked, and they crossfade as scroll progresses through their respective `.scene` sections.

> **Read `skills/07-scroll-scrub-rendering.md` first.** It decides HOW frames are rendered. The kit defaults to the **WebCodecs → canvas** engine (frame-perfect, smooth reverse) with an automatic `video.currentTime` fallback for old browsers. The templates already wire both. Do not rip the WebCodecs path out — `video.currentTime` as the *primary* engine is the #1 cause of "stuck frames / jumps to end / reverse stutter" complaints.

## Inputs

1. `info/storytelling.md` — narrative (use to extract scene titles + body copy).
2. `info/video-prompts.md` — storyboard (use to confirm scene count + roles).
3. `info/content.md` (optional) — additional content blocks (pricing, services, audience, contact).
4. Videos in `videos/01.mp4 … 0N.mp4` (all-keyframe) and `videos/mobile/01.mp4 …` (portrait).
5. Brand palette + typography preferences.

## Output

Four files:
- `index.html`
- `assets/css/style.css`
- `assets/js/main.js`
- `assets/js/cinematic-scrubber.js` (the WebCodecs render module — copy verbatim, no customization)

Use `templates/index.html`, `templates/style.css`, `templates/main.js`, `templates/cinematic-scrubber.js` from this kit as the skeleton — they already implement the continuous-reel pattern AND the WebCodecs/`currentTime` dual render path. Customize:

## Customization checklist

1. **Palette** in `:root` (CSS) — set 4–5 colour custom properties + 1 accent.
2. **Typography** — pick a serif display + sans body + mono labels. Default kit uses Fraunces / Inter / JetBrains Mono.
3. **Scene count** — duplicate/remove `<section class="scene">` blocks to match storyboard.
4. **Scene data attrs**:
   - `id="sN"` (s1..s9).
   - `data-scene="N"` (number).
   - `data-scrub="X.X"` — height as multiples of viewport. On the **WebCodecs path** (default) the scrub is frame-perfect, so you can go as low as `1.5–2.0` for a tight "less scroll" feel. On the **`currentTime` fallback** you need `≥ 3.5` to mask stutter. Pick for your default audience; modern browsers get the good path either way.
   - `data-veil="left|right|center"` — gradient direction. **Never** repeat the same value in adjacent scenes — alternate.
   - `class="scene scene--right"` or `scene--center` to match copy alignment.
5. **Copy blocks** — replace template lorem with body copy from `content.md`.
6. **HUD labels** — small mono caption ("01 ─── INVISIBLE CITY") matches scene number + theme.
7. **Stage videos** — update `data-src` (desktop) and `data-src-mobile` (mobile portrait) paths.

## Architecture cheat sheet

```
<body>
  ├── .grain, .vignette, .curtain (fixed overlays, behind everything except veils)
  ├── .stage (position: fixed, z-index: 0)
  │     └── 9× <video class="stage__v" data-src="..." data-src-mobile="...">
  │     └── 9× <canvas class="stage__c" data-src="...">  (WebCodecs render target)
  │     └── .stage__veil × 3 (left | right | center variants, toggled by data-veil)
  ├── .nav (position: fixed, z-index: 100)
  ├── <main id="story">
  │     └── 9× <section class="scene" id="sN" data-scrub="X" data-veil="...">
  │            └── .scene__pin (position: sticky; top: 0; height: 100vh)
  │                  └── .scene__copy (the only thing the user reads)
  ├── <section id="pricing"> (utility content, no video)
  ├── <section id="contact">
  └── <footer>
```

## Critical CSS rules (don't skip)

```css
.stage          { position: fixed; inset: 0; z-index: 0; }
.scene          { position: relative; height: var(--scene-h, 240vh); z-index: 2; }
.scene__pin     { position: sticky; top: 0; height: 100vh; }
.stage__v       { position: absolute; inset: 0; object-fit: cover; opacity: 0;
                  transition: opacity 1.4s cubic-bezier(.55,0,.25,1); }
.stage__v.active{ opacity: 1; }
```

The `isolation: isolate` trap: do **not** put it on `.scene`. It creates a stacking context that traps copy behind the fixed `.stage`. Use `z-index: 2` on `.scene` instead.

## JS architecture (desktop path)

```js
// Lenis smooth-scroll wired into GSAP's ticker
gsap.ticker.add(time => lenis.raf(time * 1000));
lenis.on('scroll', ScrollTrigger.update);

// Pick render engine once (see skills/07). WebCodecs when supported.
const useWebCodecs = !isMobile
  && window.CinematicScrubber && window.CinematicScrubber.isSupported();
if (useWebCodecs) document.body.classList.add('webcodecs-scrub');

// Per-scene ScrollTrigger drives local progress 0..1
ScrollTrigger.create({
  trigger: scene, start: 'top top', end: 'bottom bottom', scrub: true,
  onUpdate: self => { localProgress[idx] = self.progress; }
});

// rAF loop eases displayed → progress, then renders:
displayed[i] += (localProgress[i] - displayed[i]) * 0.18;
if (scrubbers[i]?.ready) {
  scrubbers[i].scrubTo(displayed[i]);        // WebCodecs: frame-perfect, reverse-safe
} else {
  v.currentTime = displayed[i] * v.duration; // fallback: stutters, kept for old browsers
}

// Crossfade by adding .active to new element (canvas or video), removing old after 700ms
inV.classList.add('active');
setTimeout(() => out.classList.remove('active'), 700);
```

**Why WebCodecs is the default:** `video.currentTime` is not frame-accurate and cannot decode backward — reverse scroll stutters and the video can jump-to-end-and-freeze. `CinematicScrubber` decodes the exact requested frame and paints it to a canvas, so forward and reverse feel identical. Full rationale + decision tree in `skills/07-scroll-scrub-rendering.md`.

## JS architecture (mobile path)

```js
// No Lenis, no GSAP — native scroll + IntersectionObserver
const isMobile = matchMedia('(max-width: 900px)').matches;

if (isMobile) {
  videos.forEach(v => { v.loop = true; v.muted = true; v.playsInline = true; });

  const ioActive = new IntersectionObserver(entries => {
    // pick entry with largest intersection ratio
    // load + play that video, pause others
  }, { rootMargin: '-35% 0% -35% 0%', threshold: 0 });
}
```

## Tuning knobs (give the user, not the AI)

| Knob | Where | Effect |
|---|---|---|
| `data-scrub="X"` per scene | HTML | Scene's scroll runway. Higher = slower scrub / more scroll. On WebCodecs you can drop to 1.5–2.0 for "less scroll"; on the fallback keep ≥ 3.5. |
| `0.18` in `displayed += (target - displayed) * 0.18` | JS | Lower = heavier shutter weight (more "film"), higher = snappier. |
| `transition: opacity 1.4s` on `.stage__v` | CSS | Crossfade speed. Match the `700` in `setTimeout`. |
| Lenis `duration: 2.0` + `wheelMultiplier: 0.68` | JS | Scroll inertia weight. |
| `.scene__copy > * { transition: 1.3s }` | CSS | Copy reveal speed. |

## Anti-patterns

- ❌ **`video.currentTime` as the *primary* scrub engine** (not frame-accurate, can't reverse-decode → stuck/jump/reverse-stutter). Use WebCodecs; keep `currentTime` only as the old-browser fallback. See skill 07.
- ❌ Chasing the symptom with encoding tweaks (odd GOPs, VP9/AV1 swaps "for smoothness") — refuted folklore. The problem is the *primitive*, not the encode.
- ❌ Per-scene `<video>` with per-scene sticky pin (hard cuts between scenes).
- ❌ `crossorigin="anonymous"` on `<video>` (breaks file:// testing for no benefit).
- ❌ `isolation: isolate` on `.scene` (hides copy behind the fixed stage).
- ❌ Identical scene heights (the eye expects rhythm — vary 3.5×–5×).
- ❌ Glassmorphism / blurred cards over the video (generic-AI tell).
- ❌ Center-aligned copy in every scene (alternate L/R/C for editorial feel).

## Deliverable

Four files written (`index.html`, `style.css`, `main.js`, `cinematic-scrubber.js`), a brief diff explaining what was customized from the templates, and a `README.md` in the project root with run instructions (must serve over HTTP, not `file://`). Confirm in the console which render path is active (`[Kit] … scrub: WebCodecs (canvas)` vs `video.currentTime (legacy)`).

Proceed to `skills/05-adaptive-mobile-strategy.md` to verify the mobile experience.
