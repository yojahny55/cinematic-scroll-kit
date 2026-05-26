# The Cinematic Scroll Kit — Complete Guide

A step-by-step walkthrough for building a scroll-driven cinematic site, from a blank folder to a deployed page. Written for a single person working with AI tools — no team, no budget for animators, ~4–6 hours of focused work.

---

## Table of contents

1. [Before you start — what you need](#1-before-you-start)
2. [The mental model](#2-the-mental-model)
3. [Phase 1 — Write the narrative](#3-phase-1--narrative)
4. [Phase 2 — Build the storyboard](#4-phase-2--storyboard)
5. [Phase 3 — Generate start & end frames](#5-phase-3--frames)
6. [Phase 4 — Animate frame-to-frame (image-to-video)](#6-phase-4--animate)
7. [Phase 5 — Organize and preprocess clips](#7-phase-5--preprocess)
8. [Phase 6 — Build the site](#8-phase-6--build)
9. [Phase 7 — Mobile pass](#9-phase-7--mobile)
10. [Phase 8 — Polish + ship](#10-phase-8--polish)
11. [Common problems + fixes](#11-troubleshooting)
12. [Tips that will save you hours](#12-tips)
13. [Budget reality check](#13-budget)

---

<a id="1-before-you-start"></a>
## 1. Before you start — what you need

### Required (cannot skip)

| Item | Why | How to get it |
|---|---|---|
| **A laptop with ffmpeg** | Re-encoding the videos | `brew install ffmpeg` (Mac), `apt install ffmpeg` (Linux), [windows installer](https://ffmpeg.org/download.html) |
| **A local web server** | `file://` blocks videos | `python3 -m http.server 8000` from the project folder is enough |
| **An AI coding agent** | Building the site | Claude Code, Cursor, Aider, OpenCode, Antigravity, etc. |
| **An image generator** | Start + end frames | Midjourney, Flux, Nano Banana, Imagen, Ideogram, SDXL |
| **An image-to-video tool** | Animating frames | Kling 2.1, Runway Gen-3, Luma Dream Machine, Sora |
| **3–6 hours of focus** | Generation has wait times — don't context-switch | A free afternoon |

### Brand inputs (gather first)

Before opening any tool, write these down in a notes app:

```
Brand name:
What it does (one sentence):
Industry/domain:
Audience (who buys/uses it):
Promise (what changes for the customer):
Tone — 3 adjectives:
Reference brands (sites you admire):
Color palette (hex codes if you have them):
Optional: tagline, manifesto lines, existing brand voice samples
```

This 10-minute exercise saves 2 hours later.

### Money cost (typical project)

| Service | Plan | Use |
|---|---|---|
| Midjourney | $30/mo or Flux Pro $0.05/image | 9 start frames + 9 end frames = 18 images |
| Kling AI Pro | $10/mo (~5 clips/mo for free) | 9 video clips |
| Runway Gen-3 | $15/mo (10 credits = ~6 clips) | Or use as alt |
| Hosting | Cloudflare Pages / Netlify / Vercel | Free tier is plenty |

You can do an entire site for under **$40 in tool costs**.

---

<a id="2-the-mental-model"></a>
## 2. The mental model

Forget "make videos that go in sections." Think instead:

> **One continuous cinematic reel that the user scrubs with their scroll wheel.**

The site shows a single fixed video stage in the background. As you scroll, the page reveals different copy *in front* of the reel, and the reel itself crossfades from clip 1 → clip 2 → clip 3, with each clip's frame tied 1:1 to your scroll position.

A clip is not "the video for section 5." A clip is **6 seconds of cinematic motion** that the user can replay forward and backward by scrolling. The end frame of clip N visually rhymes with the start frame of clip N+1, so the crossfade is invisible.

That single insight is what makes the difference between "a Squarespace template with videos pasted in" and "an editorial cinematic experience."

---

<a id="3-phase-1--narrative"></a>
## 3. Phase 1 — Write the narrative

**Time:** 20–40 minutes
**Tool:** Any LLM (Claude, GPT-4, Gemini)
**Output:** `info/storytelling.md`

### What you're doing

Writing a 250–400 word brand story that's poetic enough to inspire video imagery but specific enough that someone reading it understands what the brand does.

### Prompt to use

Open Claude/GPT-4 and paste:

```
You are a brand copywriter. Write a 250-400 word brand story for {Brand}, in TWO voices:

Voice A — calm, considered, premium.
Voice B — atmospheric, cinematic, mysterious.

Brand inputs:
- What they do: {your one-sentence description}
- Audience: {audience}
- Promise: {promise}
- Tone: {3 adjectives}

Rules:
- Each paragraph is one visual beat (will become one scene in a video site).
- Use concrete imagery, not abstract claims. Show, don't tell.
- End with the brand name as a 2-line couplet ("{Brand} is X. {Word} is Y.").
- No AI tells: avoid "in today's fast-paced world", "unlock", "elevate", "leverage", "synergy".
- Aim for 4-6 paragraphs per voice.
```

### What good looks like

✅ "In every company there is an invisible city. Corridors of information. Bridges between teams. Silent machines that move decisions."

❌ "In today's fast-paced digital landscape, businesses need innovative solutions to unlock their full potential."

The first sentence is a *scene*. The second is a LinkedIn post.

### Save the file

Save as `info/storytelling.md`. If bilingual, save `info/storytelling.en.md` + `info/storytelling.es.md`.

**Gate check:** Read it out loud. Does each paragraph make you *see* something? If yes, ship. If no, regenerate.

---

<a id="4-phase-2--storyboard"></a>
## 4. Phase 2 — Build the storyboard

**Time:** 30–60 minutes
**Tool:** Any LLM
**Output:** `info/video-prompts.md`

### What you're doing

Converting each narrative paragraph into a video shot — a start frame, an end frame, and the motion between them.

### Prompt to use

```
Read this narrative and produce a 9-scene storyboard for AI image-to-video generation.

For each scene:
1. Beat — quote from the narrative
2. Start frame prompt — concrete description (30-60 words), specifying lens, lighting, palette
3. End frame prompt — same composition as start, with ONE thing transformed
4. Motion — what happens between the two frames
5. Duration — typical: 5-9 seconds

Add a "Global style anchor" paragraph that gets appended to every prompt for consistency.

Palette: {hex codes}
Tone: {adjectives}
Narrative:
{paste storytelling.md}

Output as markdown.
```

### The 9-scene canonical structure (use this as a default)

| # | Role | Typical duration |
|---|---|---|
| 1 | Hero opener / atmospheric intro | 6s |
| 2 | Hidden truth / problem reveal | 5s |
| 3 | Brand reveal / resolution moment | 7s |
| 4 | Symbol / brand mark elaboration | 6s |
| 5 | What we do / practice / services | 8s |
| 6 | Audience / who we serve | 7s |
| 7 | Method / process | 9s |
| 8 | Manifesto / poetic break | 6s |
| 9 | Closing / CTA / "the right moment" | 7s |

Adjust to your story — 7 scenes works, 12 is too many.

### Tip: include a global style anchor

Every prompt ends with:

```
[global style anchor]
> Cinematic, calm aesthetic. Muted palette: slate gray #57676B, sage #9DABA8.
> Soft volumetric light, fine grain, 35mm lens, shallow depth of field, 16:9.
> No text. No logos. No people's faces unless specified.
```

This is what keeps your 9 clips looking like they belong to the same world.

**Gate check:** Read each "Start frame prompt" → "End frame prompt" pair. Can you describe in words what the camera sees changing? If yes, ship. If no, the motion isn't clear enough.

---

<a id="5-phase-3--frames"></a>
## 5. Phase 3 — Generate start & end frames

**Time:** 60–90 minutes
**Tools:** Midjourney v6 / Flux 1.1 Pro / Nano Banana / Imagen
**Output:** 18 images (2 per scene)

### Strategy

Generate **start frame first** for all 9 scenes. Get them all in a row so you can audit the visual consistency. Only *then* generate end frames — use the start frame as a reference (image prompt) so the end frame is visually coherent.

### Workflow per scene

1. Take the **start frame prompt** from `video-prompts.md`.
2. Paste into your image generator with `--ar 16:9` (Midjourney) or aspect-ratio setting.
3. Generate 4 variants. Pick the strongest.
4. Save as `frames/01-start.png`, `frames/02-start.png`, etc.
5. Repeat for all 9 scenes.
6. Lay all 9 start frames side-by-side. Do they look like the same world? If 1–2 stand out, regenerate those. **Visual consistency matters more than individual brilliance.**
7. Now generate end frames. Many tools (Midjourney, Flux) accept the start frame as an "image reference" — use this. The end frame should look like the same camera 5 seconds later.
8. Save as `frames/01-end.png` etc.

### Folder structure for this phase

```
frames/
├── 01-start.png
├── 01-end.png
├── 02-start.png
├── 02-end.png
... (18 total)
```

### Tips that will save you hours

- **Don't chase one perfect scene** — get all 9 to 80% quality first, then iterate. You will regenerate later anyway.
- **Same seed across start/end when possible** — Midjourney `--seed N` or Flux fixed seed keeps the same "world."
- **Reuse the same negative prompt** — `no text, no logos, no people's faces, no UI panels, no holograms`.
- **Lens consistency** — pick 35mm for everything, or 50mm for everything. Mixing lenses (24mm + 85mm) destroys reel feel.
- **Lighting time of day** — pre-dawn / dusk / overcast cinematography reads richer than midday. Avoid bright sunny scenes unless they're the brand's actual identity.
- **Composition** — alternate left-weighted, right-weighted, centered across scenes (don't put the subject in dead center every time).

**Gate check:** Print all 18 frames in a 3×6 grid (or display on screen). Cover the labels. Could a stranger guess which 2 frames belong to the same scene? If yes, you have visual consistency. Ship.

---

<a id="6-phase-4--animate"></a>
## 6. Phase 4 — Animate frame-to-frame

**Time:** 60–120 minutes (mostly waiting for renders)
**Tools:** Kling 2.1 (best for morphs), Runway Gen-3
**Output:** 9 video clips

### The standard image-to-video workflow

Every modern I2V tool has a "Start frame + End frame" mode. Use it.

1. Upload `01-start.png` as the **first frame**.
2. Upload `01-end.png` as the **last frame**.
3. Paste the **motion description** from your storyboard as the prompt.
4. Set duration to the scene's recommended length (5–9s).
5. Set frame rate to **24fps**.
6. Generate.
7. Review: does the motion read smoothly? If the AI fought your frames (e.g. the end frame moved off-screen), regenerate with a clearer motion prompt.
8. Download the clip.
9. Repeat for all 9 scenes.

### Tool-specific notes

**Kling 2.1**
- Best for smooth morph transitions (scene 3 brand reveals, scene 4 symbol blooms).
- Cheapest per clip on the Pro plan.
- Sometimes ignores end frame if motion conflicts — be patient.

**Runway Gen-3**
- Most natural camera motion (great for scene 1 dolly opens, scene 9 reveals).
- Expensive (~$5/clip on standard plan).
- 10-second max per clip.


### Tips

- **Lower the motion strength** if the AI is over-animating. You want subtle drift, not chaos.
- **Don't write "cinematic" in the motion prompt** — it confuses the model. Describe the *verb*: "the threads slowly untangle into a flower," "the monolith lights up from base to top."
- **If a clip fails 3 times**, change the start or end frame, not the motion prompt. The model is telling you those two frames don't have a clear interpolation path.
- **Audio doesn't matter** — we'll strip it anyway. Don't waste credits on tools that include audio generation.

### Save the clips

```
videos/_orig/
├── 01.mp4    (or whatever the tool named it — rename to 01-09 in order)
├── 02.mp4
... (9 total)
```

**Gate check:** Play all 9 clips back-to-back at the actual durations. Does the sequence feel like a film, or 9 disconnected clips? If disconnected, your end-frame-N → start-frame-N+1 transitions aren't matching. Regenerate any that break the flow.

---

<a id="7-phase-5--preprocess"></a>
## 7. Phase 5 — Organize and preprocess clips

**Time:** 5–15 minutes (mostly ffmpeg waiting)
**Tools:** ffmpeg + the scripts in this kit
**Output:** Two video sets — desktop scrub + mobile portrait

### Why preprocessing matters

Raw AI clips are 16:9 with sparse keyframes. They:
- ❌ Stutter when scroll-scrubbed (only one keyframe per ~2 seconds).
- ❌ Leave huge black bars on phones.

We fix both with two ffmpeg passes.

### Step 1 — Stage sources

If your AI tool gave you weird filenames like `hf_20260526_023429.mp4`, rename them:

```bash
cd /path/to/your/project
bash cinematic-scroll-kit/scripts/stage-sources.sh /path/to/raw-downloads videos/_orig
```

The script sorts the files alphabetically and renames them `01.mp4`, `02.mp4`, etc. **Make sure your filenames sort in scene order before running** — otherwise rename them manually first.

### Step 2 — Encode all-keyframe (desktop scrub)

```bash
bash cinematic-scroll-kit/scripts/encode-keyframe.sh videos/_orig videos
```

This adds `-g 1 -bframes 0 -ref 1` — every frame is a keyframe. Result: `video.currentTime = X` instantly snaps to the exact frame, so scroll-scrub is buttery.

Expect ~30% file-size growth. A 6-second clip goes from ~3MB to ~5MB.

### Step 3 — Encode portrait reframe (mobile)

```bash
bash cinematic-scroll-kit/scripts/encode-mobile-portrait.sh videos/_orig videos/mobile
```

This crops the center of each 16:9 clip to 9:16 portrait (720×1280). Result: fills phone screens, no black bars.

Mobile bundle is typically 6–10MB total (vs ~50MB desktop bundle).

### Step 4 — Verify

```bash
for f in videos/*.mp4; do
  ffprobe -v error -select_streams v:0 -show_entries stream=duration,r_frame_rate,width,height -of csv=p=0 "$f"
done
```

You should see:
- Desktop: `1284,716,24/1,6.04` etc.
- Mobile: `720,1280,24/1,6.04` etc.

### Final folder layout

```
videos/
├── _orig/       ← untouched originals (keep these as backup)
│   ├── 01.mp4 .. 09.mp4
├── 01.mp4 .. 09.mp4    ← desktop all-keyframe
└── mobile/
    └── 01.mp4 .. 09.mp4   ← mobile 9:16 portrait
```

---

<a id="8-phase-6--build"></a>
## 8. Phase 6 — Build the site

**Time:** 60–120 minutes
**Tools:** Your AI coding agent + this kit
**Output:** `index.html`, `assets/css/style.css`, `assets/js/main.js`

### Option A — Let the agent do it (recommended)

Tell your agent:

```
Use cinematic-scroll-kit/templates/ as the starting skeleton.
Read cinematic-scroll-kit/skills/04-build-cinematic-scroll-site.md.

Customize for:
- Brand: {name}
- Palette: {hex codes}
- Typography: {your pick from skill 06}
- Storytelling: info/storytelling.md
- Storyboard: info/video-prompts.md
- Content: info/content.md (services, pricing, audience, contact)

The 9 videos are at:
- Desktop: videos/01.mp4 .. videos/09.mp4
- Mobile: videos/mobile/01.mp4 .. videos/mobile/09.mp4

Build the site.
```

The agent reads the skill, copies the templates, customizes them.



### Customization checklist

1. **Palette** in `style.css :root { --ink, --paper, --slate, --moss, --sage, --mist, --bone, --gold }` — set 4 colors + 1 accent.
2. **Fonts** — link the Google Fonts you picked.
3. **9 scenes** — replace copy + HUD labels (`01 — INVISIBLE CITY` etc.) with yours.
4. **Pricing section** — replace with your plans (or delete if you don't sell that way).
5. **Contact form** — wire to whatever backend (Formspree, Netlify Forms, CF7 if WordPress).
6. **Logo SVG** in nav — replace the placeholder.

### Run it

```bash
python3 -m http.server 8000
open http://localhost:8000
```

You must serve over HTTP. `file://` will fail on videos.

**Gate check:** Scroll through the whole site at desktop width. Do the videos scrub smoothly? Do scene transitions feel like one continuous reel, not 9 cuts? If yes, proceed.

---

<a id="9-phase-7--mobile"></a>
## 9. Phase 7 — Mobile pass

**Time:** 30–60 minutes
**Tools:** Browser DevTools device mode
**Output:** Verified working mobile experience

### How to test

1. Open DevTools → toggle device toolbar.
2. Pick **iPhone 14 Pro (390 × 844)**. Hard reload.
3. Console should show `[Kit] mode: MOBILE`.
4. Network tab → filter `.mp4` → requests should go to `videos/mobile/*.mp4` (NOT `videos/*.mp4`).
5. Scroll the page. Each scene's video should autoplay in portrait, fill the screen, loop while you read.
6. The previous scene's video should pause when you leave it.

### Common mobile fixes

| Issue | Fix |
|---|---|
| Console shows `DESKTOP` mode on mobile | Browser viewport is too wide. Hard-reload at 390×844. |
| Landscape video on phone | `data-src-mobile` not set on `<video class="stage__v">`. Add it. |
| First video doesn't autoplay | Missing `playsinline muted` on `<video>`. Add both. |
| Manifesto looks generic | See skill 05 — apply the vertical-stack-with-counters pattern. |
| Text invisible on bright frames | Add the `body.is-mobile .scene__copy::before` readability scrim. |
| Layout breaks at 320px | Test at iPhone SE 375×667 — bump `--gutter` smaller. |

### Test at all 4 viewports

- 375 × 667 (iPhone SE)
- 390 × 844 (iPhone 14)
- 428 × 926 (iPhone 14 Pro Max)
- 820 × 1180 (iPad)

Each should be readable and pleasant.

---

<a id="10-phase-8--polish"></a>
## 10. Phase 8 — Polish + ship

**Time:** 30–90 minutes
**Output:** Deployable site

### Polish pass

Run through this checklist:

- [ ] **`prefers-reduced-motion`** — toggle in DevTools (Rendering panel). Animations should freeze, content visible.
- [ ] **Tab order** — Tab key through the page. Focus visible? Logical order?
- [ ] **Lighthouse score** — Performance should be 85+ on mobile, Accessibility 95+, SEO 90+.
- [ ] **Meta tags** — title, description, OG image, favicon.
- [ ] **Open Graph image** — generate a static screenshot of scene 1 for `og:image`.
- [ ] **Real form backend** — Formspree / Netlify Forms / your CRM. Don't ship a fake `onsubmit`.
- [ ] **Analytics** — Plausible / Fathom / GA4. Track scroll-depth events on each scene.
- [ ] **Legal** — privacy policy + cookie banner if required by your jurisdiction.

### Deploy

The site is just HTML + CSS + JS + MP4s. Any static host works.

**Recommended:** Cloudflare Pages (unlimited bandwidth, generous free tier).

```bash
# from project root
npx wrangler pages deploy . --project-name=mysite
```

Or drag the project folder onto Netlify Drop / Vercel Drop.

### CDN your videos (optional, if traffic is high)

50MB of MP4s per page-view adds up. Move videos to:
- Cloudflare R2 (zero egress fees)
- Bunny CDN (cheap)
- Backblaze B2 + Cloudflare

Update video `src` attributes to point at the CDN URLs.

---

<a id="11-troubleshooting"></a>
## 11. Common problems + fixes

### Videos stutter when scrolling

- Re-run `encode-keyframe.sh`. Verify with `ffprobe -show_frames video.mp4 | grep pict_type=I | wc -l` — should equal total frame count.

### "Access blocked by CORS policy" error

- You opened `index.html` by double-clicking (file://). Serve via HTTP: `python3 -m http.server 8000`.

### First scene shows video 02 instead of 01

- IntersectionObserver threshold too sensitive. Use `rootMargin: '-35% 0% -35% 0%'` (this kit's pattern).

### Mobile shows landscape videos

- `data-src-mobile` attribute missing or not picked up by JS. Check camelCase: `v.dataset.srcMobile` reads `data-src-mobile`. Reload page after fix.

### Text invisible over bright video frames

- Apply the readability scrim (see skill 05). For center-scenes use the radial backdrop pattern.

### Crossfade between scenes is too fast/slow

- Match `transition: opacity 1.4s` in CSS and `setTimeout(..., 700)` in JS. Bigger numbers = slower fade. They should be roughly 2:1 (1.4s transition, 700ms overlap).

### Site feels too "AI-generic"

- Read `skills/06-anti-ai-editorial-design.md`. Fix the typography pairing first (90% of generic look comes from Inter-everywhere).

### Scroll feels janky on touchpad

- Bump Lenis `wheelMultiplier` higher (closer to 1.0). The kit defaults to 0.68 for heavy/cinematic, which feels too slow on some touchpads.

---

<a id="12-tips"></a>
## 12. Tips that will save you hours

### On generation

- **Generate 9 starts first → audit → 9 ends → audit → 9 clips.** Don't go scene-by-scene start-to-finish. The audit gates catch consistency issues early.
- **Pin a "world reference" image** — your strongest start frame from any scene. Reference it in every other prompt as a style anchor.
- **Save your seeds.** Midjourney `--seed N`, Flux `seed N`. When you need to regenerate, same seed = same world.
- **Lighting time-of-day** is the single biggest visual-consistency lever. Pick one (pre-dawn / dusk / overcast) and stick with it.

### On copy

- **Read every line out loud.** If you stumble, rewrite.
- **One idea per sentence.** Cinematic copy is not Twitter — let lines breathe.
- **Italic > bold** for emphasis. Always.
- **Brand name should appear no more than 3 times** in the entire site. Trust the reader.

### On scenes

- **Three patterns of scene layout exist:** left-anchored copy + left-anchored veil, right-anchored copy + right-anchored veil, centered title-card. Use them in *that* order or reversed. Never put two of the same in a row.
- **The manifesto scene (scene 8) is the heart of the site.** Spend more time on these lines than on services copy.

### On performance

- **Lazy-load videos.** The kit does this — don't disable it. First scene loads eagerly, rest load as user approaches.
- **Use `preload="auto"` only on first video.** Others = `preload="metadata"`.
- **WebP for any static images.** Don't ship JPGs in 2026.

### On accessibility

- **Always implement `prefers-reduced-motion`.** Some users get nauseous. WCAG compliance.
- **Captions are not needed** for ambient cinematic loops (decorative content) — but if any video has narration, captions are mandatory.
- **Alt text on the OG image.** Don't ship `og:image` without `og:image:alt`.

### On iteration

- **Ship at 80%, iterate after deploy.** Perfectionism on the first build kills the project. Get it live, then improve specific scenes.
- **A/B test scenes 1, 3, and 9.** These have the highest impact on conversion. Methodology / audience scenes are stable.

---

<a id="13-budget"></a>
## 13. Budget reality check

### Time

| Phase | Best case | Typical | Worst case |
|---|---|---|---|
| Narrative | 20 min | 40 min | 1.5 hours |
| Storyboard | 30 min | 60 min | 2 hours |
| Frames | 60 min | 90 min | 3 hours |
| Animate | 60 min | 2 hours | 4 hours (re-render heavy) |
| Preprocess | 5 min | 15 min | 30 min |
| Build | 1 hour | 2 hours | 6 hours |
| Mobile pass | 30 min | 1 hour | 3 hours |
| Polish | 30 min | 1.5 hours | 4 hours |
| **Total** | **~4 hours** | **~8 hours** | **~25 hours** |

A first project takes ~8 hours of focused work. Your second takes ~4.

### Money

| Item | Cost |
|---|---|
| Midjourney 1 month | $30 |
| Kling Pro 1 month | $10 |
| Hosting (free tier) | $0 |
| Domain | $12/year |
| **Total to launch** | **$40–50** |

### Skill prereqs

- Comfortable in a terminal (ffmpeg, basic git).
- Can read CSS without being scared.
- Knows what JSON looks like.
- Has used an AI coding agent at least once.

If you can change a font in a stylesheet, you can ship this kit.

---

## Appendix — when things go right

A finished cinematic scroll site should feel like:

- A short film that responds to you
- One continuous breath, not 9 separate moments
- Editorial in design, atmospheric in motion
- Honest in copy — the brand says what it actually does

If it feels like a Squarespace template with videos pasted on top, you skipped a phase. Most often: phase 6 (anti-AI editorial design) or phase 2 (the storyboard wasn't tight enough). Go back and re-run.

---

## Next steps after launch

1. **Add a second language.** The HTML already supports it — just add an EN/ES toggle.
2. **Add a "Case study" template** using the same architecture (3 scenes instead of 9, embedded in a longer page).
3. **Record screen-recordings** of the site for social posting (`screencapture -v` on Mac, `ffmpeg` on Linux).
4. **Build a portfolio sub-site** showcasing 4–5 of these — same kit, different stories.

Once you've shipped one, you can ship another in an afternoon.

---

