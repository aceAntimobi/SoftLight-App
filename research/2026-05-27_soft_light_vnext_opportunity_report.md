# Soft Light vNext 竞品调研、机会点与迭代方案

- 日期: 2026-05-27
- 市场优先级: 美国优先
- 项目路径: `/Users/all/Documents/codex/移动项目/soft_light`
- 本轮目标: 先做竞品与用户声音调研，再筛出一个最优价值点；不为了“显得创新”硬加功能。

## 1. 结论先行

最值得做的 vNext 功能不是继续堆白屏、色盘、渐变、音乐或普通红光，而是：

**Creator Glow Studio：低光自拍 / 短视频柔光工作室**

一句话定义：把 Soft Light 从“柔光灯工具”升级成“手机低光内容创作补光助手”，提供可直接复用的肤色与场景灯光配方、实时取景补光、曝光/过曝提示、以及不遮挡主体验的极简灯光控制。

推荐原因：

- 普通白屏灯需求真实，但已经高度同质化，用户最在意的是无广告、全屏、简单、别刺眼；这更像基础卫生条件，不是突破点。
- 红光/超低亮睡前模式有社区热度，但系统能力、Twilight/Extra Dim、各类滤镜 App 已经占位；适合做辅助模式，不适合作为唯一增长突破。
- 低光自拍/短视频补光同时被 App Store 评论、Google Play 产品定位、TikTok 传播、硬件补光灯替代品共同验证；而现有软件多停留在“屏幕变亮 + 调色”，缺少“拍人好看”的可复用配方和实时判断。
- Soft Light 已经有柔光、色彩、亮度、手势和本地保存基础，做这个方向的边际成本比从零做相机 App 低。

最终建议：vNext 只做一个高价值新增主线：**自拍/短视频补光模式**。夜间红光、婴儿夜灯、摄影背光只保留为后续模式包或文案场景，不进入本轮核心开发。

## 2. 竞品格局

| 类型 | 代表样本 | 已满足 | 主要缺口 | 对 Soft Light 的启示 |
| --- | --- | --- | --- | --- |
| 极简白屏 | Google Play `White Screen`，100K+ 下载、4.4 星、1.64K 评论 | 全屏白光、无权限、无广告 | 没有场景化、没有创作指导 | 简单无广告是底线，不是差异化 |
| 白屏手电 | `White Screen Flashlight`、本地第一轮样本 | 亮度/颜色/全屏灯 | 广告遮挡、误触、主体验被破坏 | 任何广告都不能压主灯光区 |
| 综合手电 | `Simple Flashlight`，1M+ 下载，强调无广告、颜色、SOS、低电量可用 | 功能完整、工具性强 | 偏工具，不服务“拍人好看” | 不要和它拼 SOS/工具箱 |
| 阅读/夜灯 | 本地 `Reading Light`、`TableLamp` | 色温、定时、阅读灯、放松场景 | 功能容易变散，增长钩子弱 | 可借鉴轻高级面板，不做音乐大杂烩 |
| 自拍补光 App | `GlowCam`、`LightCam`、`GlowCam AI` | 前置闪光、预览、颜色/亮度 | 付费争议、质量/清晰度问题、配方不足 | 机会在“免费可试 + 专业配方 + 结果稳定” |
| 硬件补光灯 | Godox LR30Bi、TikTok Shop 夹式灯 | 真实光源、前后摄像头都能补光 | 需要购买/携带/充电 | 软件可赢在随手可用和社交传播 |

本地已有竞品矩阵也支持这个判断：第二轮样本说明“全屏灯光 + 底部工具条 + 手势亮度”成立，但 TableLamp 入口过多，Reading Light 更轻；广告、商店链路或交叉推广会伤害核心灯光体验。

## 3. 用户声音证据库

### 3.1 App 评论与商店信号

