# SmartFormat Product Architecture

## Product Positioning

SmartFormat is a modern, clean, low-cost, cross-platform format factory for everyday users. It should feel more polished than legacy converter tools, simpler than professional transcoding software, and safer than online converters because files stay local.

The product goal is not to beat every professional media tool. The goal is to support enough common format, compression, extraction, and batch workflows to become a daily utility that can sustain a solo business.

## Core Advantages

- Cross-platform Flutter app for Windows, macOS, Linux, Android, and iOS.
- FFmpeg-based processing through `ffmpeg-kit-extended`.
- Low operating cost as a solo company.
- Clean UI, no bundled software, no aggressive ads.
- Low price compared with traditional paid converter suites.

## Product Principles

- Build a broad product shelf first, then fill each shelf gradually.
- Start with media formats before expanding into documents or cloud workflows.
- Keep basic single-file tasks free forever.
- Make Pro features about efficiency, scale, and advanced quality rather than taking away basic tools.
- Prefer task names users understand over codec-heavy language.
- Always show clear output location, estimated result, progress, and failure reason.

## Top-Level Information Architecture

```text
SmartFormat
├── Video
├── Audio
├── Image
├── Batch Tasks
└── Toolbox
```

## Video Processing

Video is the most important category. It creates the strongest user perception of value and covers many common FFmpeg workflows.

### Initial Items

- Format conversion
- Video compression
- Extract audio
- Video to GIF
- Video to Live Photo

### Later Items

- Trim video
- Merge videos
- Remove audio
- Replace audio
- Extract cover frame
- Burn subtitles
- Convert subtitles to video captions
- Change container without re-encoding
- Platform presets for Bilibili, Douyin, Xiaohongshu, WeChat Channels, YouTube, and Instagram

### Notes

Video to Live Photo should be treated as a high-perceived-value feature. It can become a Pro feature after the early free period because it feels more special than ordinary conversion.

## Audio Processing

Audio should cover simple conversion first, then move into quality improvement and creator workflows.

### Initial Items

- Format conversion
- Audio compression
- Audio noise reduction
- Extract audio from video

### Later Items

- Normalize volume
- Trim audio
- Merge audio
- Convert to ringtone
- Change sample rate
- Convert mono/stereo
- Remove silence
- Loudness target presets for podcast and video publishing

### Notes

Noise reduction is valuable but quality-sensitive. The first version can use a conservative preset and expose a simple strength control later.

## Image Processing

Image processing makes the product feel more like a complete format factory, while keeping early implementation manageable.

### Initial Items

- Format conversion
- Image compression
- HEIC to JPG/PNG

### Later Items

- Resize images
- WebP conversion
- AVIF conversion
- GIF frame extraction
- Create GIF from images
- Batch rename
- Remove metadata
- Convert live photo assets

### Notes

Image features should be designed for batch use from the beginning, even if batch processing is gated as a future Pro capability.

## Batch Tasks

Batch processing is the core Pro value. It saves user time and gives a clear reason to pay.

### Initial Items

- Task queue
- Batch conversion
- Batch compression
- Failed task retry
- Task records

### Later Items

- Concurrent task control
- Output naming templates
- Watch folder automation
- Import/export presets
- Pause and resume queue

## Toolbox

Toolbox contains utility actions that do not belong to one main category or are shared across media types.

### Initial Items

- View media information
- Open output folder
- Recent task records

### Later Items

- Subtitle format conversion
- Subtitle burn-in
- Metadata removal
- Container remux
- Check file compatibility
- Estimate output size

## MVP Scope

The first usable version should ship with a complete product shell and a small number of working tools in each main category.

### MVP Closed Loop

The MVP is complete only when a user can finish one real processing job from start to end:

```text
Open app
-> Choose a tool
-> Choose input source
-> Select files
-> Preview file information
-> Adjust simple options
-> Choose output target
-> Start task
-> Track progress
-> View result
-> Open, save, share, retry, or report a problem
-> Find the task later in Task Records
```

This closed loop matters more than the number of tools. A small set of reliable tools is better than many entries that cannot produce, save, or recover results clearly.

### MVP Features

- Home page with Video, Audio, Image, and Toolbox category tabs.
- Bottom navigation with Home, Tasks, and Settings.
- Video format conversion.
- Video compression.
- Extract audio from video.
- Video to GIF.
- Video to Live Photo.
- Audio format conversion.
- Audio compression.
- Basic audio noise reduction.
- Image format conversion.
- Image compression.
- HEIC to JPG/PNG.
- Task queue with progress, success, failure, and cancel states.
- Task records with input file, output file, tool type, time, status, and quick actions.
- Input source selection.
- Output target selection.
- File preview and preflight validation.
- Permission request and denied-permission recovery.
- Result page after task completion.
- User-friendly error messages.
- Temporary file and cache cleanup.
- Basic first-launch explanation.
- Feedback entry from Settings and failed tasks.
- Privacy policy, user agreement, and open source license entries.
- Output folder selection.
- Basic media information view.

