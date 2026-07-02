# Mova 技术栈文档

## 文档目的

本文档记录 Mova 当前已经确定的核心技术选型，以及后续需要继续确认的工程选型。它同时作为工程落地说明，目标是让程序员拿到本文档后，可以直接创建 Flutter 项目、配置依赖、搭建目录、定义核心模型，并开始实现 MVP 闭环。

随着项目从产品规划进入工程实现，本文档应持续补充具体依赖、版本约束、模块边界、接口约定、数据表、平台差异处理方案和实现检查清单。

## 应用标识

- 产品名称：Mova
- Android applicationId：`com.peter100u.mova`
- iOS Bundle Identifier：`com.peter100u.mova`
- Dart package name 建议：`mova`

Flutter 项目初始化、Android 包名、iOS bundle identifier、商店后台、隐私政策、用户协议、反馈邮件模板和许可证披露页面都应使用以上标识。后续如果调整包名，必须在工程配置、商店配置和文档中同步修改。

## 工程落地总览

Mova MVP 的第一阶段目标不是一次性实现所有工具，而是先搭出可运行、可扩展、可测试的本地处理骨架。

程序员拿到本文档后，建议按以下顺序开始：

1. 创建 Flutter 项目，包名使用 `com.peter100u.mova`。
2. 配置 Material 3、Riverpod、go_router、Drift、代码生成和 lint。
3. 建立本文档中的目录结构，不提前拆成严格 Clean Architecture 多层模板。
4. 先实现 App 壳：首页、任务页、设置页、工具详情页、结果页。
5. 建立工具注册表、任务模型、任务记录数据库表和任务状态流。
6. 先打通 1 个最小工具，例如视频转音频或图片格式转换。
7. 再把同一套任务流程扩展到视频压缩、视频格式转换、音频转换、图片压缩等工具。

MVP 核心闭环必须始终围绕这一条链路实现：

```text
选择工具
-> 选择文件
-> 自动预检
-> 使用推荐参数
-> 创建任务记录
-> 执行任务
-> 更新进度
-> 保存 App 内结果
-> 展示结果页
-> 打开 / 分享 / 重试 / 删除
```

系统实现上不要把预检、默认输出目标和任务记录创建暴露成额外用户步骤。它们是后台流程，不是用户每次必须确认的页面。

## 项目级开发 Skill

本项目内置 `flutter-development` skill：

```text
.codex/skills/flutter-development/
├── SKILL.md
├── references/
└── templates/
```

团队成员拉取仓库后，可以在支持项目级 `.codex/skills` 的 Codex 环境中直接使用该 skill。本文档已按该 skill 的 Flutter 实施建议做项目化约束：

- 使用 Flutter widget 组合构建页面。
- 使用 Material 3。
- 使用 go_router 管理路由。
- 使用显式状态管理。
- 页面必须覆盖 loading、empty、error、success 状态。
- 不在 `build()` 中执行文件选择、数据库写入、FFmpeg、网络或权限请求。
- 优先拆分可读 widget，不把完整复杂页面堆在一个 `build()` 方法里。
- 自定义 widget 必须有清晰命名和必要注释。

注意：该 skill 的示例使用 Provider。Mova 不采用 Provider，统一使用 Riverpod。遇到 skill 示例中的 `ChangeNotifier`、`Consumer<Provider>`、`Provider.of`，实现时应转换为 Riverpod 的 `Notifier/AsyncNotifier`、`ref.watch`、`ref.read`。

## 已确定技术栈

### 应用框架

Mova 使用 Flutter 构建。

Flutter 适合 Mova 的原因：

- 一套代码优先覆盖 iOS 和 Android。
- 后续可以扩展到 macOS、Windows 等桌面端。
- 适合构建移动端优先、交互清晰、视觉一致的工具型应用。
- 对本地文件处理、原生能力集成和跨平台 UI 有较成熟的生态支持。

### UI 体系

Mova 的 UI 采用 Flutter 内置的 Material 3。

Material 3 作为首选 UI 体系的原因：

- 与 Flutter 官方能力结合紧密，减少早期自定义设计系统成本。
- 组件覆盖完整，适合快速搭建首页、任务记录、设置页、表单、弹窗和结果页。
- 支持主题、颜色、圆角、排版和状态样式统一管理。
- 适合 Mova 需要的现代、干净、轻量工具感。

早期界面应优先使用 Material 3 原生组件，再在颜色、间距、图标、卡片层级和交互反馈上做产品化定制。

### 应用架构

Mova 采用 Flutter Feature-first Architecture with Riverpod。

这个方案吸收 Clean Architecture 的边界思想，但不采用严格的 Clean Architecture 模板。原因是 Mova 目前是一人开发项目，MVP 阶段最重要的是快速做出稳定的本地处理闭环。如果一开始强制每个功能都拆成 `presentation`、`application`、`domain`、`data` 四层，很容易产生大量模板文件，让开发被架构本身拖慢。

Mova 的架构目标不是“看起来足够标准”，而是“一个人也能长期维护”。

这个架构选择的核心目标是：

- 按功能组织代码，让视频、音频、图片、任务、设置等模块可以独立演进。
- 页面、状态、数据访问和平台能力各自有清晰边界。
- 任务记录、媒体处理、文件权限、数据库等复杂能力不会直接堆在 UI 页面里。
- 常见功能可以用少量文件完成，不被大量空接口、空 use case 和重复 mapper 拖慢。
- 当某个功能真的变复杂时，可以自然拆出 repository、model、mapper 或更细的子目录。

建议用一句话理解本项目架构：按功能组织目录，用 Riverpod 管理状态和依赖，用 repository 隔离数据访问，用 service 封装平台能力，必要时再增加抽象。

Mova 的轻量架构规则：

- 页面文件负责 UI 展示、布局和用户交互。
- `controller` 负责页面状态、用户动作和调用业务流程。
- `state` 负责表达页面状态，不把复杂 UI 状态散落在 Widget 中。
- `repository` 负责数据读写，例如 Drift、配置、历史记录和本地缓存。
- `service` 负责平台能力，例如媒体处理、文件系统、权限、相册、分享。
- Riverpod provider 负责创建、组合和暴露依赖，但不应该变成巨大的业务逻辑容器。
- Freezed、collection 等工具库用于减少手写样板和常见集合处理代码，不用于制造额外抽象层。
- 不默认编写 use case。
- 不默认编写 abstract repository interface。
- 不默认编写 DTO 和 mapper，除非 Drift 表结构、平台返回结构和业务模型确实需要分开。
- 一个功能少于 3 个页面、逻辑不复杂时，不强制拆成多层目录。
- 抽象只在它能减少复杂度、方便测试或隔离变化时才引入。

### 单向数据流

Mova 的状态管理必须强调单向数据流。架构可以轻量，但状态变化路径必须清晰，避免 UI、controller、repository 和 service 互相直接修改状态。

推荐数据流：

```text
User Action
-> Page / Widget
-> Controller / Notifier
-> Repository
-> Service / Database / Platform Plugin
-> Repository
-> Controller updates State
-> Page watches State and rebuilds
```

核心规则：

- UI 只读取 state，并把用户动作转发给 controller。
- UI 不直接调用 repository、service、Drift、FFmpeg 或平台插件。
- Controller 是页面状态变化的唯一入口，负责处理用户动作、调用 repository/service、更新 state。
- State 使用不可变对象表达，优先通过 Freezed 生成 `copyWith`、相等比较和联合状态。
- Repository 负责数据读写和数据转换，不持有页面状态。
- Service 负责平台能力和副作用，不直接更新 UI state。
- Provider 负责依赖声明、对象创建和状态暴露，不应该成为随处可写的全局变量。
- 数据库和平台插件返回的数据必须先进入 repository 或 controller，再转换成 UI 可展示的 state。
- 任务进度、错误、取消、重试等状态变化都应从 controller 汇总后统一更新，避免多个地方同时写任务状态。

简单页面可以只有 `page + controller + state`。复杂页面再按需补充 repository、model 或 mapper。判断标准不是文件数量，而是状态变化是否仍然能沿着单向路径被追踪。

