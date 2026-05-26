# Templates

Drop-in skeletons for a continuous-reel cinematic scroll site. They implement the architecture documented in `../skills/04-build-cinematic-scroll-site.md` and `../skills/05-adaptive-mobile-strategy.md`.

## What's here

| File | Purpose |
|---|---|
| `index.html` | Single-page layout: persistent `.stage` of N videos + N `.scene` sections + utility pages (pricing, contact, footer). Copy is placeholder `{like this}` — replace with yours. |
| `style.css` | Design system + scene primitives + adaptive mobile rules + reduced-motion. ~700 lines. |
| `main.js` | Adaptive controller: desktop scrub (Lenis + GSAP ScrollTrigger), mobile autoplay-loop (IntersectionObserver). |

## How to use

1. **Copy** the three code files into your project root, alongside an `assets/` folder:
   ```
   your-project/
   ├── index.html              ← from templates/index.html
   ├── assets/
   │   ├── css/style.css       ← from templates/style.css
   │   └── js/main.js          ← from templates/main.js
   ├── videos/
   │   ├── 01.mp4 … 09.mp4     (desktop, all-keyframe)
   │   └── mobile/
   │       └── 01.mp4 … 09.mp4 (portrait reframes)
   └── info/
       ├── storytelling.md     (your narrative)
       └── video-prompts.md    (your storyboard)
   ```

2. **Customize** the variables in `style.css :root` — palette, fonts, gutters.

3. **Replace** every `{placeholder}` in `index.html` with your content. Pull copy from `info/storytelling.md` and your content document.

4. **Tune** the `data-scrub` attribute on each `<section class="scene">` — recommended starting point is `0.55 × clip duration in seconds`. A 6-second clip → `data-scrub="3.3"`. Bump 30% higher for a heavier / more cinematic feel.

5. **Alternate** the `data-veil="left|right|center"` attribute so no two adjacent scenes share the same value.

6. **Update** the SVG logo in the nav, the meta tags in `<head>`, and the form `action` URL.

## Critical rules (do not skip)

- Don't introduce per-scene `<video>` elements — breaks the continuous reel illusion.
- Don't add `crossorigin="anonymous"` to videos — breaks file:// dev for no benefit.
- Don't put `isolation: isolate` on `.scene` — hides copy behind the fixed stage.
- Don't load Lenis or GSAP on the mobile path — wastes ~80 KB of JS for no benefit (the included `main.js` already forks correctly).
- Don't ship without `prefers-reduced-motion` rules — accessibility regression. The included CSS handles this; don't remove it.

## Customization checklist

```
□ Palette in style.css :root        (4 colours + 1 accent)
□ Google Fonts link in index.html   (display + body + mono)
□ Logo SVG in nav                    (replace placeholder)
□ Meta tags (title, description, og) (in <head>)
□ All {placeholder} copy             (search for { and replace)
□ Video sources                       (data-src + data-src-mobile)
□ data-scrub per scene                (tuned to clip duration)
□ data-veil per scene                 (alternated)
□ Form action URL                     (Formspree / Netlify / etc.)
□ Footer copyright + secondary line
```