1. 白屏灯用户要“极简、无广告、全屏”。Google Play `White Screen` 的描述强调只显示空白白屏、无权限、屏幕常亮；评论里用户认可“什么都不多做”的价值，也提到用作夜间人像补光、背光观察小物等非预期场景。来源: https://play.google.com/store/apps/details?hl=en-US&id=com.hungrydroid.whitescreen

2. 广告是白屏灯的硬伤。`White Screen Flashlight` 评论里有用户抱怨广告条把 5.5 英寸灯光变成 4.5 英寸，夜间使用还可能误触导致失去照明；同页另有用户说手机自带手电太刺眼，屏幕灯更适合夜间写字和近距离用光。来源: https://play.google.com/store/apps/details?id=cz.nowi.whitescreen

3. 自拍补光有明确付费与质量争议。`GlowCam: AI Photo Editor` 的 App Store 评论提到用户是从 TikTok 上看到推荐而下载，痛点是暗光照片质量差；但也明确抱怨必须付费、基础补光不应该强制订阅。来源: https://apps.apple.com/us/app/glowcam-ai-photo-editor/id6739193579?platform=iphone&see-all=reviews

4. LightCam / GlowCam 类产品用“Take Selfies in the Dark”做主卖点。`GlowCam Light - SelfieCam` 在 App Store 有 2.3K ratings、4.7 分，描述里突出 Virtual Front Flash、Preview Controls、Any Colors。来源: https://apps.apple.com/us/app/glowcam-light-selfiecam/id6740575809

5. Android 上同方向也存在量级信号。`GlowCam: Selfies in the Dark` Google Play 页显示 100K+ 下载，卖点是低光自拍、前置虚拟闪光、拍前预览、自定义颜色。来源: https://play.google.com/store/apps/details?hl=en&id=com.selfie.light.glowcam

### 3.2 社区声音

1. 夜间用屏用户反复说“最低亮度仍然太亮”。Reddit `r/sleep` 有开发者贴提到 Night Shift + 最低亮度仍然刺眼，所以做了红光与 ultra-dim；这说明低刺激模式有真实痛点，但它更像独立滤镜/系统辅助领域。来源: https://www.reddit.com/r/sleep/comments/1s1s4k5/night_shift_wasnt_enough_so_i_built_a_true_red/

2. `r/ADHD` 红光讨论给出一个有用反证：红屏不只是护眼，还能让内容变无聊、减少刷 TikTok/Instagram；但评论里也有人说自己会关掉滤镜，或更喜欢 Extra Dim。这说明红光适合做“睡前模式”，但做成主增长功能会遇到系统替代和长期坚持问题。来源: https://www.reddit.com/r/ADHD/comments/1mepflv/turn_your_phone_screen_red_at_night_trust_me/

3. 父母夜间场景强调“不要智能负担”。Reddit `r/BabyBumps` 里用户吐槽婴儿夜灯/声音机需要 WiFi、登录、同步、固件更新，真正想要的是能记住上次设置、半夜不用点亮刺眼手机屏幕、无需账号密码。来源: https://www.reddit.com/r/BabyBumps/comments/1q6ax0a/stop_making_baby_gear_smart_if_it_cant_work_at_3am/

4. 前置屏幕闪光的负面声音集中在“突然刺眼、自动开启、拍照尴尬”。Reddit `r/Oppo` 用户抱怨暗处自拍时白屏补光自动打开，即使手动关闭下次又恢复 Auto，突然照脸很尴尬。来源: https://www.reddit.com/r/Oppo/comments/1q2sww2/two_fundamental_flaws_or_bug_in_the_oppo_camera/

### 3.3 短视频与社交信号

1. GlowCam 的 TikTok 传播不是讲功能，而是讲“暗光/模糊照片怎么救”。Playkit 对 GlowCam TikTok 策略复盘显示，代表视频有 7.1M+ views、703K+ likes、261.5K+ saves；另一个 before/after 视频 5.2M+ views、477.8K+ likes、179.7K+ saves。来源: https://playkit.beehiiv.com/p/glowcam-selfie-lighting-app

