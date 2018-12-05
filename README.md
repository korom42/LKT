# LKT

Legendary Kernel Tweaks

High performance & power saving tweaks for all devices (THAT ACTUALLY WORK)

## Getting Started
### Why LKT ?
LKT is a cumilation of different strategies that target certain kernel settigns. What makes this special and stand out from the crowd is being universal and device specific at the same time. And it's also BS free. Using very simple functions LKT detects the SoC your device have and then it applies the correspending tweaks. This would not be possible without the help of Project WIPE contributors who provided us with interactive governor configs for 24 different SoC including (Snapdragon, Helio, MediaTek & Intel Atom chipsets) covering hundreds of devices.

### Features
LKT aims to achieve the **balance** between **power consumption** and **performance**.
Compared to tuning the parameters manually, LKT uses Project WIPE excellent open source parameters that can adapt to multiple styles of workload sequences and produce a suitable combination of parameters for almost all mainstream SOCs.
This idea is similar to EAS, which takes into account both performance and power consumption costs through power consumption models and workload sequence, but obviously, EAS has a much lower response time and replaces tuning with decision logic. In addition, it also includes other parameter tuning, such as **HMP parameters, Virtual Memory, GPU, I/O scheduler, TCP and Doze rules**, to unify the rest of the parameters for a more consistent experience. Now it also includes EAS parameters for devices with "sched" or "schedutil" governors. 

### Prerequisites

What you will need 

```
• An android device
• Magisk 14+
• Busybox
```

### Compability

Every device with the following chipsets
```
Snapdragon 625-626
Snapdragon 636
Snapdragon 652-650
Snapdragon 660
Snapdragon 801-800-805
Snapdragon 810-808
Snapdragon 820-821
Snapdragon 835
Exynos 7420 (Samsung)
Exynos 8890 (Samsung)
Exynos 8895 (Samsung)
Helio x10 (MEDIATEK)
Helio x20-x25 (MEDIATEK)
Kirin 950-955 (HUAWEI)
Kirin 960 (HUAWEI)
Kirin 970 (HUAWEI)
Google Pixel & EAS phones
```
Please note that even if your device isn't listed some parameters will stil apply

### Installing

After downloading the zip file to your phone

```
• Flash in TWRP or Magisk manager
• Follow the given instructions
• Reboot
```

### How to make sure that it is working ?
Using a file manager check the logs by navigating to
```
/data/LKT.prop
```
You may screenshot & upload your logs to share them in case of having troubles

## Disclaimer
LKT is a collection of advanced tweaks that act on kernel level. If you don't know how it works, then please try this at your own risk. I won't be responsible for any damage or loss. Never forget to make backups.

## Authors

**Omar Koulache** - [korom42](https://github.com/korom42)

## Credits

### • [Project WIPE contributors](https://github.com/yc9559/cpufreq-interactive-opt/) 
```
 @yc9559 @Fdss45 @yy688go (好像不见了) @Jouiz @lmentor
 @小方叔叔 @星辰紫光 @ℳ๓叶落情殇 @屁屁痒 @发热不卡算我输 @予北 
 @選擇遺忘 @想飞的小伙 @白而出清 @AshLight @微风阵阵 @半阳半
 @AhZHI @悲欢余生有人听 @YaomiHwang @花生味 @胡同口卖菜的
 @gce8980 @vesakam @q1006237211 @Runds @lpc3123191239 
 @萝莉控の胜利 @iMeaCore @Dfift半島鐵盒 @wenjiahong @星空未来
 @水瓶 @瓜瓜皮 @默认用户名8 @影灬无神 @橘猫520 @此用户名已存在
 @ピロちゃん @Jaceﮥ @黑白颠倒的年华0 @九日不能贱 @fineable
 @哑剧 @zokkkk @永恒的丶齿轮 @L风云 @Immature_H @揪你鸡儿
 @xujiyuan723 @Ace蒙奇 @ちぃ @木子茶i同学 @HEX_Stan @微风阵阵
 @_暗香浮动月黄昏 @子喜 @ft1858336 @xxxxuanran @Scorpiring
 @猫见 @僞裝灬 @请叫我芦柑 @吃瓜子的小白 @HELISIGN @鹰雏
 @贫家boy有何贵干 @Yoooooo
```
### • [AKT contributors](https://github.com/mostafawael/OP5-AKT) 
```
@Alcolawl @soniCron @Asiier @Freak07 @Mostafa Wael 
@Senthil360 @TotallyAnxious @RenderBroken @adanteon  
@Kyuubi10 @ivicask @RogerF81 @joshuous @boyd95 
@ZeroKool76 @ZeroInfinity
```
### • Special Thanks
@ahrion @Zackptg5 @topjohnwu
[Unity Installer](https://forum.xda-developers.com/android/software/module-audio-modification-library-t3579612) 
[Vol Key Input Code](https://forum.xda-developers.com/android/software/guide-volume-key-selection-flashable-zip-t3773410)
[Magisk](https://github.com/topjohnwu/Magisk)

See also the list of [contributors](https://github.com/korom42/LKT/contributors) who participated in this project.

## Support
[SUPPORT THE DEVELOPMENT](https://forum.xda-developers.com/apps/magisk/xz-lxt-1-0-insane-battery-life-12h-sot-t3700688)

* [![Github](https://img.shields.io/badge/Github-Source-black.svg)](https://github.com/korom42/LKT)
* [![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
* [![HitCount](http://hits.dwyl.io/Korom42/LKT.svg)](http://hits.dwyl.io/Korom42/LKT)

---
<div align="center">
  <h2>This is the best so so far !</h2>
</div>

<p align="center"><sub>A project by <a href="https://forum.xda-developers.com/member.php?u=5033594" target="_blank">korom42</a> with ❤<p>

<p align="center"><a href="https://saythanks.io/to/korom42" target="_blank"><img src="https://img.shields.io/badge/Say%20Thanks-!-1EAEDB.svg?longCache=true&style=flat-square"></a><p>