### 代码注释规范

Mova 的代码实现需要在关键文件中明确注释核心功能、模块边界和关注点。项目是一人开发，但代码也要让未来的自己、协作者和 AI 助手能快速理解系统。

注释应该优先说明：

- 文件或类的核心职责：这个文件负责什么，不负责什么。
- 模块边界：页面、controller、repository、service、database 之间如何协作。
- 状态流向：状态从哪里来，由谁更新，UI 如何订阅。
- 副作用：文件读写、权限请求、FFmpeg 执行、数据库写入、分享、跳转系统设置等。
- 平台差异：iOS、Android 在权限、相册、文件路径、后台任务和分享上的差异。
- 关键业务约束：例如不上传用户文件、任务记录不是永久备份、失败任务要保留错误摘要。
- 容易误用的 API：例如某个 service 只能由 controller 调用，不能从 Widget 直接调用。

建议在每个核心文件顶部保留一段简短说明：

```dart
/// Handles task list state for the task page.
///
/// Boundary:
/// - UI calls this controller for user actions.
/// - This controller updates TaskState.
/// - Data reads/writes go through TaskRepository.
/// - It must not call platform plugins directly.
```

注释不应该做的事：

- 不逐行解释显而易见的代码。
- 不用注释重复函数名或变量名已经表达清楚的信息。
- 不把过期设计、临时想法或未验证假设长期留在代码中。
- 不用大段注释替代清晰的命名和简单的结构。

判断标准：注释应该帮助读者理解“为什么这样设计、边界在哪里、哪里有副作用”，而不是解释“这行代码做了什么”。

### 状态管理

Mova 使用 Riverpod 作为状态管理方案。

Riverpod 适合 Mova 的原因：

- 可以清晰表达工具配置、任务记录、任务进度和设置项等状态。
- 依赖关系显式，方便测试和拆分模块。
- 适合从 MVP 阶段逐步扩展到更复杂的多文件处理、后续商业化和平台能力。
- 与 Flutter 结合成熟，不强依赖 Widget 树上下文。

建议早期将状态划分为几类：

- 应用级状态：语言、权限状态、首次启动说明状态。主题模式后续再加入。
- 工具配置状态：当前选择的工具、输入文件、输出目标、参数预设。
- 任务状态：处理中、成功、失败、取消和重试。
- 持久化状态：任务记录、用户偏好。独立最近文件能力后续再加入。

Riverpod 使用规则：

- 页面通过 `ref.watch` 订阅 state，通过 `ref.read(controllerProvider.notifier)` 触发动作。
- 页面不要直接 `ref.read(repositoryProvider)` 后执行数据写入，除非是非常简单且无状态的只读查询。
- controller 暴露清晰的方法，例如 `selectInputFile()`、`startTask()`、`cancelTask()`、`retryTask()`。
- 跨页面共享状态要慎重，优先让任务记录、用户偏好等持久化数据成为共享来源，而不是创建过多全局可变状态。
- 异步状态要明确表达加载中、成功、失败和空状态，避免只用 nullable 字段隐式表达状态。

### 路由

Mova 使用 go_router 作为路由方案。

go_router 适合 Mova 的原因：

- 支持声明式路由，适合 Flutter 应用长期维护。
- 方便组织底部导航、分类页、工具详情页、任务详情页和设置页。
- 后续支持深链、分享进入、任务结果页跳转和平台路由扩展。
- 与 Flutter 官方生态结合较好，学习和维护成本较低。

早期路由结构可以围绕产品信息架构设计：

```text
/
├── home
│   ├── video
│   ├── audio
│   └── image
├── tasks
│   └── :taskId
├── settings
└── tools
    └── :toolId
```

### 本地数据库

Mova 使用 Drift 作为本地数据库方案。

Drift 适合 Mova 的原因：

- 基于 SQLite，适合本地任务记录、用户偏好和处理历史。独立最近文件列表后续再评估。
- 支持类型安全查询，能降低手写 SQL 的维护成本。
- 适合 Flutter 应用离线优先的数据存储需求。
- 方便后续做数据库迁移、任务筛选、失败重试和历史记录检索。

MVP 阶段数据库重点服务于任务记录和用户偏好，不应过早承担复杂业务逻辑。

### 媒体处理

Mova 使用 `ffmpeg_kit_extended_flutter` 作为本地媒体处理核心。

该依赖用于：

- 视频格式转换、压缩和视频转音频。
- 音频格式转换、压缩和视频转音频。
- 图片相关处理里需要 FFmpeg 能力的场景，例如部分封装或格式转换。
- 通过 FFprobe 读取文件预检信息，用于任务记录和错误诊断。
- 获取执行日志、统计信息、返回码和失败摘要，用于进度展示和用户可理解的错误提示。

媒体处理选型注意事项：

- 旧的 `ffmpeg_kit_flutter` 已不适合作为新项目首选。
- 当前产品规划以 `ffmpeg_kit_extended_flutter` 为基础，但上线前必须确认实际构建类型、GPL 状态、启用组件和许可证披露。
- 首版优先使用移动端稳定能力，不急着启用复杂硬件加速或自定义 FFmpeg 构建。
- 长任务要支持取消、失败记录、日志摘要和任务状态恢复。
- 视频转 GIF、视频转 Live Photo 和音频降噪不进入 MVP。相关 FFmpeg 命令、平台保存能力和质量参数后续再单独验证。

### 任务系统和工具注册表

Mova 的所有处理工具都应共用一套任务模型和任务执行流程。不要让每个工具页面各自拼接 FFmpeg 命令、保存任务记录或解析进度。

建议抽象：

- `ToolDefinition`：描述工具 ID、名称、分类、支持输入类型、输出格式和参数配置。
- `ToolRegistry`：集中注册视频、音频、图片工具，首页工具列表和路由从注册表读取。
- `TaskRequest`：一次处理请求，包含工具 ID、输入文件、输出目标、参数和创建时间。
- `TaskRecord`：持久化任务记录，包含状态、进度、输入摘要、输出摘要、错误分类和快捷操作信息。
- `CommandBuilder`：把结构化工具参数转换成 FFmpeg 命令，避免命令字符串散落在 UI 中。
- `TaskRunner`：执行任务、解析进度、处理取消、写入日志摘要，并把结果回传给 controller。

多文件输入规则：

- 用户选择 1 个文件时，生成 1 条 `TaskRequest` 和 1 条任务记录。
- 用户选择多个文件时，每个输入文件生成独立任务记录。
- 多个任务共用同一套工具参数和输出目标。
- 单个文件失败不影响其他文件继续处理。
- MVP 不单独设计“批量任务”入口，多文件输入就是自然的多任务。

任务系统仍然遵守单向数据流：页面触发动作，controller 创建任务，repository 写入任务记录，runner 执行任务，controller 汇总进度并更新 state。

### 文件、权限和分享

Mova MVP 需要完整支持输入源、基础输出目标、权限恢复和结果分享，因此需要明确平台能力依赖。

首批依赖：

- `file_picker`：系统文件选择器，用于从文件 App 或系统存储选择单个或多个输入文件。系统保存/另存为流程后续再验证。
- `photo_manager`：相册资产读取、相册权限状态和部分 Live Photo 资源能力。MVP 先用于相册读取；相册保存和 Live Photo 作为后续验证方向。
- `permission_handler`：统一检查和请求相册、通知、存储等权限，并支持跳转系统设置。
- `share_plus`：分享处理后的文件到其他 App，支撑结果页和任务记录快捷操作。
- `open_filex`：调用系统能力打开处理后的文件，支撑结果页和任务记录的「打开」操作。
- `path`：统一处理文件名、扩展名、输出文件路径和 App 内结果目录拼接，避免手写字符串路径。
- `mime`：根据文件扩展名和文件头辅助识别 MIME type，用于输入文件预检、工具兼容性判断和分享参数。
- `uuid`：生成任务 ID、输出文件关联 ID 和日志关联 ID，让任务记录、执行日志和结果文件可以稳定关联。
- `url_launcher`：打开隐私政策、用户协议、许可证源码链接、反馈邮件或外部网页。