### MVP Input Sources

Input source is about where files come from. It should be independent from tools and output targets.

Initial input sources:

- Photo library.
- System file picker.
- Share from other apps.
- Recent files or recent task records.

Deferred input sources:

- Cloud drive import.
- Network URL import.
- Camera capture.
- Screen recording.

Cloud drive should be deferred because it brings account login, authorization, transfer progress, retry, privacy, and support complexity.

### MVP Output Targets

Output target is about where processed files go. It should be independent from tools and input sources.

Initial output targets:

- App result storage.
- Save to photo library.
- Save to system files.
- Share to other apps.

Deferred output targets:

- Cloud drive export.
- Automatic export rules.
- Watch folder output.

Every completed task should show where the output file is stored. If saving fails, the user should still be able to find the temporary result when possible and choose another output target.

### File Preflight

Before processing starts, the app should inspect the selected file and show enough information to reduce confusion.

Preflight should show:

- File name.
- File type.
- File size.
- Duration for video and audio.
- Resolution for video and image.
- Current format or container.
- Expected output format.
- Basic compatibility status.

Preflight should block or warn when:

- The file type is unsupported.
- The file cannot be read.
- The selected output target is unavailable.
- Free storage is likely insufficient.
- Required permission is missing.

### Permissions

Permissions are part of the product flow, not a technical afterthought.

MVP permission cases:

- Read from photo library.
- Save to photo library.
- Pick files from system storage.
- Receive files shared from other apps.
- Optional notification permission for long-running tasks.

If permission is denied, the app should explain why it is needed and offer a path to system settings. The user should not be trapped on a dead page.

### Result Page

After a task completes, the user should land on a clear result page or result sheet.

The result page should show:

- Output file name.
- Output size.
- Save location.
- Tool used.
- Processing status.
- Open action.
- Share action.
- Save again action.
- Process another file action.
- View task record action.

This page closes the loop. It tells users what happened, where the result is, and what they can do next.

### Error Handling

FFmpeg errors should be translated into user-facing messages.

Initial error categories:

- Unsupported format.
- File cannot be read.
- File appears damaged.
- Permission denied.
- Storage space is insufficient.
- Output target failed.
- Encoder or decoder unavailable.
- Task canceled.
- Unknown processing failure.

Each failed task should show a short explanation and at least one next action:

- Retry.
- Choose another output format.
- Choose another output location.
- Report this issue.
- Delete task record.

### Storage And Cache

Media processing can quickly consume storage, so storage behavior must be clear in the MVP.

The app should separate:

- Temporary processing files.
- App result files.
- Task record metadata.
- Diagnostic logs.

Settings should include clear cache. The task record should survive cache cleanup, but it should mark missing output files if the file no longer exists.

### First Launch

First launch should be short and trust-building.

It should explain:

- Media processing happens on the device in the MVP.
- Basic features are free.
- Results can be found later in Task Records.

Do not use a long onboarding flow. Let the user start processing quickly.

### Feedback

Feedback should be available from Settings and failed task records.

When reporting from a failed task, the app can attach:

- App version.
- Device model.
- OS version.
- Tool type.
- Error category.
- FFmpeg error summary.

The app should not upload the user's input or output files unless the user explicitly chooses to attach them.

### Legal And Trust

The MVP should include visible legal and trust entries before public release:

- Privacy policy.
- User agreement.
- Open source licenses.
- FFmpeg and related codec license notes.
- Local processing explanation.

This is especially important because the app handles private media files.

### Deferred From MVP

- PDF and Office conversion.
- OCR.
- Cloud upload or cloud transcoding.
- Full video editing timeline.
- Screen recording.
- AI upscaling.
- Team accounts.

## Free And Pro Strategy

SmartFormat should be generous early, but the commercial boundary should be clear from day one.

### Free Forever

- Single-file video conversion.
- Single-file audio conversion.
- Single-file image conversion.
- Basic video compression.
- Basic image compression.
- Extract audio from video.
- View media information.
- Common output presets.

### Early Free, Future Pro

- Batch conversion.
- Batch compression.
- Task record retention.
- Video to Live Photo.
- Audio noise reduction.
- Subtitle burn-in.
- Hardware acceleration controls.
- Custom presets.
- Watch folder automation.
- Advanced output naming.

### User-Facing Message

SmartFormat early versions open all features for free testing. After the official release, basic features will remain free forever, while advanced efficiency features will move to Pro. Early users will receive special upgrade benefits.

## Suggested Pricing

Pricing should be low enough for a solo utility business and simple enough to avoid purchase hesitation.

### China

- Early lifetime: RMB 29-49.
- Official lifetime: RMB 68-98.
- Optional yearly plan: RMB 38-58 per year.

### International

- Early lifetime: USD 9.99-19.99.
- Official lifetime: USD 24.99-39.99.
- Optional yearly plan: USD 9.99-14.99 per year.

