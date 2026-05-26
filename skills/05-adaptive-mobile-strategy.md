---
name: adaptive-mobile-strategy
description: Use when verifying or fixing the mobile experience of a cinematic scroll site. Defines breakpoint detection, the autoplay-loop substitution, typography scaling, copy scrim placement, and reduced-motion fallback. Required pass for any cinematic site claiming to be responsive.
---

# Adaptive Mobile Strategy

Scroll-scrubbing on touch devices is bad UX:
- Touch momentum makes `currentTime` jittery.
- iOS Safari throttles aggressive `currentTime` writes.
- Battery + memory cost of decoding-on-scroll is significant.
- Users expect read-and-scroll, not media-as-game.

So on mobile, **swap the entire interaction model**. Same content, different controller.

## The breakpoint

```js
const mqMobile = window.matchMedia(
  '(max-width: 900px), (pointer: coarse) and (max-width: 1024px)'
);
```

Why this query:
- `max-width: 900px` catches phones + small tablets.
- `(pointer: coarse) and (max-width: 1024px)` catches iPad in portrait/landscape (touch-primary, but wider).
- iPads in desktop docked mode (wide + pointer:fine via Magic Keyboard) get the desktop path.

Listen for change and reload — switching modes hot is complex (Lenis is on/off, GSAP scrub is set up/torn down):
```js
mqMobile.addEventListener('change', () => location.reload());
```

## Mobile substitutions

| Layer | Desktop | Mobile |
|---|---|---|
| Smooth scroll | Lenis | Native |
| Video playback | Scroll-driven `currentTime` | `autoplay loop muted playsinline` |
| Scene height | `data-scrub × 100vh` (3–6×) | `100svh` (one viewport) |
| Reveal trigger | GSAP ScrollTrigger | IntersectionObserver |
| Video aspect | 16:9 landscape | 9:16 portrait |
| Copy reveal | Blur-in + translateY (1.3s) | Fade + translateY (0.7s) |
| Cross-fade | rAF loop driven | CSS transition on `.active` toggle |

## CSS additions

```css
/* mobile body class is added by JS */
body.is-mobile .scene { height: auto; min-height: 100svh; }
body.is-mobile .scene__pin {
  position: relative; top: auto; height: auto; min-height: 100svh;
}
body.is-mobile .scene__copy {
  padding: 6rem var(--gutter) 3rem;
  min-height: 100svh;
  justify-content: flex-end;  /* anchor copy to bottom — over the loop */
}
body.is-mobile .scene__copy::before {
  /* readability scrim — gradient under the copy block */
  content: ""; position: absolute; inset: auto 0 0 0;
  height: 88%; z-index: -1; pointer-events: none;
  background: linear-gradient(to top,
    rgba(8,10,11,.85) 0%, rgba(8,10,11,.72) 35%,
    rgba(8,10,11,.45) 70%, rgba(8,10,11,0) 100%);
}
body.is-mobile .stage__v { transform: none !important; }
```

Use `100svh` (small viewport height) instead of `100vh` so iOS toolbar collapse doesn't shift layouts.

## Mobile typography

Bump display sizes — phones can take much larger headlines:
```css
@media (max-width: 900px) {
  .scene__copy--hero .display { font-size: clamp(3.2rem, 13vw, 5.5rem); line-height: .95; }
  .title { font-size: clamp(2.4rem, 10vw, 3.8rem); }
  .display--quiet { font-size: clamp(2rem, 7.5vw, 3rem); }
  .body { font-size: 1.02rem; }
}
```

The `Xvw` scaling is essential — fixed `rem` sizes look the same across all phones (too small on Pro Max, too big on SE).

## Multi-column → single column

Anything that's `grid-template-columns: repeat(3, 1fr)` on desktop should collapse to `1fr` on mobile:
```css
@media (max-width: 900px) {
  .levels, .method, .plans, .extras, .diptych { grid-template-columns: 1fr; }
  /* swap right-borders to bottom-borders */
  .levels li, .method article { border-right: 0; border-bottom: 1px solid rgba(...); }
}
```

## Mobile nav

The nav often breaks on mobile because CTAs wrap. Pattern:
```css
@media (max-width: 900px) {
  .nav__mark em { display: none; }       /* hide secondary brand word */
  .nav__progress { display: none; }      /* drop the scrubber bar */
  .nav__cta { font-size: 0; line-height: 1; }
  .nav__cta::before { content: "Begin"; font-size: .62rem; letter-spacing: .16em; }
  /* replace full CTA text with shorter version via ::before */
}
```

## prefers-reduced-motion

Critical for WCAG 2.3.3 + accessibility:
```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: .001ms !important;
    transition-duration: .15s !important;
    transition-delay: 0s !important;
  }
  .scene__copy > * { filter: none !important; transform: none !important; opacity: 1 !important; }
  .stage__v { transform: none !important; }
  .grain { animation: none !important; }
}
```

## Verification pass

Open DevTools → device mode. Test at these viewports:
- **375 × 667** (iPhone SE) — smallest modern phone
- **390 × 844** (iPhone 14) — standard
- **428 × 926** (iPhone Pro Max) — large
- **820 × 1180** (iPad portrait) — should still be mobile path
- **1024 × 768** (iPad landscape) — desktop path because pointer:fine if external keyboard, otherwise mobile

Each should show:
- ✓ Console: `[Kit] mode: MOBILE`
- ✓ Network: requests to `videos/mobile/01.mp4` not `videos/01.mp4`
- ✓ First video autoplays in portrait, fills viewport.
- ✓ Copy is bottom-anchored over a clean scrim.
- ✓ No horizontal scroll. Touch any link / form input still works.
- ✓ Nav: brand left, "Begin" CTA right, no wrapping.

## Common bugs

| Symptom | Cause | Fix |
|---|---|---|
| Video doesn't autoplay on iOS | Missing `playsinline` | Add `playsinline` attribute |
| Video shows landscape on phone | `data-src-mobile` not set or matchMedia evaluated too early | Verify the camelCase dataset key + reload on mq change |
| Copy invisible | `isolation: isolate` on `.scene` traps it behind fixed `.stage` | Remove `isolation`, use `z-index: 2` |
| Choppy autoplay | Mobile videos too high bitrate | Re-encode with `crf 26` |
| Wrong video activates first | IO threshold too low | Use `rootMargin: '-35% 0% -35% 0%'` and pick max intersection ratio |