这些能力必须通过 `services/` 层封装，页面不能直接依赖插件 API。权限被拒绝时，service 应返回能被 UI 翻译成人话的状态，而不是把平台错误直接抛到页面。

其他 App 分享进入暂不进入 MVP。后续如果加入，需要先验证 Android `SEND`/`SEND_MULTIPLE` intent filter、iOS Share Extension、App Group、文件访问权限和多文件输入规则。

### 图片展示与预览

Mova 使用 `extended_image` 处理图片展示、预览和基础查看体验。

该依赖用于：

- 图片工具详情页中的输入图片预览。
- HEIC 转换、图片压缩、格式转换后的结果查看。
- 任务记录中的图片缩略图或结果预览。
- 加载中、加载失败和重新加载状态。
- 大图缩放、平移和基础 Photo View 体验。
- 本地图片和后续可能出现的网络图片缓存展示。

使用边界：

- MVP 只使用展示、加载状态、缩放和平移能力。
- 不把裁剪、旋转、涂鸦、图片编辑器等能力提前做进 MVP。
- 图片编辑相关能力等进入“调整尺寸、裁剪、移除元数据”等后续功能时再单独评估。
- 页面仍然只负责展示，图片文件读取、权限和路径处理应由 `file_service`、`photo_service` 或任务系统提供。

实现方式：

- 不在业务页面里直接散落使用 `ExtendedImage`。
- 在 `shared/widgets/` 下封装项目级图片组件，例如 `MovaImagePreview`、`MovaImageThumbnail`、`MovaZoomableImage`。
- 业务页面只使用 Mova 自己的图片组件，由组件内部决定是否使用 `extended_image`。
- 组件统一处理加载中、加载失败、空文件、缩放、平移、圆角、背景色和占位样式。
- 后续如果替换图片库，只需要修改封装组件，不需要改每个业务页面。

建议组件职责：

```text
MovaImagePreview
- 用于工具详情页和结果页的大图预览
- 支持本地文件、相册文件和后续可能的网络图片
- 支持加载状态、失败状态、缩放和平移

MovaImageThumbnail
- 用于任务记录和工具列表中的小图，后续也可用于最近文件
- 固定尺寸和裁剪方式
- 失败时展示统一占位

MovaZoomableImage
- 用于独立图片查看页或结果查看弹层
- 专注缩放、平移和双击查看
```

### 国际化与本地偏好

Mova MVP 设置页包含多语言和首次启动说明，后续还可能加入主题模式、默认输出位置等偏好，因此需要区分轻量偏好和结构化数据。

- `flutter_localizations`：使用 Flutter SDK 自带本地化支持。
- `intl`：用于日期、数字、文件大小、任务时间和多语言文案格式化。
- `shared_preferences`：用于语言、首次启动说明是否展示等轻量偏好。主题模式、默认质量预设和默认输出位置后续再加入。

Drift 负责任务记录等结构化数据；`shared_preferences` 只负责少量 key-value 设置。不要把任务记录放进 `shared_preferences`，也不要为了一个布尔设置去建 Drift 表。独立最近文件列表、用户自定义工具预设后续再评估。

### 反馈、支持和应用信息

产品文档要求设置页反馈入口、失败任务反馈入口、App 版本、设备型号和系统版本，因此需要补充以下依赖：

- `package_info_plus`：读取 App 版本、构建号、包名和安装来源。
- `device_info_plus`：读取设备型号和系统版本，用于失败任务反馈摘要。

反馈默认只附带 App 版本、设备信息、工具类型、错误分类和 FFmpeg 错误摘要。除非用户明确选择，不上传输入文件或输出文件。

### 代码生成与工具库

Mova 使用 Freezed 和 collection 减少模板代码和冗余集合处理逻辑。

Freezed 主要用于：

- 页面状态对象，例如加载中、处理中、成功、失败等状态。
- 不可变数据模型，例如任务配置、媒体文件信息、工具参数。
- `copyWith`、`==`、`hashCode` 等重复代码。
- 简单的联合类型，表达任务状态、处理结果和错误状态。

Freezed 的使用原则：

- 优先用于状态和模型，不为了每个小对象都引入代码生成。
- 不为了配合 Freezed 额外制造复杂分层。
- 不把简单枚举、简单常量或只有一两个字段的临时对象过度 Freezed 化。
- 当 Drift 生成的数据类已经足够表达数据库结果时，不重复创建一套几乎相同的 Freezed 模型。
- 只有当 UI 状态、业务模型或平台返回数据需要明确隔离时，再增加 mapper。

collection 主要用于：

- `firstWhereOrNull`、`singleWhereOrNull` 等安全查找。
- `groupBy`、`mapIndexed` 等常见集合转换。
- 列表比较、去重、排序和分组等任务处理场景。
- 让任务记录、工具列表、预设列表等逻辑更短、更可读。

collection 的使用原则：

- 优先替代容易出错的手写循环和空值判断。
- 不为了使用函数式写法而牺牲可读性。
- 简单循环更直观时，可以继续使用普通 `for`。

### 开发效率依赖

Mova 可以适度增加成熟依赖来提高开发效率。这里的原则是：可以为了减少重复劳动而堆库，但不要为了堆库而扩大架构复杂度。

以下依赖是候选依赖清单，具体版本需要在 Flutter 工程 spike 后锁定。版本锁定前应确认 Flutter/Dart SDK 兼容性、iOS/Android 构建通过、关键平台能力可用、许可证可接受，并通过 `flutter pub outdated` 检查是否存在明显过期或冲突。

候选依赖清单：

```yaml
dependencies:
  flutter_riverpod: ^3.3.2
  riverpod_annotation: ^4.0.3
  go_router: ^17.3.0
  drift: ^2.34.0
  drift_flutter: ^0.2.8
  path_provider: ^2.1.6
  ffmpeg_kit_extended_flutter: ^0.5.10
  file_picker: ^11.0.2
  photo_manager: ^3.8.3
  permission_handler: ^12.0.3
  share_plus: ^13.2.0
  open_filex: ^4.7.0
  extended_image: ^10.0.1
  path: ^1.9.1
  mime: ^2.0.0
  uuid: ^4.5.3
  url_launcher: ^6.3.2
  shared_preferences: ^2.5.5
  intl: ^0.20.3
  package_info_plus: ^10.2.0
  device_info_plus: ^13.2.0
  freezed_annotation: ^3.1.0
  collection: ^1.19.1
  logger: ^2.7.0

dev_dependencies:
  build_runner: ^2.15.0
  riverpod_generator: ^4.0.4
  riverpod_lint: ^3.1.4
  custom_lint: ^0.8.1
  drift_dev: ^2.34.1+1
  freezed: ^3.2.5
  flutter_lints: ^6.0.0
```

这些依赖的定位：

