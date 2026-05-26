---
name: storyboard-from-narrative
description: Use when a written narrative exists and the user needs prompts to generate AI video clips. Converts a 250-400 word story into 6-10 numbered scenes with start frame prompt, end frame prompt, motion description, and duration for each.
---

# Storyboard from Narrative

You are converting a written narrative into a **shot-list** for AI video generation. The output is fed to image generators (Midjourney / Flux / Nano Banana) for the **start frame** and **end frame**, then to image-to-video (Kling / Runway / Luma / Sora) to animate between them.

## Inputs

- A `storytelling.md` (or similar narrative file).
- Brand palette (hex codes) if available.
- Tonal anchors (calm/aggressive/playful/serious/etc).

## Process

1. Read the narrative. Identify **distinct visual beats** (usually 1 per paragraph). Aim for 6–10 scenes.
2. For each beat, decide:
   - What's the **emotional state** of this moment? (anticipation / resolution / revelation / declaration / invitation)
   - What's the **single visual idea** that conveys it? (one strong metaphor, not three)
   - What **transforms** between start and end? (the scene's verb — bloom, unravel, ignite, settle, lift)
3. Establish a **global style anchor** — a paragraph pasted into every prompt for visual consistency.
4. Write start frame + end frame + motion for each scene.

## Output structure

```markdown
# {Project} — Scroll-Driven Video Sequence

**Global style anchor** (paste into every prompt):
> *Cinematic, {tone} aesthetic. Muted palette: {hex codes with names}.
> Soft volumetric light, fine grain, 35mm lens, shallow depth of field, 16:9,
> no text, no logos, no people's faces visible unless specified.*

---

## Scene 1 — "{Title}" ({role: hero/reveal/utility/cta})

**Beat:** *"{quote from narrative}"*

**Start frame prompt:**
> {Concrete visual description. 30–60 words. Include lens/lighting hints.} [global style]

**End frame prompt:**
> {Same composition, but transformed by the scene's verb.} [global style]

**Motion:** {what happens between the two frames}. (~{N}s)

---
(repeat for each scene)

## Production notes

| Item | Recommendation |
|---|---|
| Aspect ratio | 16:9 master, 9:16 reframes for mobile |
| Clip length | 5–9s each |
| Frame rate | 24fps |
| Stills tool | Midjourney v6 / Flux 1.1 Pro / Nano Banana |
| I2V tool | Kling 2.1 or Runway Gen-3 |
```

## Rules for prompts

- **Concrete > abstract.** "Macro shot of a single sage-toned flower bud on dark background, dewdrops, soft rim light" >> "beautiful organic form."
- **Same composition, different state.** Start and end frames should look like the same camera, the same moment in time, with one thing transformed. This is what makes I2V models morph smoothly.
- **One subject per shot.** "A blueprint extruding into 3D towers" >> "A blueprint, then towers, then a flower."
- **Specify lens + lighting** so the AI doesn't default to wide-angle daylight.
- **No text overlays** — text comes from HTML, not the video.
- **No literal logo or brand mark** unless you're doing the explicit reveal shot.

## Scene-role conventions

| Role | Position | Typical duration |
|---|---|---|
| Hero | scene 1 | 6s |
| Hidden truth | scene 2 | 5s |
| Resolution / brand reveal | scene 3 | 7s |
| Symbol elaboration | scene 4 | 6s |
| Practice / what we do | scene 5 | 8s |
| Audience / who we serve | scene 6 | 7s |
| Method / process | scene 7 | 9s |
| Manifesto / poetic break | scene 8 | 6s |
| CTA / right moment | scene 9 | 7s |

## Anti-patterns to avoid

- ❌ Glassmorphism / floating cards in the video.
- ❌ Generic AI tropes: glowing neural networks, hexagonal grids, particle sphere logos, holographic UI panels with fake data.
- ❌ People's faces shown clearly (uncanny valley, dates the video).
- ❌ Subject in dead center every shot — alternate compositions.

## Deliverable

Save to `info/video-prompts.md`. Show the user a summary table (Scene # | Title | Duration | Role) before they generate clips.