2. TikTok 官方商家内容也把“画面清晰、颜色不失真、不过曝/不欠曝”作为转化基础。它提醒直播画面如果模糊或颜色失真，用户无法准确识别产品；这不是自拍 App 竞品声音，但证明内容创作者对“自然亮度与颜色真实”的需求有平台侧依据。来源: https://seller-th.tiktok.com/university/essay?knowledge_id=135831639803665&lang=en

3. TikTok Shop 夹式自拍灯商品页反复用“poor light causes blurry photos”“3 color modes / 5 brightness levels”教育用户。这说明硬件侧也在解决同一个问题：暗光导致照片糊、过暗、过曝。来源: https://shop.tiktok.com/us/pdp/clip-on-ring-light-60-led-rechargeable-selfie-light-3-modes-5-brightness-levels/1731455528154796042

### 3.4 替代品信号

1. Godox LR30Bi 这类低价夹式补光灯约 $25，强调低光自拍视频、可夹手机、前后摄像头都能用、亮度和色温可调。它证明用户愿意为“随身自拍视频补光”买硬件，但软件可以赢在无需携带、即时打开。来源: https://www.digitalcameraworld.com/cameras/camera-lights/godox-litemons-lr30bi-review

2. Simple Flashlight 官网和评论强调无广告、颜色、SOS、低电量仍可用。这类产品已经把工具性做得很完整，Soft Light 若继续卷工具箱会变成弱势跟随。来源: https://simplemobiletools.com/simpleflashlight/

## 4. 候选机会评分表

评分规则: 需求 25%，趋势 15%，未满足 20%，变现 15%，可行性 15%，竞争反向 10%。竞争分越高表示竞争越激烈，最终得分已做反向处理。

| 排名 | 候选机会 | 得分 | 关键理由 | 主要反证 |
| --- | ---: | ---: | --- | --- |
| 1 | 低光自拍/短视频创作补光模式 | 84.0 | App/短视频/硬件三类证据同时成立；传播钩子强；当前产品能力可复用 | GlowCam 已经验证方向，不能做普通复制 |
| 2 | 一键红光 + 超低亮睡前模式 | 73.0 | Reddit 需求密集，痛点真实 | 系统设置、Twilight、Extra Dim 已占位；科学表述需谨慎 |
| 3 | 婴儿/夜间护理无打扰灯 | 72.0 | 父母半夜场景强、反智能负担明确 | 变现弱，市场规模和传播性不如自拍 |
| 4 | 摄影辅助背光/小物检查 | 60.0 | 白屏评论中有自然用例 | 小众、增长钩子弱 |
| 5 | 无广告安全白屏工具强化 | 56.0 | 用户强烈讨厌广告 | 太容易复制，只能作为底层体验标准 |
| 6 | 放松音乐 + 渐变夜灯 | 54.0 | 竞品常见，容易包装 | 同质化、容易偏离 Soft Light 核心 |

## 5. 最优功能方案

### 5.1 功能名

**Creator Glow Studio**

中文内部名：**创作者柔光棚**。

### 5.2 用户与场景

- 用户: 13-35 岁美国用户，自拍、夜间出门、派对、宿舍、浴室镜前、车内、卧室、TikTok/Instagram/Reels/Shorts 内容创作者。
- 高频场景:
  - 暗光自拍脸发黑、照片糊。
  - 夜间镜前拍穿搭/妆容，手机闪光太硬。
  - 视频通话或直播前需要脸部自然提亮。
  - 没有 ring light，不想买或没带硬件。

### 5.3 核心差异化

不要做“又一个 GlowCam”。GlowCam 已经做了前置闪光和颜色自定义。Soft Light 要做的是：

**从“给你一个亮屏幕”升级为“告诉你此刻该用什么光、亮到哪里、有没有过曝”。**

MVP 差异化能力：