- `riverpod_annotation` 和 `riverpod_generator`：减少手写 provider 的样板代码，让状态和依赖声明更直接。
- `riverpod_lint` 和 `custom_lint`：提前发现 Riverpod 常见使用问题，减少一人开发时的低级错误。
- `go_router`：提供声明式路由、底部导航 Shell、深链和结果页跳转能力。
- `drift`、`drift_flutter`、`path_provider` 和 `drift_dev`：按 Drift 官方 setup 页的 Flutter sqlite3 方案配置，提供类型安全的本地数据库访问、Flutter 平台数据库打开能力、数据库文件目录获取和代码生成。
- `drift_flutter`：用于 Flutter 场景下简化 SQLite 打开方式和平台配置。
- `path_provider`：配合 Drift 官方示例获取数据库文件目录，例如 App 文档目录或支持目录。
- `ffmpeg_kit_extended_flutter`：提供 FFmpeg、FFprobe 和 FFplay 能力，支撑本地媒体转换、压缩、预检读取、日志和进度统计。
- `file_picker`：提供系统文件选择能力；系统保存能力后续小样验证。
- `photo_manager`：提供相册读取和相册权限相关能力；相册保存能力后续小样验证。
- `permission_handler`：处理权限检查、权限请求和跳转系统设置。
- `share_plus`：提供结果文件分享能力。
- `open_filex`：调用系统能力打开处理结果文件。
- `extended_image`：提供图片加载状态、失败状态、缩放、平移、预览和缓存展示能力。
- `path`：处理跨平台路径拼接、文件名、扩展名和输出文件命名。
- `mime`：辅助输入文件预检、媒体类型识别和分享 MIME type 传递。
- `uuid`：生成任务、日志和结果文件关联 ID，避免依赖文件名或时间戳做唯一标识。
- `url_launcher`：打开外部链接、反馈邮件、许可证源码链接和商店页面。
- `shared_preferences`：保存轻量本地偏好。
- `intl`：处理本地化文案、日期、数字和文件大小格式化。
- `package_info_plus`：读取 App 版本和构建信息。
- `device_info_plus`：读取设备型号和系统版本，用于反馈摘要。
- `flutter_lints`：采用 Flutter 官方基础 lint 规则，不一开始引入过重规则集。
- `logger`：记录媒体处理命令、任务状态、失败原因和调试信息，方便定位本地处理问题。
- `build_runner`：统一承载 Riverpod、Freezed、Drift 等代码生成流程。

暂不加入的依赖：

- `gap`：虽然可以减少 `SizedBox` 写法，但维护活跃度不足。UI 间距先使用 Flutter 原生 `SizedBox`。
- `json_serializable`：等出现导入/导出预设、配置备份、远程接口或商业化校验返回数据时再加入。
- `flutter_gen_runner`：等项目出现较多图片、字体、图标等资源文件时再加入。
- `sqlite3`：当前不直接加入。Drift 的 Flutter sqlite3 方案优先通过 `drift_flutter` 处理底层 SQLite 能力；只有后续需要更底层的自定义打开策略或非标准平台配置时，再评估是否直接引入。
- `flutter_local_notifications`：等确定需要长任务通知或后台进度提示时再加入。
- `receive_sharing_intent`：等确定要支持其他 App 分享进入后再加入。
- `in_app_review`：设置页评价 App 属于后续能力，有一定用户量和商店信息确定后再加入。
- `in_app_purchase`：MVP 不做付费页、恢复购买或权益管理，后续商业化阶段再加入。
- 崩溃上报或分析 SDK：MVP 优先保持本地处理和隐私信任，后续需要线上质量监控时再评估。

进入对应范围前需要继续调研确认的能力：

- MVP 前：可用存储空间检测。
- MVP 前：图片处理能力，尤其是图片格式转换、压缩、HEIC 处理是使用 FFmpeg、平台能力还是专门图片库。
- 后续输出目标前：保存到系统文件时，不同 Android/iOS 版本的目录选择、文件覆盖和权限表现。
- 后续输出目标前：保存到相册时，不同 Android/iOS 版本的媒体库权限、相册写入和商店审核表现。

这些能力平台差异较大，不应只因为包名看起来合适就直接定库。优先做小样验证，确认权限、文件路径、相册保存和商店审核风险后再写入正式依赖。

UI 间距优先使用原生写法：

```dart
const SizedBox(height: 12)
const SizedBox(width: 12)
```

如果后续间距常量开始重复，可以在项目内维护一个很薄的 spacing 定义：

```dart
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
}
```

这比为了少写几个 `SizedBox` 引入不活跃依赖更稳。

## Flutter 项目创建和基础配置

创建项目时使用以下命令：

```bash
flutter create --org com.peter100u --project-name mova --platforms ios,android mova
```

创建后必须确认：

- Android `applicationId`：`com.peter100u.mova`
- iOS `PRODUCT_BUNDLE_IDENTIFIER`：`com.peter100u.mova`
- Dart package：`mova`
- App 显示名：`Mova`
- `useMaterial3: true`

`pubspec.yaml` 第一版按候选依赖清单填写。完成依赖配置后执行：

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```

首版 `pubspec.yaml` 结构：

```yaml
name: mova
description: Mova mobile media converter.
publish_to: "none"

environment:
  sdk: ">=3.4.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  flutter_riverpod: ^3.3.2
  riverpod_annotation: ^4.0.3
  go_router: ^17.3.0
  drift: ^2.34.0
  drift_flutter: ^0.2.8
  path_provider: ^2.1.6
  ffmpeg_kit_extended_flutter: ^0.5.10
  file_picker: ^11.0.2
  photo_manager: ^3.8.3
  permission_handler: ^12.0.3
  share_plus: ^13.2.0
  open_filex: ^4.7.0
  extended_image: ^10.0.1
  path: ^1.9.1
  mime: ^2.0.0
  uuid: ^4.5.3
  url_launcher: ^6.3.2
  shared_preferences: ^2.5.5
  intl: ^0.20.3
  package_info_plus: ^10.2.0
  device_info_plus: ^13.2.0
  freezed_annotation: ^3.1.0
  collection: ^1.19.1
  logger: ^2.7.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.15.0
  riverpod_generator: ^4.0.4
  riverpod_lint: ^3.1.4
  custom_lint: ^0.8.1
  drift_dev: ^2.34.1+1
  freezed: ^3.2.5
  flutter_lints: ^6.0.0

flutter:
  uses-material-design: true
  generate: true
  assets:
    - assets/images/
```

`l10n.yaml` 首版可以先创建，避免后续迁移：

```yaml
arb-dir: lib/l10n
template-arb-file: app_zh.arb
output-localization-file: app_localizations.dart
```

`analysis_options.yaml` 使用 Flutter 官方 lint，并接入 Riverpod lint：

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  plugins:
    - custom_lint

linter:
  rules:
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
```

代码生成统一使用：

```bash
dart run build_runner watch --delete-conflicting-outputs
```

不要手动修改 `.g.dart`、`.freezed.dart`、Drift 生成文件。

## 应用入口实施

`lib/main.dart`：

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MovaApp()));
}
```

`lib/app/app.dart`：

```dart
class MovaApp extends ConsumerWidget {
  const MovaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Mova',
      theme: buildLightTheme(),
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh'),
        Locale('en'),
      ],
    );
  }
}
```

`lib/app/theme.dart`：

```dart
ThemeData buildLightTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
  );
}
```

MVP 不实现主题切换。`buildDarkTheme()` 后续再加。

入口验收：

- `ProviderScope` 包裹全应用。
- App 启动进入首页。
- Material 3 生效。
- 路由、数据库、service 不在 Widget build 中重复创建。

## Flutter 页面实施规范

页面默认使用 `ConsumerWidget` 或 `ConsumerStatefulWidget`。

使用 `ConsumerWidget`：

- 页面只依赖 provider state。
- 无本地动画控制器。
- 无 `TextEditingController`、`ScrollController` 等生命周期对象。

使用 `ConsumerStatefulWidget`：

- 页面需要 `AnimationController`。
- 页面需要 `TextEditingController`、`ScrollController`、`FocusNode`。
- 页面需要 `initState` 触发一次性 UI 初始化。

页面模板：

```dart
class ToolDetailPage extends ConsumerWidget {
  const ToolDetailPage({required this.toolId, super.key});

  final String toolId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(toolFlowControllerProvider(toolId));
    final controller = ref.read(toolFlowControllerProvider(toolId).notifier);

    ref.listen(toolFlowControllerProvider(toolId), (previous, next) {
      // Only UI side effects: snack bar, dialog, navigation.
    });

