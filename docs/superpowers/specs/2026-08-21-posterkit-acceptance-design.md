# Posterkit 验收增强设计

## 目标

在保持现有公开 API 向后兼容的前提下，把 `moonbit-posterkit` 扩展为可用于批量视觉物料生产的 MoonBit 工具库：补足可复用的测量、布局、资源校验、诊断、参数化模板和批处理能力，建立真实可重复的基准数据，扩大边界测试，并将 CI 与 MoonBit 社区推荐工作流对齐。

申报书 `docs/application.md` 是只读输入，不在本设计或后续实现中修改。

## 非目标

- 不实现 PNG/PDF 光栅化后端；本次交付继续以确定性的 SVG 为主。
- 不引入未经确认的第三方渲染器、字体文件、图片素材或复制代码。
- 不删除、重命名或改变现有公开类型、函数和 CLI 命令的语义。
- 不通过无意义重复代码、生成空壳文件或伪造统计来满足源码规模要求。
- 不将申报过程、验收过程、贡献者说明写进产品 README。

## 设计方案

### 1. 测量与布局基础设施

在现有 `src/layout`、`src/scene` 和 `src/textflow` 的边界上增加可复用的测量模型：

- 统一的 `Size`、`Rect`、`Insets`、对齐和溢出结果；
- 最小/最大约束、内外边距、间距、可用宽高计算；
- stack、grid、anchor 三类布局的约束求解与越界诊断；
- 文本测量、行高、最大行数、截断和 CJK/Latin 混排策略；
- 对空内容、零尺寸、负值、极端长文本、单字符和超大画布给出稳定结果。

现有构造函数和布局入口继续保留；新增能力通过新类型、方法和辅助函数暴露。布局层不依赖 SVG 输出层，便于测试和未来增加其他输出后端。

### 2. 场景、资源与诊断

扩展 `src/scene` 与新增的资源/诊断相关包，形成“构造—校验—渲染”清晰数据流：

```text
typed document
    -> normalize
    -> validate(strict or relaxed)
    -> layout/measure
    -> SVG render
    -> output diagnostics and metrics
```

校验覆盖空 ID、重复 ID、非法尺寸、缺失图片槽位、无效颜色、不可见元素、文本溢出和图层顺序。诊断使用结构化错误码、路径和人类可读消息，CLI 能以稳定格式输出错误，库调用者则可以直接检查诊断值。

资源只表示 URI、尺寸、替代文本和可选元数据，不内置二进制文件。这样既支持生产配置校验，也不引入难以审计的素材来源。

### 3. 模板、配置与批处理

在 `src/template`、`src/config`、`src/registry` 和 `src/catalog` 现有能力上增加参数化和批处理控制：

- 模板参数默认值、必填字段、字段类型和可读的缺失字段错误；
- campaign pack 的变量覆盖、尺寸矩阵和主题覆盖；
- batch 任务的稳定排序、重复输出检测、失败任务汇总和成功/失败计数；
- strict 校验模式与兼容的 relaxed 模式；
- manifest/catalog 导出包含模板、尺寸、主题和输出统计，但不包含本地绝对路径。

新增模板优先选择能展示不同布局边界的少量模板变体，而不是复制相似模板。每个变体必须有配置样例、渲染结果和回归测试。

### 4. SVG 输出与 CLI

扩展 `src/svg` 支持新增的布局结果和可选视觉属性，同时保持输出稳定性：属性顺序、数字格式、元素顺序和换行规则固定。为 CLI 增加与现有命令兼容的辅助命令或选项：

- `validate --strict`：严格校验并输出稳定诊断；
- `inspect`：显示任务、模板、尺寸、图层和预计输出信息；
- `benchmark`：运行固定输入集并输出 JSON/文本摘要；
- 现有 `batch`、`render`、`emit-pack`、`catalog-*` 命令继续工作。

