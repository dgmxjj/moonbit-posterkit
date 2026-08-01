# moonbit-posterkit

`moonbit-posterkit` 是一个面向 MoonBit 的数据驱动海报/封面生成工具库，核心关注点是：

- 可复用模板
- 可枚举的预设、主题、样例包
- 可批量验证与渲染的 JSON 配置
- 适合测试、评审和自动化的稳定 SVG 输出

它不重复造底层 SVG 或图形库，而是把这些能力向上收敛成更贴近实际业务的“海报 DSL + 模板系统 + CLI 流程”。

## 适合的场景

- 黑客松项目封面、发布图、社媒宣发卡片
- 活动海报、工作坊卡片、报名视觉物料
- 社区周报、版本更新、栏目摘要图
- 需要“一份内容，多种尺寸，多张图自动产出”的项目

## 当前能力

- 5 套内置模板：`launch / editorial / event / quote / digest`
- 3 套尺寸预设：`instagram-square / social-story / youtube-thumbnail`
- 2 套主题：`warm-editorial / swiss-grid`
- `Block / Text / ImageSlot` 场景 DSL
- `stack / grid / anchor` 布局原语
- 拉丁文与 CJK 文案换行辅助
- 模板、预设、主题、样例包注册表
- typed batch config -> validate -> render -> SVG
- CLI 支持：
  - `batch`
  - `render`
  - `validate`
  - `emit-pack`
  - `list-templates`
  - `list-presets`
  - `list-themes`
  - `list-packs`
  - `catalog-json`
  - `catalog-md`

## 本地命令

```bash
moon check --target all
moon test --target all
moon fmt --check
moon info
moon run --target native src/cli list-templates
moon run --target native src/cli validate examples/batches/hackathon-showcase.json
moon run --target native src/cli batch examples/batches/hackathon-showcase.json examples/rendered
moon run --target native src/cli emit-pack quote-story-pack examples/batches/quote-story-pack.json
```

## 目录结构

- `src/core`：基础类型
- `src/theme`：主题、色板、字号、边距
- `src/preset`：尺寸预设
- `src/scene`：海报场景 DSL
- `src/layout`：布局算法
- `src/textflow`：文案换行与段落拆分
- `src/svg`：SVG 渲染器
- `src/template`：内置模板实现
- `src/config`：批量配置解析、校验与渲染入口
- `src/registry`：模板/预设/主题注册表
- `src/catalog`：样例 campaign pack
- `src/catalog_meta`：样例包清单与摘要
- `src/manifest`：JSON/Markdown 目录导出
- `src/cli_support`：可测试的 CLI 逻辑
- `src/cli`：可执行入口
- `examples/batches`：示例输入
- `examples/rendered`：示例输出

## 与现有生态的关系

在选题阶段已经检索过 MoonBit 生态关键词。当前生态里已经有 SVG、图形、布局或更底层的通用工具包，但缺少“海报/封面生成 DSL + 模板系统 + 批量配置渲染”这一层更贴近应用的成型工具。

`moonbit-posterkit` 的定位因此是：

- 不重写底层图形基础设施
- 聚焦模板化视觉产物生成
- 强调可测试、可审阅、可自动化

## 质量约束

- 多包结构、职责分层清晰
- `moon check --target all`
- `moon test --target all`
- `moon fmt --check`
- `moon info`
- CI 覆盖构建、测试、格式、接口生成和 CLI 烟测
- `src/**/*.mbt` 与 `src/**/*.mbti` 当前规模已超过 4000 行
- 来源说明单独记录在 `PROVENANCE.md`

## 来源说明

本仓库围绕 MoonBit 黑客松需求独立设计与实现。开发过程中参考了 MoonBit 官方文档、MoonBit 社区工作流模板以及比赛说明，但没有挪用其它成熟 MoonBit 项目的现成业务实现。

## License

Apache-2.0