1. **肤色/场景灯光配方**
   - 不是普通颜色列表，而是按结果命名：`Natural Glow`、`Warm Party`、`Mirror Fit`、`Makeup True Tone`、`Soft Pink`、`Low-Light Video`。
   - 每个配方固定色温、亮度范围和一句用途，避免用户在 HSV 色盘里乱调。

2. **自拍预览环形柔光**
   - 中央保留前置摄像头预览，四周显示可调柔光边框。
   - 用户可以边看脸边调光，而不是先调灯再切相机。
   - 不要求第一版拍照成片达到专业相机 App 水平，MVP 可先支持预览 + 系统截图/保存，第二版再接正式拍照。

3. **曝光/刺眼提示**
   - 用本地前置摄像头画面粗略判断脸部区域亮度：太暗、合适、过曝三档。
   - 文案不做医疗或美容夸大，只提示“Too dim / Balanced / Too bright”。

4. **无强制订阅的基础可用**
   - App Store 负面评论已说明用户反感“看起来免费但必须付费”。MVP 必须免费可完成基本补光。
   - Pro 只卖高级配方、无限自定义、去广告或导出水印/高级拍照能力，不锁死核心光源。

### 5.4 不做项

- 不做 AI 换脸、美颜、磨皮、滤镜社交网络。
- 不做复杂视频剪辑。
- 不做医疗化护眼/助眠承诺。
- 不把广告放进灯光区、预览区或启动 10 秒内。
- 不做强制登录、云同步、账号体系。

## 6. 成功机会分析

### 6.1 成功概率判断

综合机会评分：**8.4 / 10**。

判断拆解：

- 需求强度: 高。暗光自拍/视频糊是普遍问题，App、TikTok、硬件都在解决它。
- 差异化: 中高。单纯屏幕补光不稀缺，但“配方 + 实时预览 + 曝光提示 + 柔光审美”仍有切入空间。
- 可实现性: 高。现有 Soft Light 已有颜色、亮度、预设、自定义和状态持久化；新增主要是相机预览、配方层、简单亮度分析。
- 传播性: 高。before/after、肤色灯光配方、暗光照片救援天然适合短视频素材。
- 变现: 中高。订阅不能强推，适合 freemium + 一次性 Pro + 高级配方包。
- 风险: 中。需要避免做成低质相机 App；MVP 必须把“补光结果稳定”放在第一优先级。

### 6.2 为什么不是红光睡前模式

红光/超低亮是好功能，但不是本轮最优价值点：

- Reddit 证据支持它有痛点，但同时显示用户会绕过、忘记开启或直接用系统设置。
- TIME 对相关研究的报道也提醒蓝光/睡眠关系并非对成年人一刀切，医疗化表达风险高。
- Soft Light 可以把红光做成一个 `Wind Down` 配方，但不应该把它包装成核心突破。

### 6.3 为什么不是婴儿夜灯

婴儿夜间护理的痛点很强，但更适合做 Soft Light 的“低刺激模式包”：

- 父母明确反感 WiFi、登录、同步、固件更新，这和 Soft Light 离线极简方向一致。
- 但该场景传播弱、付费路径不如内容创作者清晰。
- 如果主打婴儿，商店合规和安全表述会更敏感，不能承诺睡眠改善。

### 6.4 关键成败点

- 成功点: 一打开就能看到脸被自然提亮，10 秒内保存一个适合自己的灯光配方。
- 失败点: 变成普通相机滤镜，或者强制订阅导致用户在第一屏流失。
- 护城河: 不在技术专利，而在“场景配方 + 低摩擦体验 + 短视频传播模板 + 无广告主体验”的组合。

## 7. PRD 草案

### 7.1 产品目标

在保留 Soft Light 原有柔光灯体验的基础上，新增 `Creator Glow Studio`，让用户在低光环境下快速获得自然、可控、可复用的自拍/短视频补光。

### 7.2 用户故事

