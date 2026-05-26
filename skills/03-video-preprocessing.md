---
name: video-preprocessing
description: Use after the user has generated AI video clips and needs to prepare them for scroll-scrub playback and mobile portrait variants. Runs ffmpeg with all-keyframe encoding (frame-perfect seek) and 9:16 center-crop reframes. Required before building the site.
---

# Video Preprocessing

Raw AI-generated MP4 clips are not suitable for scroll-scrub playback. They:
- Have keyframes every ~48 frames → `video.currentTime = X` stutters because the browser can only decode from the previous keyframe.
- Are 16:9 → leave huge black bars on phones.

This skill produces:
1. **Desktop set** — all-keyframe MP4 for buttery scroll scrub.
2. **Mobile set** — 9:16 portrait reframes (center-cropped) for autoplay-loop on phones.

## Prerequisites

- `ffmpeg` installed (test with `which ffmpeg`).
- Source clips in a folder, named however the AI tool exported them.

## Steps

1. **Stage the sources** into `videos/_orig/01.mp4 … 09.mp4` (or whatever numbering matches your storyboard).
   - The kit's `scripts/stage-sources.sh` can rename arbitrary generated files into sequential `01..NN.mp4`.

2. **Encode desktop set** (all-keyframe) into `videos/01.mp4 … 09.mp4`:
   ```
   scripts/encode-keyframe.sh videos/_orig videos
   ```
   Expect ~30% file-size increase; total project usually 40–60MB for 9 clips.

3. **Encode mobile set** (9:16 portrait, lower bitrate) into `videos/mobile/01.mp4 …`:
   ```
   scripts/encode-mobile-portrait.sh videos/_orig videos/mobile
   ```
   Mobile bundle is typically 6–10MB.

4. **Verify**:
   ```
   ffprobe -v error -select_streams v:0 -show_entries stream=duration,r_frame_rate,width,height -of csv=p=0 videos/01.mp4
   ```
   Should return `1284,716,24/1,6.04` or similar. Mobile should be `720,1280,24/1,6.04`.

## What's actually happening in the ffmpeg flags

| Flag | Purpose |
|---|---|
| `-g 1 -keyint_min 1 -sc_threshold 0` | Every frame is a keyframe (GOP = 1). |
| `-x264-params rc-lookahead=0:ref=1:bframes=0` | No B-frames, no reference frame magic. Pure I-frames. |
| `-an` | Strip audio (we don't use it; saves bandwidth). |
| `-crf 20` (desktop) / `24` (mobile) | Quality vs size trade-off. |
| `-pix_fmt yuv420p` | Maximum browser compatibility (Safari, especially). |
| `-movflags +faststart` | Moves the moov atom to the start so the file can play before fully downloaded. |
| `scale=-2:1280,crop=720:1280:(iw-720)/2:0` (mobile) | Scales to 1280 tall keeping aspect, then center-crops 720 wide. |

## Edge cases

- **Source already portrait?** Skip the mobile crop step (or use `scale=720:1280:force_original_aspect_ratio=increase,crop=720:1280`).
- **Source has audio you want to keep?** Drop `-an`. Note: autoplay-with-sound is blocked in browsers, so audio is usually pointless.
- **Source is webm/mov?** ffmpeg auto-detects input format, no flag change needed.
- **Want even smaller mobile files?** Bump `-crf` to 26–28; quality drop is acceptable for ambient loops.

## Skill output

Confirm to the user:
- ✓ Desktop set: 9 files, all-keyframe, total {N}MB
- ✓ Mobile set: 9 files, 720×1280, total {N}MB
- Average scrub-step duration: 24fps × 6s = 144 keyframes per clip = ~40ms per seek = silky.

Proceed to `skills/04-build-cinematic-scroll-site.md`.
