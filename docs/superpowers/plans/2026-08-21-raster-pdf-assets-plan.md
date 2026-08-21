# PNG/PDF、图片资源与运营主题包实施计划

## 目标

在不修改申报书、不破坏现有 SVG/public API 的前提下，实现设计文档中的真实 PNG/PDF 输出、图片资源校验与四类社区运营主题包，并完成跨目标验证和发布证据。

## 执行顺序

1. **基线与 API 约束**
   - 检查当前工作区只保留用户对 `docs/application.md` 的修改。
   - 记录现有 `moon info`、全目标 check/test、公共接口快照和源码规模。
   - 确认新包命名、依赖和 CLI 参数不改变现有命令语义。

2. **图片资源解析（TDD）**
   - 先添加 PNG/JPEG 合法 header、空数据、截断数据、零尺寸、超大尺寸和未知格式失败测试。
   - 实现 `src/assets` 的格式识别、尺寸解析、资源约束与 `contain`/`cover` 适配。
   - 接入 scene/config 的资源诊断，但保持远程资源不下载、不伪造像素解码。

3. **PNG 编码器（TDD）**
   - 先添加 signature、IHDR、IDAT、IEND、CRC、单像素、多行和确定性测试。
   - 实现纯 MoonBit RGBA/灰度图像模型、scanline、stored DEFLATE block、Adler-32 与 CRC-32。
   - 用标准 PNG signature/块校验器验证真实输出，保存小型 fixture。

4. **PDF 矢量导出（TDD）**
   - 先添加 PDF header、EOF、对象、xref、空文档、文本、矩形和非法尺寸测试。
   - 实现固定对象编号和 xref 偏移的单页 PDF writer。
   - 接入背景、基础文本、矩形、线条和 image slot 占位框的 render bridge；复杂效果返回明确诊断。

5. **运营主题包**
   - 先为四种 pack 添加 registry/catalog/JSON round-trip/严格校验失败测试。
   - 实现 release note、community digest、event announcement、project spotlight 的内容字段、模板变体和默认 pack。
   - 添加四个 JSON fixture、catalog 文档和至少一个 SVG/PNG/PDF 输出证据。

6. **CLI 与批量导出**
   - 先添加 `assets inspect`、`export png`、`export pdf` 的参数解析、错误码和输出文件测试。
   - 实现逐 job 输出、目录创建、失败汇总和确定性报告。
   - 修复已发现的 `inspect` 输出字面量 bug，并添加回归测试。

7. **文档、基准与 CI**
   - README 增加真实命令、格式限制、输出示例和失败诊断。
   - 增加 PNG/PDF/资源基准记录，只报告可复现的字节数/成功数，不虚报 wall-clock。
   - CI 增加导出 smoke test、PNG/PDF signature 检查和资源边界测试；Windows native 步骤明确使用 UCRT64 shell。

8. **最终验收与发布**
   - 运行 `moon fmt --check`、`moon info`、`moon check --deny-warn --target all`、各目标测试、CLI smoke test。
   - 统计 `.mbt` 实现+测试行数，确认仓库无构建缓存和临时文件。
   - 更新版本、提交、推送 GitHub、发布 Mooncakes，并记录真实结果。

## TDD 纪律

每个新增行为必须遵循：先写最小失败测试并确认失败原因，再写最小实现，随后运行目标测试和全量回归。生成的 `pkg.generated.mbti` 只能通过 `moon info` 更新，不能手工编辑。

## 风险控制

- 不实现完整 JPEG 像素解码，避免引入不透明的第三方代码；JPEG 先做可信元数据解析。
- PNG 采用无压缩 stored block，优先保证合法性、确定性和可维护性，而不是压缩率。
- PDF 先限定单页基础矢量对象，避免把未实现的字体、滤镜或多页布局伪装成已支持。
- 所有不支持的输入返回可测试错误，不静默生成不完整文件。
