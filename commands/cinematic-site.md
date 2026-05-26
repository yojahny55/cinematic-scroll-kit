# /cinematic-site

End-to-end pipeline for building a scroll-driven cinematic site with AI video.

**Use this command when:** the user says *"build me a cinematic story site"*, *"scroll-driven hero with video"*, *"motion narrative site"*, or similar.

## Phase orchestration

Run these phases sequentially. Confirm with user before moving to the next.

### Phase 1 — Narrative
- Invoke skill: `narrative-from-brand` (`skills/01-narrative-from-brand.md`).
- Output: `info/storytelling.md` (or `.en.md` + `.es.md` bilingual).
- Gate: user confirms narrative reads true.

### Phase 2 — Storyboard
- Invoke skill: `storyboard-from-narrative` (`skills/02-storyboard-from-narrative.md`).
- Output: `info/video-prompts.md` with N scenes (typically 9), each with start-frame prompt, end-frame prompt, motion description, duration.
- Gate: user reviews + edits prompts before generating clips.

### Phase 3 — User generates clips (external step)
- User pastes generated clips into a folder. Each clip's duration should match the storyboard's recommended duration.
- Gate: confirm folder path. Source files should be sortable in scene order.

### Phase 4 — Video preprocessing
- Invoke skill: `video-preprocessing` (`skills/03-video-preprocessing.md`).
- Run `scripts/stage-sources.sh` → `scripts/encode-keyframe.sh` → `scripts/encode-mobile-portrait.sh`.
- Output: `videos/01.mp4 … 0N.mp4` (desktop) + `videos/mobile/01.mp4 …` (mobile).
- Gate: ffprobe verification + total file size report.

### Phase 5 — Build site
- Invoke skill: `build-cinematic-scroll-site` (`skills/04-build-cinematic-scroll-site.md`).
- Copy `templates/index.html`, `templates/style.css`, `templates/main.js` as starting points.
- Customize palette, typography, scene count, copy.
- Output: `index.html`, `assets/css/style.css`, `assets/js/main.js`.
- Gate: serve over HTTP (not file://), test in browser.

### Phase 6 — Mobile pass
- Invoke skill: `adaptive-mobile-strategy` (`skills/05-adaptive-mobile-strategy.md`).
- Verify the mobile experience at 375 / 390 / 428 / 820 / 1024.
- Gate: console log shows `MOBILE` mode + portrait videos loading.

### Phase 7 — Design polish
- Invoke skill: `anti-ai-editorial-design` (`skills/06-anti-ai-editorial-design.md`).
- Self-audit against the 7 commitments + forbidden tropes list.
- Iterate until 3+ "good" answers.

## Quick reference

| Step | Skill | Output |
|---|---|---|
| 1 | narrative-from-brand | storytelling.md |
| 2 | storyboard-from-narrative | video-prompts.md |
| 3 | (user generates) | clips in folder |
| 4 | video-preprocessing | videos/ + videos/mobile/ |
| 5 | build-cinematic-scroll-site | index.html + css + js |
| 6 | adaptive-mobile-strategy | mobile-tested site |
| 7 | anti-ai-editorial-design | polished site |

## Anti-patterns to refuse

If the user pushes for any of these, push back politely:
- ❌ "Just use stock video instead of AI" — stock looks stock; the site loses its uniqueness.
- ❌ "Skip the storyboard, just give me prompts" — without a narrative, scenes don't cohere.
- ❌ "Use Bootstrap / Tailwind cards" — kills the editorial design language.
- ❌ "Don't bother with mobile" — 60–70% of traffic. Non-negotiable.

## Deliverable structure

```
project/
├── info/
│   ├── storytelling.md
│   └── video-prompts.md
├── videos/
│   ├── _orig/      (untouched source)
│   ├── 01.mp4..    (all-keyframe desktop)
│   └── mobile/
│       └── 01.mp4..(9:16 portrait)
├── assets/
│   ├── css/style.css
│   └── js/main.js
├── index.html
└── README.md       (run instructions)
```
