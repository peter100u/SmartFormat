# Mova 技术栈文档

## 文档目的

本文档记录 Mova 当前已经确定的核心技术选型，以及后续需要继续确认的工程选型。它不是完整的工程规范，而是用于让产品、设计和开发在早期阶段对技术边界形成一致认知。

随着项目从产品规划进入工程实现，本文档应持续补充具体依赖、版本约束、模块边界和平台差异处理方案。

## 应用标识

- 产品名称：Mova
- Android applicationId：`com.peter100u.mova`
- iOS Bundle Identifier：`com.peter100u.mova`
- Dart package name 建议：`mova`

Flutter 项目初始化、Android 包名、iOS bundle identifier、商店后台、隐私政策、用户协议、反馈邮件模板和许可证披露页面都应使用以上标识。后续如果调整包名，必须在工程配置、商店配置和文档中同步修改。

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

- 应用级状态：主题、语言、权限状态。
- 工具配置状态：当前选择的工具、输入文件、输出目标、参数预设。
- 任务状态：处理中、成功、失败、取消和重试。
- 持久化状态：任务记录、最近文件、用户偏好。

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
│   ├── image
│   └── toolbox
├── tasks
│   └── :taskId
├── settings
└── tools
    └── :toolId
```

### 本地数据库

Mova 使用 Drift 作为本地数据库方案。

Drift 适合 Mova 的原因：

- 基于 SQLite，适合本地任务记录、用户偏好、最近文件和处理历史。
- 支持类型安全查询，能降低手写 SQL 的维护成本。
- 适合 Flutter 应用离线优先的数据存储需求。
- 方便后续做数据库迁移、任务筛选、失败重试和历史记录检索。

MVP 阶段数据库重点服务于任务记录和用户偏好，不应过早承担复杂业务逻辑。

### 媒体处理

Mova 使用 `ffmpeg_kit_extended_flutter` 作为本地媒体处理核心。

该依赖用于：

- 视频格式转换、压缩和提取音频。
- 音频格式转换、压缩和从视频提取音频。
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

Mova MVP 需要完整支持输入源、输出目标、权限恢复和结果分享，因此需要明确平台能力依赖。

首批依赖：

- `file_picker`：系统文件选择器，用于从文件 App 或系统存储选择单个或多个输入文件，也用于系统保存/另存为流程。
- `photo_manager`：相册资产读取、相册保存、相册权限状态和部分 Live Photo 资源能力。MVP 先用于相册读取和保存，Live Photo 仅作为后续验证方向。
- `permission_handler`：统一检查和请求相册、通知、存储等权限，并支持跳转系统设置。
- `share_plus`：分享处理后的文件到其他 App，支撑结果页和任务记录快捷操作。
- `receive_sharing_intent`：接收其他 App 分享进入的文件，支撑移动端关键输入源。
- `open_filex`：调用系统能力打开处理后的文件，支撑结果页和任务记录的「打开」操作。
- `url_launcher`：打开隐私政策、用户协议、许可证源码链接、反馈邮件或外部网页。

这些能力必须通过 `services/` 层封装，页面不能直接依赖插件 API。权限被拒绝时，service 应返回能被 UI 翻译成人话的状态，而不是把平台错误直接抛到页面。

分享进入注意事项：

- Android 需要配置 `SEND`、`SEND_MULTIPLE` 和相关 MIME type intent filter。
- iOS 需要 Share Extension、App Group 和对应 entitlement。
- 分享进入的数据应先转换为统一的输入文件模型，再进入工具选择或任务创建流程。
- 接收到多个文件时，遵循多文件输入规则，为每个文件生成独立任务。

### 国际化与本地偏好

Mova 设置页包含多语言、主题模式、默认输出位置和首次启动说明，因此需要区分轻量偏好和结构化数据。

- `flutter_localizations`：使用 Flutter SDK 自带本地化支持。
- `intl`：用于日期、数字、文件大小、任务时间和多语言文案格式化。
- `shared_preferences`：用于主题模式、语言、首次启动说明是否展示、默认质量预设等轻量偏好。

Drift 负责任务记录、最近文件、工具预设等结构化数据；`shared_preferences` 只负责少量 key-value 设置。不要把任务记录放进 `shared_preferences`，也不要为了一个布尔设置去建 Drift 表。

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
- 让任务记录、最近文件、工具列表、预设列表等逻辑更短、更可读。

collection 的使用原则：

- 优先替代容易出错的手写循环和空值判断。
- 不为了使用函数式写法而牺牲可读性。
- 简单循环更直观时，可以继续使用普通 `for`。

### 开发效率依赖

Mova 可以适度增加成熟依赖来提高开发效率。这里的原则是：可以为了减少重复劳动而堆库，但不要为了堆库而扩大架构复杂度。

以下版本号按 2026-07-02 在 pub.dev 查询到的最新稳定版本记录。创建 Flutter 项目时可以先按这里写入 `pubspec.yaml`，之后通过 `flutter pub outdated` 定期检查是否有更新。

建议现在就加入的依赖：

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
  receive_sharing_intent: ^1.8.1
  open_filex: ^4.7.0
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
- `ffmpeg_kit_extended_flutter`：提供 FFmpeg、FFprobe 和 FFplay 能力，支撑本地媒体转换、压缩、信息读取、日志和进度统计。
- `file_picker`：提供系统文件选择和系统保存能力。
- `photo_manager`：提供相册读取、相册保存和相册权限相关能力。
- `permission_handler`：处理权限检查、权限请求和跳转系统设置。
- `share_plus`：提供结果文件分享能力。
- `receive_sharing_intent`：接收其他 App 分享进入的文件。
- `open_filex`：调用系统能力打开处理结果文件。
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
- `in_app_review`：设置页评价 App 属于后续能力，有一定用户量和商店信息确定后再加入。
- `in_app_purchase`：MVP 不做付费页、恢复购买或权益管理，后续商业化阶段再加入。
- 崩溃上报或分析 SDK：MVP 优先保持本地处理和隐私信任，后续需要线上质量监控时再评估。

MVP 前需要继续调研确认的能力：

- 可用存储空间检测。
- iOS Share Extension 和 App Group 的最小实现方案。
- 图片处理能力：图片格式转换、压缩、HEIC 处理是使用 FFmpeg、平台能力还是专门图片库。
- 保存到系统文件时，不同 Android/iOS 版本的目录选择、文件覆盖和权限表现。

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

## 建议的数据存储范围

Drift 首批可以保存以下数据：

- 任务记录：任务 ID、工具类型、输入文件信息、输出文件信息、状态、错误信息、创建时间、完成时间。
- 最近文件：文件名、路径或平台访问标识、媒体类型、最近使用时间。
- 用户偏好：默认输出位置、默认质量预设、主题设置、是否显示首次启动说明。
- 工具预设：用户保存的转换参数、压缩参数、常用输出格式。

不建议早期保存以下内容：

- 大体积媒体文件本体。
- 可由文件系统或任务执行过程重新生成的大型临时数据。
- 未经用户授权的敏感文件路径或隐私信息。

## 待确认技术选型

以下选型暂未最终确定，进入实现前需要继续补充：

- 相册读写细节：`photo_manager` 作为首选方案，但仍需小样验证 Android/iOS 权限差异、保存到相册表现和商店审核风险。
- Live Photo：后续高价值功能，需确认生成、保存、资源配对和 iOS 平台限制。
- 分享进入细节：`receive_sharing_intent` 作为首选方案，但仍需验证 Android 分享 Intent、iOS Share Extension 和 App Group 配置。
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

## 初始模块划分建议

```text
lib/
├── app/
│   ├── app.dart            # App 根组件
│   ├── router.dart         # go_router 路由
│   └── theme.dart          # Material 3 主题
├── core/
│   ├── constants/          # 全局常量
│   ├── errors/             # 通用错误类型
│   └── utils/              # 通用工具方法
├── data/
│   ├── database/           # Drift 数据库、表、DAO、迁移
│   └── repositories/       # 跨功能复用的数据仓库
├── services/
│   ├── media_service.dart  # 媒体处理能力封装
│   ├── task_runner.dart    # 任务执行、进度解析、取消和结果回写
│   ├── command_builder.dart
│   ├── file_service.dart   # 文件选择、保存、路径处理
│   ├── photo_service.dart  # 相册读取和保存
│   ├── permission_service.dart
│   ├── share_service.dart
│   ├── receive_share_service.dart
│   ├── open_file_service.dart
│   ├── app_info_service.dart
│   └── feedback_service.dart
├── features/
│   ├── home/
│   ├── tools/
│   ├── tasks/
│   ├── settings/
│   ├── video/
│   ├── audio/
│   └── image/
└── shared/
    ├── widgets/            # 通用 UI 组件
    ├── models/             # 多功能共享模型
    └── tool_registry/      # 工具定义和工具注册表
```

功能模块默认使用轻量结构：

```text
features/tasks/
├── tasks_page.dart
├── task_detail_page.dart
├── task_controller.dart
├── task_state.dart
└── widgets/
```

当功能变复杂时，再按需增加文件：

```text
features/tasks/
├── task_repository.dart
├── task_model.dart
└── task_mapper.dart
```

如果某个功能后续明显变大，再进一步拆成子目录：

```text
features/tasks/
├── pages/
├── controllers/
├── widgets/
├── models/
└── repositories/
```

这个结构只是初始建议。实际工程可以随着 Flutter 项目创建和功能拆分继续调整，但应避免把任务处理、数据库访问和 UI 状态全部堆在页面文件中。判断是否增加抽象的标准不是“架构是否完整”，而是“这个抽象是否减少复杂度、方便测试或隔离变化”。
