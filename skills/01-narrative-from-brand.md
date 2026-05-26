---
name: narrative-from-brand
description: Use when starting a new cinematic-scroll project and the brand has no written narrative yet. Generates a 250-400 word brand story in two voices (calm/poetic AND mysterious/futuristic) that the storyboard skill will later split into scenes.
---

# Narrative from Brand

You are writing the **storytelling document** that will become the script for a scroll-driven cinematic site. The narrative must be short (250–400 words), evocative, and broken into clear beats that map naturally to 6–10 visual scenes.

## Input you need from the user

1. Brand name + one-line description.
2. Industry / domain.
3. Audience (who they serve).
4. Core promise / value proposition.
5. Tonal anchors (e.g. "calm, technical, premium" or "playful, fast, irreverent").
6. Optional: existing taglines, manifesto lines, or brand keywords.

If any of these are missing, ask up to 3 short questions to fill the gaps. Do not invent the brand for them.

## Structure to produce

```
# {Brand}

## Voice A — {primary tone}

{4–6 short paragraphs. Each paragraph is one "beat". Each beat is the seed for one scene.
Use concrete metaphors, not abstract jargon. Show, don't claim.
End with the brand promise as a 2-line couplet.}

## Voice B — {alternate tone}

{Same story re-told in a different register. Often more atmospheric/cinematic.
This gives the storyboarder freedom to pick the more visual version per scene.}
```

## Rules

- **Concrete imagery beats abstract claims.** "Corridors of information, bridges between teams" >> "complex workflows."
- **Each paragraph = one scene candidate.** Aim for visual specificity ("a flower and a blueprint" reads as one shot; "we are innovative" does not).
- **End on a moment of resolution** — usually the brand name spoken as a couplet ("X is the moment. Y is the way to build it.").
- **Avoid AI tells:** no "in today's fast-paced world", "unlock", "elevate", "leverage", "synergy", or em-dash-heavy listicles.
- **Bilingual if requested** — produce both languages side-by-side in clearly labelled sections.

## Example output (truncated)

```markdown
# {Brand Name}

## Voice A — calm, technical

{Brand} is born from a simple idea: the best {category} are not imposed; they are revealed.

Every {customer type} has an internal architecture: {nouns specific to your domain — workflows, materials, signals, conversations, frictions}. Some parts are visible. Others remain hidden — until the {failure mode} begins.

We design {product type} to find the exact point where {abstract problem} becomes {concrete outcome}.

[…]

{Brand-first-word} is the {core concept}.
{Brand-second-word} is the way to build it.
```

*(The above is a structural template — never copy these exact words. Use them as a shape to fill with the actual brand's specifics.)*

## Deliverable

Save to `info/storytelling.md` (or `info/storytelling.en.md` + `info/storytelling.es.md` if bilingual). Confirm with the user before proceeding to storyboard.

---

**Next step:** invoke `skills/02-storyboard-from-narrative.md` on this file.