    return Scaffold(
      appBar: AppBar(title: Text(state.tool.title)),
      body: ToolDetailContent(
        state: state,
        onSelectFiles: controller.selectFiles,
        onStart: controller.startTasks,
      ),
    );
  }
}
```

页面拆分规则：

- `build()` 超过 120 行时，拆出私有 widget 或 `widgets/` 文件。
- 同一 UI 片段被复用 2 次以上时，拆成 widget。
- 列表 item 必须拆成独立 widget。
- 表单参数项必须拆成独立 widget。
- `ref.listen` 只处理 SnackBar、Dialog、Navigation，不写业务逻辑。

状态展示规则：

```text
initial/loading -> loading indicator 或 skeleton
empty -> 空状态说明和主操作
error -> 用户可理解错误 + 恢复操作
success -> 内容
running -> 进度 + 取消入口
```

性能规则：

- 能 `const` 的 widget 必须 `const`。
- 长列表使用 `ListView.builder`。
- 图片缩略图固定尺寸，避免列表跳动。
- 不在 `build()` 中创建数据库、controller、service、Future。
- 不在 `build()` 中调用文件选择、权限请求、FFmpeg 或分享。
- 大对象和 service 通过 provider 创建。

响应式规则：

- 页面内容使用 `SafeArea`。
- 主内容横向最大宽度建议 640。
- 工具列表在宽屏可切换为 2 列，手机默认 1 列。
- 按钮文字必须在小屏不溢出。
- 任务列表 item 高度保持稳定。

## 工程目录和文件职责

首版目录必须按下面结构创建。没有业务逻辑的空目录可以暂缓，但核心边界要保持一致。

```text
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme.dart
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── supported_formats.dart
│   ├── errors/
│   │   ├── app_error.dart
│   │   └── task_error.dart
│   └── utils/
│       ├── file_name_utils.dart
│       └── file_size_formatter.dart
├── data/
│   ├── database/
│   │   ├── app_database.dart
│   │   ├── tables.dart
│   │   └── daos/
│   │       └── task_dao.dart
│   └── repositories/
│       └── task_repository.dart
├── services/
│   ├── command_builder.dart
│   ├── media_service.dart
│   ├── task_runner.dart
│   ├── file_service.dart
│   ├── photo_service.dart
│   ├── permission_service.dart
│   ├── share_service.dart
│   ├── open_file_service.dart
│   ├── app_info_service.dart
│   └── feedback_service.dart
├── features/
│   ├── home/
│   │   ├── home_page.dart
│   │   └── widgets/
│   ├── tools/
│   │   ├── tool_detail_page.dart
│   │   ├── tool_controller.dart
│   │   ├── tool_state.dart
│   │   └── widgets/
│   ├── tasks/
│   │   ├── tasks_page.dart
│   │   ├── task_detail_page.dart
│   │   ├── task_controller.dart
│   │   ├── task_state.dart
│   │   └── widgets/
│   ├── result/
│   │   ├── task_result_page.dart
│   │   └── widgets/
│   └── settings/
│       ├── settings_page.dart
│       └── widgets/
└── shared/
    ├── models/
    │   ├── media_file.dart
    │   ├── task_models.dart
    │   └── tool_models.dart
    ├── providers/
    │   ├── database_providers.dart
    │   ├── repository_providers.dart
    │   └── service_providers.dart
    ├── tool_registry/
    │   ├── tool_registry.dart
    │   └── mvp_tools.dart
    └── widgets/
        ├── mova_image_preview.dart
        ├── mova_image_thumbnail.dart
        └── mova_zoomable_image.dart