- 作为晚上出门或在房间自拍的用户，我想边看前置预览边调光，避免拍出来脸黑或过曝。
- 作为短视频用户，我想直接选择适合 TikTok/Instagram 的灯光配方，而不是理解色温参数。
- 作为不想买 ring light 的用户，我想用手机屏幕临时完成可接受的补光。
- 作为免费用户，我希望基础补光不被强制付费拦截。

### 7.3 MVP 功能范围

1. 新增入口
   - 首页底部控制区新增一个 `Creator` 或相机图标入口。
   - 不改变默认打开即柔光的主路径。

2. Creator Glow Studio 页面/弹层
   - 中央前置摄像头预览。
   - 四周环形/边框柔光区域。
   - 下方配方横滑列表。
   - 亮度滑杆或上下手势保留。
   - 一键返回灯光主页面。

3. 灯光配方
   - MVP 6 个配方：`Natural Glow`、`Warm Party`、`Soft Pink`、`Makeup True Tone`、`Mirror Fit`、`Low-Light Video`。
   - 每个配方包含：颜色值、默认亮度、适用场景、是否 Pro。
   - MVP 全部免费，后续再测试高级配方包。

4. 曝光提示
   - 使用本地画面平均亮度做三档提示：Too dim / Balanced / Too bright。
   - 不做人脸识别存储，不上传，不保存生物特征。
   - 如果相机权限被拒绝，则展示“Companion Light”纯灯光模式。

5. Companion Light 模式
   - 允许用户把 Soft Light 当外置补光灯，用另一台手机或后置摄像头拍摄。
   - 提供全屏配方光 + 极简亮度控制。

### 7.4 验收标准

- 首次点击 Creator 入口后，用户能在 2 秒内看到前置预览或权限引导。
- 选择任一配方后，柔光边框颜色和亮度立即生效。
- 在暗光环境下，曝光提示能从 Too dim 随亮度调节变化到 Balanced。
- 拒绝相机权限后，用户仍能使用 Companion Light，不出现死路。
- 不新增登录、网络、广告 SDK 或订阅拦截。
- 原有首页 12 预设、色盘、定时、亮度手势不回退。

### 7.5 关键指标

- Creator 入口点击率。
- Creator 模式 10 秒留存率。
- 配方切换次数。
- Balanced 状态达成率。
- 自定义保存率。
- 次日留存。
- Pro/配方包点击率（后续版本）。

## 8. Flutter 迭代开发计划

### 8.1 阶段 1: 数据与状态扩展

- 新增 `LightRecipe` 模型，字段包括 `id`、`nameKey`、`color`、`brightness`、`scenarioKey`、`isPro`。
- 在 `LightController` 或独立 `CreatorGlowController` 中管理当前配方、亮度、模式类型。
- 本地保存最近一次 Creator 配方和亮度。
- 增加配方列表单元测试。

### 8.2 阶段 2: Creator UI MVP

- 新增 Creator 入口，不改变默认首页结构。
- 实现 Creator 页面或全屏弹层：相机预览、柔光边框、配方横滑、亮度控制、返回按钮。
- UI 保持 Cupertino 深色玻璃质感，不做教程页。
- 小屏上优先保证预览和配方条不重叠。

### 8.3 阶段 3: 相机与权限

- 引入 Flutter camera 能力前先评估包体、Android/iOS 权限和模拟器支持。
- Android 增加 CAMERA 权限说明，iOS 增加 NSCameraUsageDescription。
- 权限拒绝时进入 Companion Light 模式。
- 不上传、不联网、不保存人脸数据。

### 8.4 阶段 4: 曝光提示

- MVP 使用摄像头预览帧或截图的平均亮度做本地三档判断。
- 阈值先用工程常量，后续通过真机样本调校。
- 文案只提示画面亮度，不承诺美颜、护眼或睡眠效果。

### 8.5 阶段 5: 测试与验收

