# PosterKit 图片资源、PNG/PDF 导出与运营主题包设计

## 目标

补齐申报书后续计划中的三类可验收能力：

1. 图片资源解析、校验和适配；
2. 真实 PNG 与 PDF 文件导出；
3. 面向 MoonBit 社区运营的可复用主题包。

实现必须保持纯 MoonBit、跨 wasm/wasm-gc/js 可检查，并让 native CI 能够运行。PNG 和 PDF 输出必须是结构合法、可被标准工具识别的文件，不生成改扩展名的 SVG 占位文件。

## 范围与非目标

本轮支持：

- PNG：生成 RGBA/灰度基础图像，写出 PNG signature、IHDR、IDAT、IEND，并提供校验和；
- PDF：生成单页矢量 PDF，支持页面尺寸、背景、文本、矩形、线条和图片占位框；
- 图片资源：解析 PNG/JPEG 的尺寸和格式，拒绝截断、尺寸溢出和不支持的格式，提供 `contain`/`cover` 适配计算；
- 运营主题：新增 release note、community digest、event announcement、project spotlight 等主题 pack，并通过现有 registry/catalog/CLI 暴露；
- CLI：提供独立的导出、资源检查和主题 pack 命令，所有输出路径可测试、错误可诊断。

不在本轮承诺：完整 JPEG 解码、复杂字体栅格化、滤镜/阴影、PDF 多页排版、远程下载资源、PNG/PDF 的照片级渲染。图片处理 API 会保留扩展点，但不虚构尚未实现的解码能力。

## 架构

### assets 包

新增 `src/assets` 包：

- `ImageFormat`：`Png`、`Jpeg`、`Unknown`；
- `ImageInfo`：格式、宽度、高度、颜色类型、字节长度；
- `ImageAssetError`：空数据、截断、非法 signature、非法尺寸、不支持格式；
- `parse_image_info(bytes)`：只读取可靠的 PNG/JPEG header，不声称解码像素；
- `fit_rect(source, target, mode)`：返回缩放后的绘制矩形和裁剪偏移；
- `validate_asset(id, bytes, constraints)`：将资源元数据接入现有 scene/config 诊断。

PNG 解析检查 signature、IHDR 长度、宽高和颜色类型。JPEG 解析 SOI 与 SOF marker，遇到无法完整读取的 marker 返回错误。所有尺寸计算使用安全整数边界。

### export 包

新增 `src/export` 包，避免修改现有 SVG 公共 API：

- `PngImage`：宽高、像素布局、背景和绘制操作；
- `encode_png(image)`：输出 `Array[Byte]` 或可序列化二进制容器；
- `PdfDocument`：页面尺寸和对象列表；
- `render_pdf(document)`：输出合法 PDF 字节序列；
- `ExportError`：尺寸、颜色、对象数量、编码和输出错误。

PNG 使用无压缩 DEFLATE/stored block，减少实现复杂度并保证跨平台确定性；写入 CRC-32 与 Adler-32。PDF 使用固定对象顺序、ASCII 内容流和正确 xref/trailer，确保同一输入产生相同字节结果。

### render bridge

新增 `src/export/bridge.mbt`，将现有 `PosterDocument` 的背景、文本、矩形和图片槽转换为 PDF/PNG 的最小绘制模型。SVG 仍是完整功能后端；PNG/PDF 对暂不支持的字体或复杂效果返回明确诊断，而不是静默丢失。

### 运营主题包

扩展 `src/catalog_meta` 和 `src/registry`：

- `release-note-pack`：版本号、变更摘要、升级提示；
- `community-digest-pack`：周报、精选项目、社区链接；
- `event-announcement-pack`：时间、地点、议程、报名入口；
- `project-spotlight-pack`：项目简介、技术标签、贡献入口。

每个 pack 提供完整 JSON fixture、模板、默认主题/预设、catalog 元数据和至少一个渲染快照。pack 不使用远程图片，图片字段保留为显式 asset slot。

## CLI 与文档

新增命令：

- `assets inspect <file>`：输出格式、尺寸、颜色类型和校验结果；
- `export png <batch.json> <output-dir>`；
- `export pdf <batch.json> <output-dir>`；
- `list-packs` 和 `emit-pack` 扩展到新增运营 pack。

README 增加真实命令、输出样例、格式限制和失败诊断；基准记录分别统计 SVG/PNG/PDF 的输出字节数、成功数和确定性摘要，不把字节数误称为 wall-clock 性能。

## 测试策略

先写失败测试，再实现：

- PNG：signature、空像素、单像素、多行图像、CRC、截断数据和尺寸边界；
- PDF：header、%%EOF、xref 偏移、文本/矩形对象、空文档和超大尺寸拒绝；
- 资源：合法 PNG/JPEG header、截断 marker、未知格式、零尺寸、contain/cover 边界；
- bridge：确定性输出、基础元素映射和不支持元素的诊断；
- 主题：四个 pack 的 catalog 注册、JSON round-trip、严格校验和渲染；
- CLI：成功路径、非法路径、错误退出码和输出文件存在性；
- 全目标：`moon check --deny-warn --target all`、`moon test --deny-warn --target all`、`moon fmt --check`、`moon info`。

## 验收证据

最终必须提供：

- 至少一个真实 PNG 和一个真实 PDF 文件，并用本项目校验器及文件 signature 检查；
- 四个运营主题 pack 的可复现输入与输出摘要；
- CLI 命令输出和失败用例；
- 当前 MoonBit 版本、测试总数、`.mbt` 实际行数和基准输出；
- CI 工作流与 Mooncakes 发布结果。