```

文件职责硬规则：

- `features/**/page.dart`：只写 UI、布局、用户动作转发，不写数据库、FFmpeg、权限和文件路径逻辑。
- `features/**/controller.dart`：处理用户动作、调用 repository/service、更新 state。
- `features/**/state.dart`：只表达 UI 状态，优先 Freezed。
- `data/database/*`：只定义 Drift 表、DAO、迁移。
- `data/repositories/*`：组合数据库和轻量数据转换，不执行平台插件。
- `services/*`：封装平台插件、副作用和 FFmpeg。
- `shared/tool_registry/*`：静态注册工具，不保存运行时状态。
- `shared/widgets/*`：跨功能 UI 组件，不直接创建任务。

## 核心模型定义

首版必须先定义这些模型，再写页面。模型字段可以增加，但不要删掉核心字段。

```dart
enum MediaKind { video, audio, image }
enum InputSource { photoLibrary, filePicker }
enum OutputTarget { appResult }
enum TaskStatus { queued, running, succeeded, failed, cancelled }
enum TaskErrorCode {
  permissionDenied,
  inputNotFound,
  unsupportedFormat,
  insufficientStorage,
  ffmpegFailed,
  cancelled,
  openFailed,
  shareFailed,
  unknown,
}

class MediaFile {
  final String id;
  final String displayName;
  final String? path;
  final String? mimeType;
  final MediaKind kind;
  final InputSource source;
  final int? sizeBytes;
  final Duration? duration;
  final int? width;
  final int? height;
}
```

```dart
class ToolDefinition {
  final String id;
  final String title;
  final String description;
  final MediaKind category;
  final List<MediaKind> acceptedInputs;
  final List<String> supportedInputExtensions;
  final List<String> supportedInputMimeTypes;
  final List<String> outputFormats;
  final String defaultOutputFormat;
  final String defaultPresetId;
  final List<ToolPreset> presets;
  final ToolParameterSchema parameterSchema;
  final bool allowMultipleInputs;
  final bool isMvp;
}
```

```dart
class ToolPreset {
  final String id;
  final String title;
  final String outputExtension;
  final Map<String, Object?> parameters;
}
```

```dart
class TaskRequest {
  final String id;
  final String toolId;
  final MediaFile input;
  final String presetId;
  final OutputTarget outputTarget;
  final String outputPath;
  final Map<String, Object?> parameters;
  final DateTime createdAt;
}
```

```dart
class TaskRecord {
  final String id;
  final String toolId;
  final TaskStatus status;
  final int progress; // 0 - 100
  final String inputName;
  final String? inputPath;
  final String? outputPath;
  final String? outputMimeType;
  final int? outputSizeBytes;
  final String? errorCode;
  final String? errorMessage;
  final int? ffmpegReturnCode;
  final String? logSummary;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
}
```

```dart
class MediaProbeInfo {
  final Duration? duration;
  final int? width;
  final int? height;
  final int? bitrate;
  final String? videoCodec;
  final String? audioCodec;
  final bool hasVideo;
  final bool hasAudio;
  final int? rotation;
}
```

```dart
class TaskProgress {
  final String taskId;
  final TaskStatus status;
  final double progress; // 0.0 - 1.0
  final Duration? elapsed;
  final String? message;
}
```

Freezed 使用要求：

- UI state、TaskRecord、TaskRequest、MediaFile、ToolDefinition 可以使用 Freezed。
- Drift table 生成的数据类不强制再包一层 Freezed。
- 如果 Drift 字段和 UI 字段差异明显，再写 mapper。

## Drift 数据库实施

数据库文件：

- `data/database/app_database.dart`
- `data/database/tables.dart`
- `data/database/daos/task_dao.dart`
- 用户轻量偏好首版使用 `shared_preferences`，不建 Drift 偏好表。

`app_database.dart` 使用 `drift_flutter` 打开数据库：

```dart
@DriftDatabase(tables: [TaskRecords], daos: [TaskDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'mova.sqlite');
}
```

首批表：

```dart
class TaskRecords extends Table {
  TextColumn get id => text()();
  TextColumn get toolId => text()();
  TextColumn get status => text()();
  IntColumn get progress => integer().withDefault(const Constant(0))();
  TextColumn get inputName => text()();
  TextColumn get inputPath => text().nullable()();
  TextColumn get inputMimeType => text().nullable()();
  IntColumn get inputSizeBytes => integer().nullable()();
  TextColumn get outputPath => text().nullable()();
  TextColumn get outputMimeType => text().nullable()();
  IntColumn get outputSizeBytes => integer().nullable()();
  TextColumn get parametersJson => text()();
  TextColumn get errorCode => text().nullable()();
  TextColumn get errorMessage => text().nullable()();
  IntColumn get ffmpegReturnCode => integer().nullable()();
  TextColumn get logSummary => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

`TaskDao` 必须提供：

```dart
Future<void> insertTask(TaskRecordsCompanion task);
Stream<List<TaskRecordRow>> watchRecentTasks();
Stream<TaskRecordRow?> watchTaskById(String taskId);
Future<void> updateTaskProgress(String taskId, int progress);
Future<void> markTaskRunning(String taskId);
Future<void> markTaskSucceeded(String taskId, String outputPath, String? outputMimeType, int? outputSizeBytes);
Future<void> markTaskFailed(String taskId, String errorCode, String errorMessage, int? ffmpegReturnCode, String? logSummary);
Future<void> markTaskCancelled(String taskId);
Future<void> deleteTask(String taskId);
```

数据库约束：

- 任务记录只保存路径、摘要、状态、参数，不保存媒体文件二进制。
- `parametersJson` 首版可以用 `dart:convert` 手写 JSON。
- 不引入 `json_serializable`，除非后续参数结构明显复杂。
- 数据库迁移从 `schemaVersion = 2` 开始必须写 migration，不允许清库升级。

## Riverpod 实施规范

Provider 文件放在 `shared/providers/`，业务 controller provider 放在对应 feature 内。

基础 provider：

```dart
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

@riverpod
ToolRegistry toolRegistry(Ref ref) {
  return ToolRegistry(mvpTools);
}

@riverpod
TaskRepository taskRepository(Ref ref) {
  return TaskRepository(ref.watch(appDatabaseProvider).taskDao);
}

@riverpod
FileService fileService(Ref ref) => FilePickerService();

@riverpod
PhotoService photoService(Ref ref) => PhotoManagerService();

@riverpod
PermissionService permissionService(Ref ref) => PermissionHandlerService();

@riverpod
MediaService mediaService(Ref ref) => FfmpegMediaService();

@riverpod
TaskRunner taskRunner(Ref ref) {
  return TaskRunner(
    mediaService: ref.watch(mediaServiceProvider),
    taskRepository: ref.watch(taskRepositoryProvider),
  );
}
```

Controller 写法：

```dart
@riverpod
class ToolFlowController extends _$ToolFlowController {
  @override
  ToolState build(String toolId) {
    final tool = ref.watch(toolRegistryProvider).requireById(toolId);
    return ToolState.initial(tool: tool);
  }

  Future<void> selectFiles() async {}
  void updatePreset(String presetId) {}
  void updateParameter(String key, Object? value) {}
  Future<void> startTasks() async {}
}

@riverpod
class TaskListController extends _$TaskListController {
  @override
  Stream<List<TaskRecord>> build() {
    return ref.watch(taskRepositoryProvider).watchRecentTasks();
  }

  Future<void> cancelTask(String taskId) async {}
  Future<void> retryTask(String taskId) async {}
  Future<void> deleteTask(String taskId) async {}
}
```

页面调用规则：

```dart
final state = ref.watch(toolFlowControllerProvider(toolId));
final controller = ref.read(toolFlowControllerProvider(toolId).notifier);
```

禁止：

- Widget 直接调用 `TaskDao`。
- Widget 直接调用 FFmpeg、file picker、photo manager、permission handler。
- Service 直接修改 UI state。
- Provider 里堆业务流程。

## go_router 路由实施

首版路由表：

```text
/home
/home/video
/home/audio
/home/image
/tasks
/tasks/:taskId
/settings
/tools/:toolId
/tasks/:taskId/result
```

`router.dart` 要求：

- 使用 `ShellRoute` 或 `StatefulShellRoute` 承载底部导航。
- 首页、任务、设置是底部导航一级页面。
- 工具详情、任务详情、结果页是子页面。
- 路由参数只传 `toolId`、`taskId`，不要把完整对象塞进路由。
- 页面需要对象时通过 registry、repository 或 controller 读取。

路由 provider：

```dart
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppPaths.home,
    routes: [
      // ShellRoute for Home / Tasks / Settings.
    ],
    errorBuilder: (context, state) => RouteErrorPage(error: state.error),
  );
}
```

首版路由命名：

```dart
class AppRoutes {
  static const home = 'home';
  static const tasks = 'tasks';
  static const taskDetail = 'taskDetail';
  static const settings = 'settings';
  static const toolDetail = 'toolDetail';
  static const taskResult = 'taskResult';
}
```

路由常量：

```dart
class AppPaths {
  static const home = '/home';
  static const homeVideo = '/home/video';
  static const homeAudio = '/home/audio';
  static const homeImage = '/home/image';
  static const tasks = '/tasks';
  static const taskDetail = '/tasks/:taskId';
  static const settings = '/settings';
  static const toolDetail = '/tools/:toolId';
  static const taskResult = '/tasks/:taskId/result';
}
```

跳转约定：

```dart
context.goNamed(AppRoutes.toolDetail, pathParameters: {'toolId': toolId});
context.goNamed(AppRoutes.taskDetail, pathParameters: {'taskId': taskId});
context.goNamed(AppRoutes.taskResult, pathParameters: {'taskId': taskId});
```

无效参数处理：

- unknown `toolId`：展示工具不存在页，提供返回首页。
- missing `taskId`：返回任务页。
- task not found：展示记录不存在，提供返回任务页。

路由验收：

- 底部导航切换后保留当前 tab 状态。
- 工具详情刷新后能通过 `toolId` 恢复。
- 任务详情重进 App 后从 Drift 加载。
- 无效路由进入错误页，不崩溃。
- 结果页只依赖 `taskId`，不依赖内存对象。

## 工具注册表实施

MVP 工具必须集中注册，页面不能自己硬编码工具列表。

`mvp_tools.dart` 首批工具 ID：

```text
video.convert
video.compress
video.extractAudio
audio.convert
audio.compress
image.convert
image.compress
image.heicToJpg
```

每个工具必须声明：

- `id`
- `title`
- `category`
- `acceptedInputs`
- `outputFormats`
- `defaultOutputFormat`
- `defaultParameters`
- `parameterSchema`
- `isMvp`

工具详情页从 `ToolRegistry` 读取配置：

```dart
final tool = ref.watch(toolRegistryProvider).requireById(toolId);
```

不允许：

- 在首页复制一份工具列表。
- 在工具详情页硬编码输出格式。
- 在 `CommandBuilder` 里用页面文案判断工具类型。

## 任务执行实施

任务执行只允许走这一条流程：

```text
ToolPage
-> ToolFlowController.startTasks()
-> TaskRepository.insertTask()
-> TaskRunner.run(request)
-> CommandBuilder.build(request)
-> MediaService.execute(command)
-> TaskRepository.updateProgress()
-> TaskRepository.markSucceeded() / markFailed()
-> ToolFlowController / TaskListController 更新 state
```

`CommandBuilder` 接口：

```dart
class CommandBuilder {
  FfmpegCommand build(TaskRequest request);
}

class FfmpegCommand {
  final List<String> arguments;
  final String outputPath;
  final String? expectedMimeType;
}
```

`MediaService` 接口：

```dart
abstract class MediaService {
  Future<MediaProbeInfo> probe(MediaFile file);
  Stream<TaskProgress> execute(FfmpegCommand command);
  Future<void> cancel(String taskId);
}
```

`TaskRunner` 负责：

- 将 task 标记为 `running`。
- 调用 `CommandBuilder` 生成命令。
- 调用 `MediaService.execute()`。
- 解析进度事件并写入 Drift。
- 成功后写入 outputPath、outputMimeType、completedAt。
- 失败后写入 errorCode、errorMessage、completedAt。
- 取消后写入 `cancelled`。

FFmpeg 命令要求：

- 命令参数用 `List<String>` 保存，不在 UI 拼字符串。
- 输出路径由 `FileService` 生成。
- 日志只保存摘要，不保存完整超长日志。
- 错误必须转换为用户可理解错误分类。

首批错误分类：

```text
permissionDenied
inputNotFound
unsupportedFormat
insufficientStorage
ffmpegFailed
cancelled
openFailed
shareFailed
unknown
```

任务状态机：

```text
queued -> running
running -> succeeded
running -> failed
running -> cancelled
failed -> queued      # retry
cancelled -> queued   # retry
succeeded -> deleted
failed -> deleted
cancelled -> deleted
```

MVP 并发策略：

- 默认串行执行任务。
- 多文件选择时按选择顺序入队。
- 单个任务失败不影响队列中的后续任务。
- App 切到后台时不承诺继续长时间执行；首版只保证回到前台后任务记录状态可见。
- 后台通知和长期后台任务后续再做。

FFmpeg 命令模板由 `CommandBuilder` 生成。以下是首版模板，不允许在 UI 页面拼命令。

视频转音频：

```text
-y -i {inputPath} -vn -c:a aac -b:a {bitrateKbps}k {outputPath}
```

视频压缩：

```text
-y -i {inputPath} -c:v libx264 -crf {crf} -preset medium -c:a aac -b:a 128k {outputPath}
```

视频格式转换：

```text
-y -i {inputPath} -c:v libx264 -c:a aac {outputPath}
```

音频格式转换：

```text
-y -i {inputPath} -c:a {audioCodec} -b:a {bitrateKbps}k {outputPath}
```

音频压缩：

```text
-y -i {inputPath} -c:a aac -b:a {bitrateKbps}k {outputPath}
```

图片格式转换：

```text
-y -i {inputPath} {outputPath}
```

图片压缩：

```text
-y -i {inputPath} -q:v {quality} {outputPath}
```

HEIC 转 JPG/PNG：

```text
-y -i {inputPath} {outputPath}
```

进度解析规则：

- 先用 FFprobe 获取 `duration`。
- 有 `duration` 时，用 FFmpeg statistics 的当前 time 计算 `0.0 - 1.0`。
- 无 `duration` 时，UI 展示不确定进度。
- 任务成功必须同时满足 return code success、输出文件存在、输出文件大小大于 0。
- 日志摘要最多保存最后 80 行或 8KB。
- 取消任务不写成失败。

## 文件、相册、权限、分享实施

`FileService` 必须提供：

```dart
Future<List<MediaFile>> pickFiles({required List<MediaKind> acceptedKinds, required bool allowMultiple});
Future<String> createOutputPath({required String taskId, required String originalName, required String extension});
Future<bool> exists(String path);
Future<void> deleteFile(String path);
```

`PhotoService` 必须提供：

```dart
Future<PermissionState> checkPhotoPermission();
Future<PermissionState> requestPhotoPermission();
Future<List<MediaFile>> pickAssets({required List<MediaKind> acceptedKinds, required bool allowMultiple});
Future<File?> resolveAssetFile(String assetId);
```

权限类型：

```dart
enum PermissionKind { photoLibrary, filePicker, notification }
enum PermissionState { granted, limited, denied, permanentlyDenied, unsupported }
```

`PermissionService` 必须提供：

```dart
Future<PermissionState> check(PermissionKind kind);
Future<PermissionState> request(PermissionKind kind);
Future<void> openSettings();
```

`ShareService` 必须提供：

```dart
Future<void> shareFile({required String path, String? mimeType, String? subject});
```

`OpenFileService` 必须提供：

```dart
Future<OpenFileResult> open(String path);
```

平台规则：

- MVP 只读取相册，不保存到相册。
- MVP 只通过系统分享导出结果，不做系统另存为。
- 其他 App 分享进入不进入 MVP。
- 权限拒绝后返回结构化状态，由 UI 展示解释和“去设置”入口。

App 内路径约定：

```text
ApplicationDocumentsDirectory/Mova/Results
TemporaryDirectory/Mova/Working
ApplicationSupportDirectory/Mova/Logs
```

输出文件命名：

```text
{originalName}_{toolId}_{yyyyMMdd_HHmmss}_{shortTaskId}.{ext}
```

文件处理规则：

- 输出路径不得覆盖已有文件。
- 输入文件不存在时，不启动 FFmpeg。
- 打开或分享前必须检查输出文件存在。
- 删除任务记录时，UI 可以提供“同时删除输出文件”选项；默认先只删除记录。

权限矩阵：

| 能力 | iOS | Android | 触发时机 | MVP |
| --- | --- | --- | --- | --- |
| 系统文件选择 | Document Picker | Storage Access Framework / system picker | 用户点选文件 | 是 |
| 相册读取 | `NSPhotoLibraryUsageDescription` | Android 13+ `READ_MEDIA_IMAGES` / `READ_MEDIA_VIDEO`，旧版按插件要求 | 用户点相册 | 是 |
| 相册保存 | `NSPhotoLibraryAddUsageDescription` | MediaStore 写入 | 后续保存到相册 | 否 |
| 通知 | `NSUserNotificationUsageDescription` 相关能力 | `POST_NOTIFICATIONS` | 后续后台进度 | 否 |

权限状态必须区分：

```text
granted
limited
denied
permanentlyDenied
unsupported
```

不要在 App 启动时一次性请求权限。用户触发相册、文件、分享等能力时再请求。

## 图片组件实施

业务页面不得直接使用 `ExtendedImage`。必须使用以下封装：

```dart
class MovaImagePreview extends StatelessWidget {
  final String? path;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
}
```

```dart
class MovaImageThumbnail extends StatelessWidget {
  final String? path;
  final double size;
  final BorderRadius? borderRadius;
}
```

```dart
class MovaZoomableImage extends StatelessWidget {
  final String path;
  final String? heroTag;
}
```

组件必须处理：

- 空路径。
- 文件不存在。
- 加载中。
- 加载失败。
- 本地文件展示。
- 缩放和平移。
- 统一占位样式。

HEIC 预览规则：

- 如果 `extended_image` 不能直接预览当前 HEIC 文件，展示统一失败态。
- HEIC 转换成功后的 JPG/PNG 结果必须可预览。
- 不为 HEIC 预览单独引入新库，除非图片工具实现阶段确认必须。

## 平台配置实施

Android 必须检查：

```text
android/app/build.gradle
- namespace: com.peter100u.mova
- applicationId: com.peter100u.mova
- minSdk: 按 ffmpeg_kit_extended_flutter 和 Flutter 当前要求设置
- targetSdk: 使用当前 Flutter/Android 推荐值
```

`AndroidManifest.xml`：

```xml
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />
```

旧 Android 版本权限按 `permission_handler` 和 `photo_manager` 官方要求补充。不要为了 MVP 添加分享进入 intent filter。

iOS 必须检查：

```text
ios/Runner/Info.plist
- CFBundleDisplayName: Mova
- NSPhotoLibraryUsageDescription
```

MVP 不保存到相册，因此 `NSPhotoLibraryAddUsageDescription` 只有在后续启用相册保存时再加。

平台验收：

- iOS 模拟器可启动。
- Android 模拟器可启动。
- iOS 真机可选择相册或系统文件。
- Android 13+ 可选择图片、视频、音频。
- 权限说明文案不是占位文本。
- release build 不因为 FFmpeg 或权限配置失败。

## 错误体系实施

统一错误类型：

```dart
class AppError {
  final String code;
  final String messageKey;
  final String userMessage;
  final String? debugMessage;
  final Object? cause;
}
```

错误映射：

| 错误 | code | UI 行为 |
| --- | --- | --- |
| 权限拒绝 | `permissionDenied` | 说明原因，提供去设置 |
| 输入文件不存在 | `inputNotFound` | 提示重新选择文件 |
| 格式不支持 | `unsupportedFormat` | 提示更换文件或格式 |
| 空间不足 | `insufficientStorage` | 提示清理缓存或换文件 |
| FFmpeg 失败 | `ffmpegFailed` | 展示摘要，允许反馈 |
| 用户取消 | `cancelled` | 标记已取消，允许重试 |
| 打开失败 | `openFailed` | 提供分享或重新处理 |
| 分享失败 | `shareFailed` | 提供重试分享 |
| 未知错误 | `unknown` | 展示通用提示，允许反馈 |

错误展示规则：

- UI 不展示完整 FFmpeg 日志。
- 失败详情可以展示短摘要。
- 反馈邮件包含 App 版本、设备信息、工具 ID、错误 code、return code、log summary。
- 默认不附带输入文件或输出文件。

## UI 页面首版验收

首页：

- 底部导航包含首页、任务、设置。
- 首页包含视频、音频、图片 Tab。
- 工具列表来自 `ToolRegistry`。
- 点击工具进入 `/tools/:toolId`。

工具详情页：

- 显示工具名、输入文件摘要、推荐参数、开始按钮。
- 默认参数可直接开始。
- 高级参数折叠。
- 支持相册和系统文件选择。
- 多文件只设置一次参数。

任务页：

- 读取 Drift task stream。
- 展示处理中、成功、失败、已取消。
- 支持打开、分享、重试、删除。
- 失败任务展示用户可理解错误。

结果页：

- 展示输出文件名、大小、App 内结果位置。
- 支持打开。
- 支持分享。
- 支持再处理一个。
- 支持查看任务记录。

设置页：

- 多语言入口可以先预留。
- 意见反馈入口。
- 隐私政策、用户协议、许可证入口。
- 清理缓存。
- 关于 Mova 和版本号。

## 测试实施

首版至少写这些测试：

```text
test/
├── command_builder_test.dart
├── tool_registry_test.dart
├── task_repository_test.dart
├── file_name_utils_test.dart
└── widget/
    ├── home_page_test.dart
    └── task_state_test.dart
```

必须覆盖：

- ToolRegistry 能找到所有 MVP 工具。
- 每个 MVP 工具都有默认输出格式和默认参数。
- CommandBuilder 对每个 MVP 工具能生成命令和输出路径。
- TaskRepository 能创建任务、更新进度、标记成功、标记失败。
- 多文件输入会生成多条任务记录。
- 文件名工具能处理中文、空格、重复扩展名。
- 图片组件遇到空路径和不存在文件不崩溃。

测试不要求首版真的跑完整 FFmpeg。FFmpeg 执行用 fake service 测任务状态流。

## 首批实现顺序

按这个顺序写代码，不要跳到后续功能：

1. 创建 Flutter 项目和依赖配置。
2. 配置 `app.dart`、`theme.dart`、`router.dart`。
3. 创建核心模型和工具注册表。
4. 创建 Drift 数据库、TaskDao、TaskRepository。
5. 创建 service provider 和 fake MediaService。
6. 创建首页、工具详情页、任务页、结果页、设置页空壳。
7. 打通 `ToolFlowController.startTasks()` 到任务记录创建。
8. 用 fake runner 打通任务状态：queued -> running -> succeeded / failed。
9. 接入真实 file picker 和 photo manager。
10. 接入真实 `CommandBuilder` 和 FFmpeg。
11. 接入打开、分享、失败重试、删除记录。
12. 实现图片预览封装组件。
13. 补测试和许可证披露入口。

MVP 第一条真实链路建议先做 `video.extractAudio` 或 `image.convert`。只要第一条链路打通，其余工具应主要复用 ToolDefinition、CommandBuilder 和 TaskRunner。

## MVP 垂直切片

第一条可交付链路建议选择 `video.extractAudio`。

必须实现：

- 首页展示视频分类和 `video.extractAudio` 工具。
- 点击工具进入 `/tools/video.extractAudio`。
- 工具详情页支持系统文件选择。
- 选择视频后展示文件名、大小、格式、推荐输出 `m4a`。
- 点击开始后创建 task record。
- TaskRunner 调用 FFprobe 获取时长。
- CommandBuilder 生成视频转音频命令。
- FFmpeg 执行并更新进度。
- 成功后写入 App 内结果路径。
- 跳转 `/tasks/:taskId/result`。
- 结果页支持打开和分享。
- 重启 App 后任务页仍能看到记录。

这条链路完成后，再复用同一任务框架实现：

1. `image.convert`
2. `image.compress`
3. `audio.convert`
4. `audio.compress`
5. `video.compress`
6. `video.convert`
7. `image.heicToJpg`

## 开发完成定义

一个工具只有同时满足以下条件，才算完成：

- 从首页可进入。
- 能选择相册或系统文件。
- 能显示输入文件摘要。
- 默认参数能直接开始。
- 会创建任务记录。
- 能展示处理中进度。
- 成功后能在 App 内结果中找到输出文件。
- 能打开输出文件。
- 能分享输出文件。
- 失败时有错误分类和用户可理解提示。
- 任务记录中能重试或删除。
- 不直接从 Widget 调用数据库、FFmpeg 或平台插件。
- 相关 CommandBuilder 和任务状态测试通过。

## 建议的数据存储范围

Drift 首批可以保存以下数据：

- 任务记录：任务 ID、工具类型、输入文件信息、输出文件信息、状态、错误信息、创建时间、完成时间。
- 用户偏好：语言、是否显示首次启动说明。

不建议早期保存以下内容：

- 大体积媒体文件本体。
- 可由文件系统或任务执行过程重新生成的大型临时数据。
- 未经用户授权的敏感文件路径或隐私信息。
- 独立最近文件列表；MVP 先通过任务记录找回处理过的文件。
- 默认输出位置、主题设置、默认质量预设；这些设置项后续再加入。
- 用户自定义工具预设；MVP 的常用输出预设优先用内置静态配置表达。

## 待确认技术选型

以下选型暂未最终确定，进入实现前需要继续补充：

- 相册读取和后续写入细节：`photo_manager` 作为首选方案，但仍需小样验证 Android/iOS 权限差异、保存到相册表现和商店审核风险。
- Live Photo：后续高价值功能，需确认生成、保存、资源配对和 iOS 平台限制。
- 分享进入细节：后续再评估 `receive_sharing_intent` 或自定义原生实现，并验证 Android 分享 Intent、iOS Share Extension 和 App Group 配置。
- 打开文件和输出位置：`open_filex` 作为打开文件首选方案，但打开系统文件位置和文件不存在时的恢复策略仍需验证。
- 可用存储空间检测：任务开始前估算空间不足风险。
- 图片处理能力：图片格式转换、压缩、HEIC 处理是使用 FFmpeg、平台能力还是专门图片库。
- 后台任务能力：任务在前台、后台、锁屏和应用切换时的执行策略。
- 后续商业化：iOS、Android 的内购接入方案和权益校验方式。
- 日志和错误上报：本地日志、失败任务反馈、崩溃收集和隐私边界。
- 测试方案：单元测试、Widget 测试、数据库测试和关键任务流程测试。
- 构建发布：环境区分、版本号规则、应用签名、CI/CD 和商店发布流程。

## 选型原则

Mova 的技术选型应遵循以下原则：

- 优先选择 Flutter 生态中成熟、维护活跃、跨平台表现稳定的方案。
- 核心媒体处理能力优先保证可靠性，再追求参数丰富度。
- 任务、文件、权限和数据库相关模块要保持边界清晰，避免 UI 直接依赖底层实现。
- MVP 阶段不要过度设计云端能力，优先保证本地处理闭环可靠。
- 对涉及用户文件和隐私的能力保持保守，默认少收集、少上传、少暴露。
- 技术栈应服务于产品体验和开发效率，不为了引入新技术而增加维护复杂度。
- 一人开发优先选择清晰、直接、可维护的实现，不为了满足架构图而制造额外文件。
- 可以适度增加成熟依赖来减少重复代码、提升类型安全和调试效率，但不引入维护停滞或收益很小的依赖。
- 核心文件必须用简短注释说明职责、边界、状态流和副作用，方便长期维护和 AI 辅助理解。

## 目录变更规则

实施时以“工程目录和文件职责”章节为准。

允许调整：

- 某个 feature 文件超过 300 行时，可以拆出 `widgets/`、`models/`、`repositories/`。
- 某个 service 需要平台分支时，可以增加 `*_android.dart`、`*_ios.dart` 或 platform adapter。
- 某个工具参数明显复杂时，可以为该工具增加独立参数模型。

禁止调整：

- 不要把 `presentation/application/domain/data` 四层模板强加到每个功能。
- 不要为每个 repository 默认创建 abstract interface。
- 不要让 Widget 直接依赖 Drift、FFmpeg、文件选择器、相册插件或权限插件。
- 不要让工具页面各自实现任务记录、输出路径和进度解析。
- 不要把后续功能的依赖提前加入 MVP。
