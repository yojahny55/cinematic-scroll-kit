# Cinematic Scroll Kit

> Build **scroll-driven cinematic storytelling sites with AI-generated video** — across any AI coding agent.

**Repo:** https://github.com/yojahny55/cinematic-scroll-kit
**Issues / contributing:** https://github.com/yojahny55/cinematic-scroll-kit/issues

A reusable methodology, skill pack, and code skeleton for shipping editorial cinematic websites where each scroll position reveals a different scene of an AI-generated video reel. Works with Kling / Runway / Sora / Luma for video, Midjourney / Flux for stills, and any AI coding agent (Claude Code, Cursor, Codex, Aider, OpenCode, Antigravity) for the build.

**Read `GUIDE.md` for the complete step-by-step walkthrough.**

---

## What you get

```
cinematic-scroll-kit/
├── AGENTS.md                # master methodology — read this first
├── GUIDE.md                 # full operational walkthrough (start here if you're new)
├── README.md                # this file
├── skills/                  # 6 skill files (Claude Code frontmatter format)
│   ├── 01-narrative-from-brand.md
│   ├── 02-storyboard-from-narrative.md
│   ├── 03-video-preprocessing.md
│   ├── 04-build-cinematic-scroll-site.md
│   ├── 05-adaptive-mobile-strategy.md
│   └── 06-anti-ai-editorial-design.md
├── commands/                # portable slash-commands (any agent)
│   ├── cinematic-site.md    # full pipeline orchestrator
│   └── storyboard.md        # storyboard-only quick command
├── scripts/                 # ffmpeg helpers
│   ├── stage-sources.sh     # rename AI-generated clips to 01..NN.mp4
│   ├── encode-keyframe.sh   # all-keyframe MP4 (for desktop scroll-scrub)
│   └── encode-mobile-portrait.sh   # 9:16 portrait reframe (for mobile loop)
├── schemas/                 # machine-readable contracts for host generators
│   └── scene.json           # canonical scene shape (consumed by claude-wp-builder)
└── templates/               # drop-in HTML / CSS / JS skeletons
    ├── index.html
    ├── style.css
    ├── main.js
    ├── scenes.json          # default 9-scene manifest for /wp-cinematic-seed
    └── README.md
```

---

## WordPress integration (claude-wp-builder)

The kit ships with a `schemas/scene.json` contract that [`claude-wp-builder`](https://github.com/yojahny55/claude-wp-builder) reads to generate ACF/SCF fields, template parts, and seed scripts — so you can take a cinematic demo all the way to a WordPress theme without hand-wiring custom fields.

```bash
# 1. Install the kit as a skill
npx skills add yojahny55/cinematic-scroll-kit -g -y

# 2. Scaffold a cinematic WP theme
/wp-cinematic-init --path=./my-site

# 3. Replace placeholder videos with real ones
/wp-cinematic-encode raw-scene-3.mp4 --scene=3 --poster

# 4. Author scenes inline
/wp-cinematic-scene 3 --eyebrow "Field log — 03" --headline "Architecture is leverage."
```

Hybrid demos (cinematic reel + trailing pricing/contact sections) are supported via `/wp-section <name> --hybrid`. See [`docs/cinematic-mode.md`](https://github.com/yojahny55/claude-wp-builder/blob/main/docs/cinematic-mode.md) in the plugin repo for the full walkthrough.

---

## What this kit produces

A single-page site where:

- A narrative (the brand's "story") is split into **N scenes** (typically 6–10).
- Each scene has a **paired AI video clip** (start frame → end frame → image-to-video).
- The user scrolls through **one continuous cinematic reel** — videos crossfade between scenes, copy fades in over the active frame.
- On **desktop**: scroll position drives `video.currentTime` (frame-perfect scrub).
- On **mobile**: scenes autoplay-loop with portrait reframed videos (no scroll hijacking).

End-to-end pipeline: narrative → storyboard → frame generation → video generation → preprocessing → build → mobile pass → polish → ship.

A first-time project takes ~6–8 hours. Subsequent projects ~4 hours.

---

## Per-agent install

### Claude Code

```bash
# Option A: project-level skills
mkdir -p .claude/skills
cp cinematic-scroll-kit/skills/*.md .claude/skills/

# Option B: user-level (available across all your projects)
cp cinematic-scroll-kit/skills/*.md ~/.claude/skills/
```

Then in chat: *"use the storyboard-from-narrative skill on info/storytelling.md"*.

### Cursor / Continue / Windsurf

Add the kit folder to your project. Reference any skill by name in chat:

> "apply the anti-ai-editorial-design skill to my hero section"

### OpenCode / Codex / Aider / generic CLI agents

Paste `AGENTS.md` + the relevant skill file as system context:

```bash
agent --system "$(cat cinematic-scroll-kit/AGENTS.md)" \
      --system "$(cat cinematic-scroll-kit/skills/02-storyboard-from-narrative.md)"
```

### Antigravity

Antigravity automatically reads `AGENTS.md` at the repo root. Drop the kit's `AGENTS.md` there (or symlink) and you're done.

### Bring-your-own-LLM (raw API)

Treat `AGENTS.md` as the system prompt. Append the user request. Load skill files as additional system messages or as retrieval context.

---

## Quick start

```
1. Read GUIDE.md.

2. Tell your agent:
   "Build me a scroll-driven cinematic site for {brand}.
    Use the cinematic-scroll-kit at <path-to-kit>."

3. Agent runs:
   narrative-from-brand
   → storyboard-from-narrative
   → (you generate clips externally — Kling/Runway/Sora)
   → video-preprocessing
   → build-cinematic-scroll-site
   → adaptive-mobile-strategy
   → anti-ai-editorial-design

4. You ship.
```

---

## What this kit assumes

- **Image generator** access (Midjourney / Flux / Nano Banana / Imagen / Ideogram / SDXL).
- **Image-to-video tool** access (Kling 2.1 / Runway Gen-3 / Luma Dream Machine / Sora).
- **`ffmpeg`** installed locally (or in the agent's sandbox).
- Deliverable hosted over **HTTP** (file:// blocks video CORS).

Typical out-of-pocket cost for a complete project: **$30–50** in image + video credits.

---

## What this kit doesn't do

- ❌ Generate the video clips for you. Use Kling, Runway, Sora, etc.
- ❌ Provide hosting / CMS / backend.
- ❌ Auto-translate content. The skills support bilingual builds; you bring the translations.
- ❌ Design your logo or brand identity. Bring those — the kit handles motion, layout, and typography.

---

## License

MIT.

External runtime dependencies (loaded via CDN, not bundled):
- [Lenis](https://github.com/studio-freight/lenis) — MIT
- [GSAP + ScrollTrigger](https://greensock.com/gsap/) — free for personal / non-commercial use. Commercial use requires a Club GreenSock license.

If you ship a commercial site, license GSAP appropriately or replace ScrollTrigger with a self-rolled IntersectionObserver implementation.

---

## Contributing

This is methodology + code. PRs welcome for:
- Additional skills (e.g. SEO, structured data, alternate motion patterns).
- Additional templates (case-study layout, portfolio grid layout).
- Alternative I2V tool integrations.
- Translation of skill files to other languages.

Please keep the skills format consistent: Claude Code YAML frontmatter (`name` + `description`) so they remain auto-discoverable.
