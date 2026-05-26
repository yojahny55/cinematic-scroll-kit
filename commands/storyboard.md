# /storyboard

Quick standalone command — converts a narrative file to a video storyboard. No site build, no encoding. Just the prompts.

**Use when:** user has narrative text and wants AI video prompts (start frame + end frame + motion) for each beat.

## Inputs

- A narrative file path (e.g. `storytelling.md`).
- Optional: brand palette as hex codes.
- Optional: tonal anchors (calm/aggressive/playful/cinematic).

## Process

1. Read the narrative.
2. Identify 6–10 visual beats — one per major paragraph.
3. For each beat:
   - Decide the **single visual idea** (one strong metaphor).
   - Decide the **scene's verb** — what transforms between start and end (bloom, unravel, ignite, settle, lift).
4. Write the global style anchor (palette + lens + lighting hints).
5. Produce the storyboard table.

## Output template

```markdown
# {Project} — Scroll-Driven Video Sequence

**Global style anchor:**
> Cinematic, {tone} aesthetic. Muted palette: {hexes with names}.
> Soft volumetric light, fine grain, 35mm lens, shallow depth of field,
> 16:9, no text, no logos.

---

## Scene N — "{Title}"

**Beat:** *"{quote from narrative}"*

**Start frame prompt:** > {30–60 words}. [global style]

**End frame prompt:** > {Same composition, transformed}. [global style]

**Motion:** {verb}. (~{N}s)
```

## Rules

- Start and end frames should look like the **same camera + same moment**, with one thing changed. This is what makes I2V smooth.
- Specify lens, lighting, palette.
- No text or logos in the frame (those come from HTML).
- Avoid generic AI tropes: neural-network glow, hexagonal grids, particle-sphere logos, hologram UIs.

## Recommended scene durations

| Role | Duration |
|---|---|
| Hero | 6s |
| Atmospheric | 5s |
| Brand reveal / resolution | 7s |
| Symbol | 6s |
| Practice / services | 8s |
| Method / process | 9s |
| Manifesto / poetic | 6s |
| CTA | 7s |

Save to `info/video-prompts.md`.
