<h1 align="center">LKT - Magisk :checkered_flag:</h1>

<div align="center">
  <strong>legendary.kernel.tweaks</strong>
</div>
<div align="center">
LKT can identify your <code>hardware</code> and tweak your kernel for maximum power efficiency without deteriorating performance
</div>
<br />
<p align="center">
 <a href="https://forum.xda-developers.com/apps/magisk/xz-lxt-1-0-insane-battery-life-12h-sot-t3700688"><img src="https://img.shields.io/badge/XDA-Thread-orange.svg"></a><br /><a href="https://t.me/LKT_XDA"><img src="https://img.shields.io/badge/Telegram-Channel-blue.svg"></a>
</p>
 
## Why LKT ?
LKT is a cumilation of different strategies that target certain kernel settigns.

What makes this special and stand out from the crowd is being universal and device specific at the same time. And it's also BS free.
Using simple functions LKT detects the hardware of your device then it applies the corresponding changes. This would not be possible without the help of Project WIPE contributors that provides interactive governor configs for all mainstream platforms including Snapdragon, Kirin, MediaTek etc. Covering hundreds of devices.

## Features
LKT aims to achieve the **balance** between **power consumption** and **performance**.
Compared to tuning the parameters manually, LKT adopts Project WIPE excellent open source parameters for almost all mainstream SOCs that are generated via machine learning (A.I) and can adapt to multiple styles of workload sequences. This idea is similar to EAS, which takes into account both performance and power consumption costs through power consumption models and workload sequence, but obviously, EAS has a much lower response time and replaces tuning with decision logic. In addition, it also includes other parameter tuning, such as **HMP parameters, Virtual Memory, GPU, I/O scheduler, TCP and Doze rules** to unify the rest of the kernel parameters for a more consistent experience.

## Requirements
What you will need 

```
• Android Gingerbread+
• Magisk
• Busybox
```

## Compability
```
Snapdragon 615-616
Snapdragon 625-626
Snapdragon 636
Snapdragon 652-650
Snapdragon 660
Snapdragon 801-800-805
Snapdragon 810-808
Snapdragon 820-821
Snapdragon 835
Snapdragon 845
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
Please note that even if your device isn't listed some parameters may stil apply

## Changelog
### v1.2.2 (08/12/2018)
- Added SD845 EAS parameters
- Added support to SD615/SD616
- Updated hardware detection method with a better one
- Added detailed battery health check
- Other minor bug fixes & improvements

### v1.2.1 (07/12/2018)
- Fixed a bug that makes governor parameters not stick after a while
- Fixed a bug where CPU is not recognized correctly (Improved SoC detecting)
- Other minor bug fixes & improvements

### v1.2 (05/12/2018)
- Added missing cpu boost for some SoCs on balanced profile
- Improved swap detection & disabling (again)
- Reviewed & removed some stuff
- Other minor bug fixes & improvements

### v1.1 (04/12/2018)
- Fixed a bug where chip name in upper case isn't recognized
- Swap partitions detecting improvements
- Some small but important script code fixes
 Thanks to whalesplaho @XDA for testing and discovering this

### v1.0 (04/12/2018)
- First release

## How to make sure that it is working ?
Using a root file manager check the logs by navigating to `/data/LKT.prop`
You may screenshot & upload your logs to share them in case of having troubles

## Disclaimer
LKT is an advanced tweaks collection that act on `kernel` level. If you don't know how it works then use it at your own risk. I won't be responsible for any damage or loss. Always have backups.

## Authors

**Omar Koulache** - [korom42](https://github.com/korom42)

## Credits
- ### [Project WIPE contributors](https://github.com/yc9559/cpufreq-interactive-opt/tree/master/project/20180603-2) 
```
@yc9559 @cjybyjk
```
- ### [AKT contributors](https://github.com/mostafawael/OP5-AKT) 
```
@Alcolawl @soniCron @Asiier @Freak07 @Mostafa Wael 
@Senthil360 @TotallyAnxious @RenderBroken @adanteon  
@Kyuubi10 @ivicask @RogerF81 @joshuous @boyd95 
@ZeroKool76 @ZeroInfinity
```
- ### [Unity template](https://forum.xda-developers.com/android/software/module-audio-modification-library-t3579612) & [Keycheck Method](https://forum.xda-developers.com/android/software/guide-volume-key-selection-flashable-zip-t3773410) by @ahrion & @Zackptg5 

- ### [Magisk](https://github.com/topjohnwu/Magisk) by @topjohnwu

See also the list of [contributors](https://github.com/korom42/LKT/contributors) who participated in this project.
[XDA FORUMS](https://forum.xda-developers.com/apps/magisk/xz-lxt-1-0-insane-battery-life-12h-sot-t3700688)

[![HitCount](http://hits.dwyl.io/Korom42/LKT.svg)](http://hits.dwyl.io/Korom42/LKT)
