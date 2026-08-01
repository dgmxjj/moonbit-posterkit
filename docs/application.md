# moonbit-posterkit 项目申报书

## 一、项目概述

`moonbit-posterkit` 是一个面向 MoonBit 生态的海报与封面生成工具库，定位为“数据驱动的视觉产物生成 DSL”。项目围绕活动海报、项目封面、社区周报、版本发布图、社媒宣传卡片等常见开源社区场景，提供从结构化配置到 SVG 输出的完整流程。它不是重复实现底层图形库，而是在 MoonBit 现有生态之上补齐更贴近实际应用的一层：模板系统、主题系统、尺寸预设、布局原语、文字流处理、批量渲染与 CLI 自动化。

项目名称为 `moonbit-posterkit`，模块标识为 `dgmxjj/moonbit-posterkit`，当前采用 Apache-2.0 开源许可证。仓库以 MoonBit 源码为主体，围绕 `src/core`、`src/theme`、`src/preset`、`src/scene`、`src/layout`、`src/textflow`、`src/svg`、`src/template`、`src/config`、`src/registry`、`src/catalog`、`src/manifest` 和 `src/cli_support` 等包进行分层组织，形成可测试、可扩展、可审阅的项目结构。

## 二、选题背景与价值

MoonBit 已经具备适合工程化开发的语言工具链，但生态中面向“内容生成”和“视觉配置自动化”的成熟工具仍然偏少。开源项目在推广、发布和社区运营时，常常需要把同一份内容输出为不同尺寸、不同主题、不同渠道的图片物料。传统做法依赖设计工具手工排版，或者用脚本临时拼接 SVG，复用性和稳定性都不足。

`moonbit-posterkit` 的价值在于把这类需求抽象为可声明、可校验、可批量运行的 MoonBit 工作流。使用者可以通过 typed batch config 描述海报内容，选择模板、主题和尺寸预设，再由 CLI 完成校验、渲染和目录生成。对于参赛项目、开源仓库和社区运营场景，这种能力可以降低重复制作成本，也能展示 MoonBit 在 DSL、工具链和自动化内容生产方向上的应用潜力。

## 三、核心功能

项目目前已实现 5 套内置模板：`launch`、`editorial`、`event`、`quote`、`digest`；提供 3 套常用尺寸预设：`instagram-square`、`social-story`、`youtube-thumbnail`；内置 `warm-editorial` 与 `swiss-grid` 两套主题。核心 DSL 支持 `Block`、`Text`、`ImageSlot` 等场景元素，布局层提供 `stack`、`grid`、`anchor` 等组合方式，文字流模块提供拉丁文本与 CJK 文案换行辅助。

CLI 已覆盖常用操作，包括 `batch`、`render`、`validate`、`emit-pack`、`list-templates`、`list-presets`、`list-themes`、`list-packs`、`catalog-json` 和 `catalog-md`。仓库同时提供示例输入、示例 SVG 输出、模板目录 JSON/Markdown 文档和来源说明，便于评审者快速理解项目完成度。

## 四、技术方案

项目采用分层架构。`core` 定义画布、颜色、间距、排版等基础类型；`theme` 与 `preset` 负责视觉风格和目标尺寸；`scene` 承载海报 DSL；`layout` 与 `textflow` 处理元素排布和文本换行；`svg` 负责稳定输出；`template` 和 `registry` 负责模板注册与复用；`config` 将外部 JSON 配置转换为内部渲染任务；`manifest` 输出可读的模板目录；`cli_support` 将命令行逻辑拆分为可测试函数，`cli` 只保留可执行入口。

这种设计避免把业务逻辑堆在单一文件中，也方便后续扩展新的模板、新的尺寸预设、新的渲染目标或新的配置来源。当前项目已跟踪 `pkg.generated.mbti`，便于通过 `moon info` 审阅公开 API 变化。

## 五、质量与合规

仓库已配置 GitHub Actions CI，覆盖 MoonBit 0.10.3 工具链安装、`moon check --target all`、`moon test --target all`、格式检查、接口信息生成检查以及 CLI smoke test。当前本地验证以 `moon check --target all`、`moon test --target all`、`moon fmt --check` 和 `moon info` 为主要依据。

项目提交历史保持增量式开发记录，当前 GitHub 仓库保留 12 次有效提交，贡献者身份统一为仓库账号本人。仓库包含 `LICENSE`、`PROVENANCE.md`、README、示例配置、示例输出和 CI 配置。来源说明中明确记录：项目为 MoonBit 八月黑客松场景独立设计与实现，参考 MoonBit 官方文档、社区工作流模板和比赛提交要求，没有移植其他成熟 MoonBit 项目的业务实现，也没有引入虚拟贡献者。

## 六、当前成果与后续计划

当前成果已经形成一个可运行、可测试、可展示的 MoonBit 工具库：源码规模超过 4000 行，具备模板化海报生成、批量配置渲染、目录导出、示例包生成和自动化测试能力。它能够作为 MoonBit 在“内容生产 DSL”方向的一个应用样板，也能为后续更复杂的封面、报告图、活动物料生成场景打基础。

后续计划包括：扩充模板市场式 catalog、增加更多社媒尺寸预设、完善图片占位与资源校验、支持更丰富的字体与文本约束、增加 PNG/PDF 等导出后端，并逐步沉淀面向真实社区运营的主题包。项目最终目标是成为 MoonBit 生态中稳定、可复用、工程化的视觉物料生成工具。
