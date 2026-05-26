---
name: anti-ai-editorial-design
description: Use when reviewing or designing the visual language of a site to avoid the generic AI-generated aesthetic. Defines specific typography pairings, layout asymmetries, treatment patterns (grain, vignette, dolly, scrim) and forbidden tropes. Apply during build, not retrofitted.
---

# Anti-AI Editorial Design

The default visual language LLMs produce on autopilot is recognisable within 2 seconds:
- Inter or Geist for everything.
- Centered cards with `border-radius: 12px` and a subtle gradient border.
- Purple-to-blue gradient blobs.
- Glassmorphism panels.
- Big rounded CTAs in a vivid accent colour.
- Three-column feature grids with lucide icons.
- Hero with a centered tagline, centered subtitle, centered button.

To opt out, **commit early** to editorial design conventions borrowed from print magazines and film title sequences.

## The 7 commitments

### 1. Typography pairings (not Inter-for-everything)

Pick one combination per project:

| Pairing | Mood | Display | Body | Labels |
|---|---|---|---|---|
| Editorial calm | premium, considered | Fraunces (serif) | Inter (sans) | JetBrains Mono |
| Brutalist | raw, declarative | Space Grotesk Bold | IBM Plex Sans | IBM Plex Mono |
| Cinematic | dramatic | Cormorant Garamond | Manrope | Geist Mono |
| Mid-century | warm, optimistic | Recoleta | Söhne | Söhne Mono |
| Technical | engineering | Söhne Breit | Söhne | Berkeley Mono |

Always include the **mono labels** — they instantly add editorial gravity (scene numbers, eyebrows, metadata).

### 2. Italic for emphasis (not bold)

```css
em, .display em, .title em { font-style: italic; color: var(--accent); }
```

Bold + colour = ad copy. Italic + colour = literature.

### 3. HUD micro-labels with section numbers

```html
<div class="hud">
  <span class="hud__num">01</span>
  <span class="hud__line"></span>
  <span class="hud__tag">Invisible City</span>
</div>
```

```css
.hud { font-family: var(--mono); font-size: .7rem; letter-spacing: .22em; text-transform: uppercase; }
.hud__num { color: var(--accent); }
.hud__line { flex: 0 0 3rem; height: 1px; background: currentColor; opacity: .5; }
```

This single pattern signals "designed by a human" louder than any animation.

### 4. Asymmetric copy alignment

Alternate scenes between:
- `.scene` (left-aligned copy, left-anchored veil)
- `.scene.scene--right` (right-aligned copy, right-anchored veil)
- `.scene.scene--center` (centered title card)

Never put more than one centered scene in a row. The asymmetry is what makes it read like a magazine spread.

### 5. Hairlines, not box-shadows

```css
border-top: 1px solid rgba(180,196,190,.18);
```

Never `box-shadow: 0 4px 12px rgba(0,0,0,.1)`. Editorial design uses **single-pixel hairlines** to separate content, not cards.

### 6. Cinematic treatments

These five overlays applied together = instant film grade:

```css
/* 1. Vignette */
.vignette { position: fixed; inset: 0; pointer-events: none;
  background: radial-gradient(ellipse at center, transparent 50%, rgba(0,0,0,.4) 100%); }

/* 2. Film grain (animated) */
.grain { /* SVG turbulence + steps animation, see template */ }

/* 3. Per-video dolly */
.stage__v { transform: scale(1.16) translate3d(...); }
/* k=scroll progress, dolly scales 1.16 → 1.10 across the clip */

/* 4. Multi-radial veil */
.stage__veil { background: radial-gradient(...) ; mix-blend-mode: multiply; }

/* 5. Subtle split-tone */
.stage::after {
  background: radial-gradient(60% 40% at 50% 30%, rgba(180,196,190,.05), transparent),
              radial-gradient(80% 60% at 50% 100%, rgba(201,169,107,.04), transparent);
  mix-blend-mode: screen;
}
```

### 7. Slow, weighted scroll

- Lenis `duration: 2.0`, `easing: t => 1 - Math.pow(1 - t, 4)`.
- Scrub easing `0.10–0.15` (lower = heavier).
- Copy transitions `1.2–1.5s` with blur-in (`filter: blur(8px) → blur(0)`).
- Staggered reveals (`.18s` increments between children).

## Forbidden tropes

- ❌ Purple-to-blue gradients of any kind.
- ❌ "Glow" effects on text or buttons.
- ❌ Border-radius > 4px on anything (rounded corners read as AI default).
- ❌ Drop shadows on cards or text (use depth via colour/contrast).
- ❌ Lucide / Heroicons emoji-style line icons. Use SVG you own or none.
- ❌ Auto-rotating testimonial carousels.
- ❌ Big animated number counters ("10,000+ customers!").
- ❌ Hero with centered headline, centered subheadline, centered single-button CTA.
- ❌ Three-up "Features" grid with icon-headline-text card pattern.

## When in doubt

Open a Pentagram / IDEO / Apple Newsroom / Vogue Business / Stripe Press page. Ask yourself: would this exact composition appear there? If no, reject the pattern.

## Quick self-audit

Show your design and answer:
1. Could I identify the typography choice within 1 second? (yes = good, "default" = bad)
2. Is there any horizontal line that isn't a hairline? (no = good)
3. Is every CTA aligned with the body's grid, or floating in centered space?
4. Are scene-to-scene transitions different, or is everything fading-up-from-below?
5. Does the colour palette have a "human" choice (a brass, a sage, a burgundy) or just primary + grey?

3+ "good" answers → ship. 2 or fewer → re-pick the type stack and start the asymmetry pass.