## Mobile UI Structure

### Home

The home page should show the product as a complete utility suite while staying friendly for one-handed mobile use:

- Top area: app name, current Pro/early access state, and a small settings entry.
- Main area: category tabs for Video, Audio, Image, and Toolbox.
- Tool list: a scrollable card list under the selected category tab.
- Quick actions: optional pinned cards for the most common tools, such as video conversion, video compression, extract audio, and image conversion.
- Active task strip: a compact progress entry when tasks are running.
- Recent task records and output shortcuts.

### Bottom Navigation

Mobile should use bottom navigation only for global destinations:

- Home
- Tasks
- Settings

Video, Audio, Image, and Toolbox should not be bottom navigation items. They belong inside Home as category tabs, because they are tool categories rather than app-level destinations.

### Tasks

Tasks should combine active processing and task records. Users need one place to see what is running now and what was processed before.

The page should have two sections or tabs:

```text
Current Tasks | Task Records
```

Current Tasks shows the current queue:

- Waiting tasks.
- Running tasks with progress.
- Failed tasks with retry.
- Canceled tasks.

Task Records shows all task records, including completed, failed, and canceled work:

- Original input file name and source.
- Output file name and save location.
- Tool used, such as video compression or image conversion.
- Created time.
- Processing status.
- Basic settings summary, such as output format or compression level.
- Quick actions: open, share, save again, retry, delete record.

Task records should not be treated as permanent file backup. If the output file is deleted outside the app, the app should show that the file is missing and offer to remove the record or retry from the original input if available.

### Settings

Settings is a required top-level page because it carries trust, support, localization, legal, and product account states.

Initial settings items:

- Language.
- Feedback.
- User agreement.
- Privacy policy.
- About SmartFormat.
- App version.
- Clear cache.
- Default output location.
- Early access or Pro status.

Later settings items:

- Restore purchases.
- Manage subscription or license.
- Contact support.
- Rate the app.
- Open source licenses.
- Diagnostic logs.
- Theme mode.
- Notification preferences.
- Default processing quality.

Settings should stay simple and grouped into sections:

```text
General
- Language
- Theme mode
- Default output location

Support
- Feedback
- Contact support
- Rate the app

Account & Pro
- Early access / Pro status
- Restore purchases
- Manage license

Privacy & Legal
- Privacy policy
- User agreement
- Open source licenses

Storage
- Clear cache
- Diagnostic logs

About
- App version
- About SmartFormat
```

### Home Category Tabs

Home should use category tabs:

```text
Video | Audio | Image | Toolbox
```

The selected tab should show a vertical `ListView` of tool cards. Each card should have:

- Tool name.
- One-line purpose.
- Supported common formats or a short tag.
- Free, early access, or future Pro state if needed.
- Chevron or primary action affordance.

Example:

```text
Video tab
- Format Conversion
- Video Compression
- Extract Audio
- Video to GIF
- Video to Live Photo
```

### Tool Detail Page

Each tool should follow the same pattern:

```text
Select files
-> Choose output format or goal
-> Adjust simple options
-> Choose output location
-> Start task
-> View progress and result
```

Advanced settings should be collapsed by default.

### Task Queue

The task queue should be a first-class part of the product, not a hidden progress dialog.

Required states:

- Waiting
- Running
- Completed
- Failed
- Canceled

Each task should show input file, output format, progress, output path, and clear error text if it fails.

## Technical Product Notes

- Use a shared task model for all tools.
- Each tool should generate a structured processing request before converting it into an FFmpeg command.
- Avoid scattering raw FFmpeg command strings across UI files.
- Keep command generation, task execution, progress parsing, and UI state separate.
- Design the feature registry so new tool items can be added without rewriting navigation.

## Roadmap

### Phase 1: Product Shell

- Create Flutter app shell.
- Build mobile bottom navigation and tool registry.
- Add empty tool pages for all planned categories.
- Implement task queue UI.

### Phase 2: Core Media Tools

- Implement video conversion.
- Implement video compression.
- Implement extract audio.
- Implement audio conversion.
- Implement image conversion.
- Implement image compression.

### Phase 3: High-Value Tools

- Implement video to GIF.
- Implement video to Live Photo.
- Implement audio noise reduction.
- Implement HEIC conversion.
- Add task record retention.

### Phase 4: Pro Preparation

- Add feature flags for Pro capabilities.
- Add early-user messaging.
- Add license state model.
- Add pricing page or upgrade screen.

### Phase 5: Growth Features

- Add platform presets.
- Add subtitle tools.
- Add watch folder automation.
- Add advanced batch naming.

## Success Metrics

- Users can understand what the app does within 10 seconds.
- A new user can convert one file without reading documentation.
- A batch workflow saves enough time that paying feels reasonable.
- The product feels trustworthy: no ads, no bundled software, clear local file processing.
- Adding a new tool item should be mostly configuration plus command generation, not a new app architecture.
