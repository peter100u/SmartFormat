# Mova Settings MVP Design

## Goal

Turn the current placeholder settings screen into a testable MVP settings center where every visible entry is interactive and useful. This work should stay aligned with the existing product docs and current app maturity: local-first, lightweight, and focused on trust/support rather than a heavy account or preference system.

## Current State

The existing settings screen is a static page with grouped `ListTile` placeholders:

- Language
- Feedback
- Privacy Policy
- User Agreement
- License
- Clear Cache
- App Version
- About Mova

The page has no controller, no navigation targets, no runtime app info, no cache cleanup behavior, and no real service integration for feedback. The product docs, however, already treat all of these as MVP requirements.

## Scope

This implementation will make every current settings entry functional:

- `多语言`
- `意见反馈`
- `隐私政策`
- `用户协议`
- `许可证`
- `清理缓存`
- `App 版本`
- `关于 Mova`

This implementation will not expand scope into:

- theme mode
- account/login
- remote CMS-backed legal content
- rating/review prompts
- advanced diagnostics upload

## Recommended Approach

Use a lightweight feature-first settings module with:

- one settings controller for page-level actions and async state
- dedicated secondary pages for legal/about/version/language details
- thin service integrations for runtime app info, feedback launching, and cache cleanup
- local embedded content for legal/license/about pages, sourced from the existing product docs and static app copy

This is preferred over a “fake clickable placeholder” approach because the user explicitly wants the page fully implemented, and it is preferred over a larger preferences system because the rest of the app is still MVP skeleton code.

## UX Design

### Settings Home

Keep the existing grouped structure and visual hierarchy. Each row becomes tappable and performs one of these behaviors:

- `多语言`: push a language selection page
- `意见反馈`: trigger feedback flow directly, then show success/failure message
- `隐私政策`: push a legal document page
- `用户协议`: push a legal document page
- `许可证`: open a placeholder external link
- `清理缓存`: show a confirmation dialog, then clear cache and show result
- `App 版本`: push a version/app info page
- `关于 Mova`: push an about page

### Secondary Pages

Secondary pages should stay simple and native:

- standard `Scaffold + AppBar + ListView`
- readable spacing
- no modal-heavy UX except cache cleanup confirmation/result
- content-first layout for about/version pages

## Architecture

### New Feature Boundary

Add a small settings feature layer:

- `settings_page.dart`: settings home UI
- `settings_controller.dart`: user actions and async state
- `settings_state.dart`: loading/progress/snackbar-friendly state
- additional settings detail pages under `features/settings/`

This keeps settings-specific logic out of the generic app/router layer.

### Route Design

Add routes for:

- language settings
- app version/details
- about

Each route should be explicit and named, following the existing `go_router` style.

## Data and Services

### Language

Implement app locale switching with persistence.

This setting must be controlled by Mova itself, not by the device system language. Once the user selects a language in settings, the app should render in that language regardless of the phone’s current locale until the user changes it again inside Mova.

Use:

- `shared_preferences` to persist selected locale
- a Riverpod-backed app locale provider
- `MaterialApp.router(locale: ...)` to apply the chosen locale

Supported values:

- `zh`
- `en`

Behavior rules:

- first launch may choose a concrete default locale
- after the first explicit user selection, Mova must always use the in-app preference
- do not add a “follow system” option in this MVP

### App Info

Replace the pending app info service with a runtime implementation using `package_info_plus`.

The version page should show:

- app name
- version
- build number
- package name

### Feedback

Replace the pending feedback service with a `mailto:`-based implementation using `url_launcher`.

The generated feedback payload should include:

- app name
- app version
- build number
- package name

For this MVP, no user media or task logs are attached.

If no mail client is available, show a user-friendly failure message.

### Cache Cleanup

Implement a cache cleanup service that clears safe app-managed temporary/cache directories only.

Use:

- `path_provider`
- `Directory` APIs

Safe cleanup targets:

- temporary directory
- cache directory if available through platform path APIs

Do not delete:

- Drift database
- app documents directory
- task history metadata

If a directory does not exist, treat it as zero cleaned bytes rather than an error.

### Legal/About Content

For MVP, render `关于 Mova` as an app-internal page backed by local copy.

Content sources:

- about page: local product copy derived from `docs/product/product-architecture.md`

For `隐私政策` / `用户协议` / `许可证`, use a temporary external placeholder URL:

- `https://www.baidu.com`

Behavior rules:

- all three entries may share the same placeholder URL for now
- the URL should be centralized in one constant/helper so it can be replaced later
- if the URL cannot be opened, show a user-friendly failure message

## Error Handling

Settings flows should fail softly:

- feedback launch failure: snackbar/dialog with a clear message
- app info load failure: fallback content with retry affordance or static safe values
- cache cleanup failure: show message and preserve current UI
- invalid locale persistence: fall back to Chinese or English deterministically

No settings action should crash the app or leave the user on a dead-end screen.

## Testing Strategy

This work should add tests before implementation for the main new behaviors:

- locale state changes and persistence behavior
- settings controller cache cleanup success/failure state
- app info formatting/presentation logic where practical
- route-level widget behavior for key settings pages

At minimum, tests should cover:

- selecting language updates provider state
- cache cleanup action reports cleaned result
- settings home renders interactive rows and can navigate to detail pages

## Implementation Notes

Follow the project’s existing lightweight architecture:

- widgets do not call plugins directly
- controller owns user actions
- services own side effects
- providers compose dependencies

Prefer adding only the abstractions needed for this feature:

- locale preference provider/service
- cache cleanup service
- runtime app info service
- mail feedback service

Avoid introducing a generic content CMS, a repository layer for static legal text, or a large settings domain model.

## Success Criteria

This work is complete when:

- every visible settings row is interactive
- language switching works and persists
- feedback flow launches a mail client or shows a clear failure
- privacy policy, user agreement, and license entries open the placeholder URL
- version and about pages are readable in-app
- cache cleanup completes without deleting task history/database
- the app passes analysis and relevant tests