- 单元测试：配方序列化、选择逻辑、亮度 clamp、权限状态 fallback。
- Widget 测试：入口可见、配方切换、权限拒绝展示 Companion Light。
- 手动验收：暗房自拍、镜前自拍、视频预览、拒绝权限、前后台恢复。
- 构建验收：`flutter test`、Android debug APK、模拟器安装启动。

## 9. 风险与反证

| 风险 | 影响 | 处理 |
| --- | --- | --- |
| GlowCam 已有强传播 | 容易被认为抄袭 | 不做“普通补光相机”，主打配方、曝光提示、无强制订阅 |
| 相机质量不佳 | 用户会觉得照片糊 | MVP 可先强调预览/补光和 Companion Light，拍照保存做第二阶段 |
| 订阅反感 | 早期流失 | 基础能力免费，Pro 只卖高级配方和去广告 |
| 权限增加 | 与当前无权限体验冲突 | 明确把 Creator 作为可选入口；拒绝权限仍可用 |
| 医疗/护眼表述风险 | 商店审核风险 | 不宣称治疗、助眠、护眼，只说低刺激/柔光体验 |

## 10. 建议的下一步

1. 先做 `Creator Glow Studio` 的低保真交互稿：一个入口、一个预览页、6 个配方。
2. 用现有 Flutter 项目实现最小可用版本，但拍照保存可以后置。
3. 做 5 个短视频素材脚本用于验证传播：暗光糊照、宿舍镜前、派对自拍、妆容真实色、没带 ring light。
4. 上线前商店文案聚焦 `selfie light`、`low light photo`、`soft glow`、`screen light`，不要主打医疗护眼。

## 11. 来源清单

- Google Play: White Screen. https://play.google.com/store/apps/details?hl=en-US&id=com.hungrydroid.whitescreen
- Google Play: White Screen Flashlight. https://play.google.com/store/apps/details?id=cz.nowi.whitescreen
- Google Play: GlowCam: Selfies in the Dark. https://play.google.com/store/apps/details?hl=en&id=com.selfie.light.glowcam
- App Store: GlowCam Light - SelfieCam. https://apps.apple.com/us/app/glowcam-light-selfiecam/id6740575809
- App Store Reviews: GlowCam AI Photo Editor. https://apps.apple.com/us/app/glowcam-ai-photo-editor/id6739193579?platform=iphone&see-all=reviews
- Playkit: GlowCam TikTok strategy overview. https://playkit.beehiiv.com/p/glowcam-selfie-lighting-app
- TikTok Shop: clip-on ring light listing. https://shop.tiktok.com/us/pdp/clip-on-ring-light-60-led-rechargeable-selfie-light-3-modes-5-brightness-levels/1731455528154796042
- TikTok Seller University: livestream audiovisual quality. https://seller-th.tiktok.com/university/essay?knowledge_id=135831639803665&lang=en
- Reddit r/sleep: red light / ultra-dim app discussion. https://www.reddit.com/r/sleep/comments/1s1s4k5/night_shift_wasnt_enough_so_i_built_a_true_red/
- Reddit r/ADHD: red screen at night discussion. https://www.reddit.com/r/ADHD/comments/1mepflv/turn_your_phone_screen_red_at_night_trust_me/
- Reddit r/BabyBumps: smart baby gear 3am complaint. https://www.reddit.com/r/BabyBumps/comments/1q6ax0a/stop_making_baby_gear_smart_if_it_cant_work_at_3am/
- Reddit r/Oppo: automatic selfie flash complaint. https://www.reddit.com/r/Oppo/comments/1q2sww2/two_fundamental_flaws_or_bug_in_the_oppo_camera/
- Digital Camera World: Godox LR30Bi review. https://www.digitalcameraworld.com/cameras/camera-lights/godox-litemons-lr30bi-review
- Simple Flashlight official site. https://simplemobiletools.com/simpleflashlight/
- TIME: screen use, blue light and sleep evidence nuance. https://time.com/7335087/doom-scroll-phone-night-melatonin/