CLI 的文件系统写入集中在 `src/cli_support`，核心包保持纯数据处理，便于 wasm、js 和 native 目标分别验证。

### 5. 基准数据

基准使用仓库内可审计的固定 fixture，不依赖网络、时钟或随机数。至少覆盖：

- 单海报渲染：小、中、大三种画布；
- 长文本与 CJK 文本混排；
- 含多图层和多模板的 pack；
- 批量渲染 10、50、100 个任务。

基准程序输出：目标平台、MoonBit 版本、任务数、成功数、总耗时、平均耗时、最小/最大耗时、吞吐量、平均 SVG 字节数和失败数。结果写入 `docs/benchmarks/` 或 CI artifact；README 只记录运行方法和已实际运行的结果，不预先填写未验证数字。基准用于可重复比较，不把机器相关绝对时间当作跨平台承诺。

### 6. 测试策略

采用测试先行和分层验证：

- 包级单元测试：测量、约束、文本流、诊断、配置解析和批处理统计；
- 黑盒测试：从公共 API 构造文档并验证规范化、校验和 SVG 输出；
- 边界测试：空输入、零/极限尺寸、超长文本、重复 ID、缺失字段、非法 JSON、超深层级和重复输出路径；
- 快照/回归测试：关键模板的 SVG 输出保持稳定；
- CLI smoke test：验证列表、校验、渲染、pack 导出和 benchmark 输出；
- 多目标测试：默认目标、`wasm`、`wasm-gc`、`js`、`native`，以当前工具链实际支持的目标为准；
- 警告与接口检查：`moon check --deny-warn`、`moon test --deny-warn`、`moon fmt --check`、`moon info` 后检查工作区无未预期差异。

测试不得依赖本地用户目录、网络服务或未提交的生成文件。所有新增公开 API 需要至少一个使用示例或黑盒测试。

### 7. CI 与发布

`.github/workflows/test.yml` 对齐 `moonbit-community/.github` 的模板结构：三平台矩阵、官方安装脚本、`moon version --all`、`moon update`、`moon check --target all`、`moon test --target all`、格式检查和 `moon info` 差异检查；在 Ubuntu 增加 native 测试、覆盖率摘要和 CLI smoke test。工具链不再硬编码旧版本，使用安装脚本提供的最新 stable，并在日志中记录实际版本。

`.github/workflows/publish.yml` 保留手动发布，改为先执行与 CI 一致的预发布检查，再使用 GitHub Actions secret 调用 `moon publish`。本地发布前先运行 `moon login` 状态检查和 `moon publish --dry-run`（若当前工具链支持）；正式发布只在所有本地检查通过后进行。模块命名空间继续使用 `dgmxjj/moonbit-posterkit`，以满足 Mooncakes 发布路径。

## README 结构

重写 `README.md` 和对应的 `README.mbt.md`，采用成熟开源项目结构：

1. 项目一句话定位和能力概览；
2. 特性；
3. 安装与快速开始；
4. 公共包结构与 API 入口；
5. CLI 用法；
6. 批量配置与模板示例；
7. 基准运行方法与实际结果；
8. 测试和 CI；
9. 资源/来源说明；
10. 贡献指南与许可证。

README 不包含申报人、结项、唯一贡献者、验收过程、申报书修改说明等内部表述，也不写未经命令验证的源码行数、测试数量或性能数字。

## 验收证据

交付前收集并保留以下可复核证据：

- `moon version --all` 实际输出；
- 实际 MoonBit 源码行数统计，排除 `_build`、缓存和生成目录，并区分实现、测试和接口文件；
- `moon check`、`moon test`、`moon fmt`、`moon info` 的退出状态与摘要；
- benchmark 原始输出与运行命令；
- CLI smoke test 生成物；
- `git log`、远程 URL、默认分支和推送后的 commit；
- Mooncakes 查询或发布命令的实际结果。

任何无法在本地或远程命令中验证的项目，只作为风险或待确认项报告，不写成已完成事实。
