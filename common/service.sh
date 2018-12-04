#!/system/bin/sh
# ====================================================#
# Codename: LKT
# Author: korom42 @ XDA
# Device: Universal
# Version : 1.1
# Last Update: 04.DEC.2018
# ====================================================#
# THE BEST BATTERY MOD YOU CAN EVER USE
# JUST FLASH AND FORGET
# ====================================================#
# ##### Credits
#
# ** AKT contributors **
# @Alcolawl @soniCron @Asiier @Freak07 @Mostafa Wael 
# @Senthil360 @TotallyAnxious @RenderBroken @adanteon  
# @Kyuubi10 @ivicask @RogerF81 @joshuous @boyd95 
# @ZeroKool76 @ZeroInfinity
#
# ** Project WIPE contributors **
# @Fdss45 @yy688go (好像不见了) @Jouiz @lpc3123191239
# @小方叔叔 @星辰紫光 @ℳ๓叶落情殇 @屁屁痒 @发热不卡算我输# @予北
# @選擇遺忘 @想飞的小伙 @白而出清 @AshLight @微风阵阵 @半阳半
# @AhZHI @悲欢余生有人听 @YaomiHwang @花生味 @胡同口卖菜的
# @gce8980 @vesakam @q1006237211 @Runds @lmentor
# @萝莉控の胜利 @iMeaCore @Dfift半島鐵盒 @wenjiahong @星空未来
# @水瓶 @瓜瓜皮 @默认用户名8 @影灬无神 @橘猫520 @此用户名已存在
# @ピロちゃん @Jaceﮥ @黑白颠倒的年华0 @九日不能贱 @fineable
# @哑剧 @zokkkk @永恒的丶齿轮 @L风云 @Immature_H @揪你鸡儿
# @xujiyuan723 @Ace蒙奇 @ちぃ @木子茶i同学 @HEX_Stan
# @_暗香浮动月黄昏 @子喜 @ft1858336 @xxxxuanran @Scorpiring
# @猫见 @僞裝灬 @请叫我芦柑 @吃瓜子的小白 @HELISIGN @鹰雏
# @贫家boy有何贵干 @Yoooooo
#
# Give proper credits when using this in your work
# ====================================================#
# I spend a lot of time in making and testing these 
# tweaks so feel free to donate to me and anyone who
# contributed to this work
# Contact Email = korom42@gmail.com
# Paypal Email = koulache@hotmail.de
# ====================================================#

# helper functions to allow Android init like script
function write() {
#if [ -e $1 ]; then
    echo -n $2 > $1
#fi
}

function copy() {
    cat $1 > $2
}

function round() {
  printf "%.${2}f" "${1}"
}

function trim() {
    local var="$*"
    # remove leading whitespace characters
    var="${var#"${var%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   
    echo -n "$var"
}

function set_value() {
	if [ -f $2 ]; then
		# chown 0.0 $2
		chmod 0644 $2
		echo $1 > $2
		chmod 0444 $2
	fi
}

# $1:display-name $2:file path
function print_value() {
	if [ -f $2 ]; then
		echo $1
		cat $2
	fi
}

# $1:cpu0 $2:timer_rate $3:value
function set_param() {
	echo $3 > /sys/devices/system/cpu/$1/cpufreq/interactive/$2
}

# $1:cpu0 $2:timer_rate
function print_param() {
	echo "$1: $2"
	cat /sys/devices/system/cpu/$1/cpufreq/interactive/$2
}

# $1:io-scheduler $2:block-path
function set_io() {
	if [ -f $2/queue/scheduler ]; then
		if [ `grep -c $1 $2/queue/scheduler` = 1 ]; then
			echo $1 > $2/queue/scheduler
			echo 128 > $2/queue/read_ahead_kb
			set_value 0 $2/queue/iostats
			set_value 128 $2/queue/nr_requests
			set_value 0 $2/queue/iosched/slice_idle
			set_value 1 $2/queue/rq_affinity
			set_value 1 $2/queue/nomerges
			set_value 0 $2/queue/add_random
			set_value 0 $2/bdi/min_ratio
			set_value 100 $2/bdi/max_ratio
  		fi
	fi
}

    # Sleep at boot
    # Do not decrease
    # Better late than never

    sleep 40

    #MOD Variable
    V="1.0"
    PROFILE=<PROFILE_MODE>
    LOG=/data/LKT.prop
    sDATE=`date +%Y.%m.%d-%H.%M`
    sbusybox=`busybox | awk 'NR==1{print $2}'` 
   
    # RAM variables
	TOTAL_RAM=`cat /proc/meminfo | grep MemTotal | awk '{print $2}'`; 
    memg=$(awk -v x=$TOTAL_RAM 'BEGIN{print x/1048576}')
    ROUND_memg=$(round ${memg} 0) 
    
	# CPU variables
    arch_type=`uname -m`
    gov=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors)
    govn=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
    bcl_soc_hotplug_mask=`cat /sys/devices/soc/soc:qcom,bcl/hotplug_soc_mask`
    bcl_hotplug_mask=`cat /sys/devices/soc/soc:qcom,bcl/hotplug_mask`
	
	# Device infos
    VENDOR=`getprop ro.product.brand`
    ROM=`getprop ro.build.display.id`
    KERNEL="$(uname -r)"
    APP=`getprop ro.product.model`
    SOC=`getprop ro.product.board`
    cores=`grep -c ^processor /proc/cpuinfo`
    coresmax=$(cat /sys/devices/system/cpu/kernel_max)

    quad_core=4
    hexa_core=6
    octa_core=8
    deca_core=10
    bcores=4

    if [ $cores -eq $quad_core ];then
    bcores=2
    elif [ $cores -eq $hexa_core ];then
    bcores=4
    elif [ $cores -eq $octa_core ];then
    bcores=4
    elif [ $cores -eq $deca_core ];then
    bcores=4
    else
    bcores=4
    fi

    if [ -e /sys/devices/system/cpu/cpufreq/policy0/scaling_available_governors ]; then
    SILVER=/sys/devices/system/cpu/cpufreq/policy0/scaling_available_governors;
    fi
    if [ -e /sys/devices/system/cpu/cpufreq/policy0 ]; then
    SVD=/sys/devices/system/cpu/cpufreq/policy0
    fi
	
    if [ -e /sys/devices/system/cpu/cpufreq/policy$bcores/scaling_available_governors ]; then 
    GOLD=/sys/devices/system/cpu/cpufreq/policy$bcores/scaling_available_governors;
	elif [ -e /sys/devices/system/cpu/cpufreq/policy$bcores/scaling_available_governors ]; then 
    GOLD=/sys/devices/system/cpu/cpufreq/policy$bcores/scaling_available_governors;  
    fi
	 
    if [ -e /sys/devices/system/cpu/cpufreq/policy$bcores ]; then 
    GLD=/sys/devices/system/cpu/cpufreq/policy$bcores
    elif [ -e /sys/devices/system/cpu/cpufreq/policy$bcores ]; then 
    GLD=/sys/devices/system/cpu/cpufreq/policy$bcores
    fi

    function logdata() {
        echo $1 |  tee -a $LOG;
    }

    if [ -e $LOG ]; then
     rm $LOG;
    fi;


    if [ $PROFILE -eq 0 ];then
	PROFILE_M="Battery"
	elif [ $PROFILE -eq 1 ];then
	PROFILE_M="Balanced"
	else
	PROFILE_M="Balanced"
	fi

logdata "###### LKT™ $V" 
logdata "###### Profile : $PROFILE_M" 
logdata "" 
logdata "#  START : $sDATE" 
logdata "#  ==============================" 
logdata "#  Vendor : $VENDOR" 
logdata "#  Device : $APP" 
logdata "#  CPU : $SOC ($cores x cores)" 
logdata "#  RAM : $ROUND_memg GB" 
logdata "#  ==============================" 
logdata "#  ROM : $ROM" 
logdata "#  Android : $(getprop ro.build.version.release)" 
logdata "#  Kernel : $KERNEL" 
logdata "#  BusyBox  : $sbusybox" 
logdata "# ==============================" 
logdata "" 

function enable_bcl() {

if [ "$SOC" != "${SOC/msm/}" ] || [ "$SOC" != "${SOC/MSM/}" ] ; then
    write /sys/module/msm_thermal/core_control/enabled "1"
    write /sys/devices/soc/soc:qcom,bcl/mode -n disable
    write /sys/devices/soc/soc:qcom,bcl/hotplug_mask $bcl_hotplug_mask
    write /sys/devices/soc/soc:qcom,bcl/hotplug_soc_mask $bcl_soc_hotplug_mask
    write /sys/devices/soc/soc:qcom,bcl/mode -n enable

else
	set_value 1 /sys/power/cpuhotplug/enabled
	set_value 1 /sys/devices/system/cpu/cpuhotplug/enabled
fi

}

function disable_swap() {
	swapp=`blkid | grep swap | awk '{print $1}'`; 
	if [ -f /system/bin/swapoff ] ; then
    swff="/system/bin/swapoff"
	else
	swff="swapoff"
	fi
	
	swff $swapp > /dev/null 2>&1;

	for i in /sys/block/zram*; do
	set_value "1" $i/reset;
	set_value "0" $i/disksize
	done

	for j in /sys/block/vnswap*; do
	set_value "1" $j/reset;
	set_value "0" $j/disksize
	done

	setprop vnswap.enabled false
	setprop ro.config.zram false
	setprop ro.config.zram.support false
	setprop zram.disksize 0
	set_value 0 /proc/sys/vm/swappiness
	sysctl vm.swappiness=0
}

function disable_lmk() {
if [ -e "/sys/module/lowmemorykiller/parameters/enable_adaptive_lmk" ]; then
 set_value 0 /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
 set_value 0 /sys/module/process_reclaim/parameters/enable_process_reclaim
 setprop lmk.autocalc false
 else
 	logdata '# *WARNING* Adaptive LMK is not present on your Kernel' 
fi;
}

function RAM_tuning() { 

    SWAP_ENABLE_THRESHOLD=1572864

    # Enable swap only for 1.5 GB targets
    if [ "$TOTAL_RAM" -le "$SWAP_ENABLE_THRESHOLD" ]; then
        # Static swiftness
        echo 1 > /proc/sys/vm/swap_ratio_enable
        echo 70 > /proc/sys/vm/swap_ratio

        # Swap disk - 200MB size
        if [ ! -f /data/system/swap/swapfile ]; then
            dd if=/dev/zero of=/data/system/swap/swapfile bs=1m count=200
        fi
        mkswap /data/system/swap/swapfile
        swapon /data/system/swap/swapfile -p 32758
		
		if [ -e /sys/block/zram0/reset ]; then
        echo "1" > /sys/block/zram0/reset;
        echo 209715200 > /sys/block/zram0/disksize
        mkswap /dev/block/zram0 > /dev/null 2>&1;
        swapon /dev/block/zram0 > /dev/null 2>&1;
        fi;

  
        if [ -e /sys/block/zram1/reset ]; then
        echo "1" > /sys/block/zram1/reset;
        echo 209715200 > /sys/block/zram1/disksize
        mkswap /dev/block/zram1 > /dev/null 2>&1;
        swapon /dev/block/zram1 > /dev/null 2>&1;
        fi;
        setprop ro.config.zram true
        setprop ro.config.zram.support true
        setprop zram.disksize 209715200
 
   if [ -e /sys/block/zram0/comp_algorithm ]; then
    echo "lz4" > /sys/block/zram0/comp_algorithm
   fi;
    
   if [ -e /sys/block/zram0/max_comp_streams ]; then
    echo "4" > /sys/block/zram0/max_comp_streams
   fi;
   
   sysctl vm.swappiness=30

  if [ -e /sys/module/zswap/parameters/enabled]; then
   if [ -e /sys/module/zswap/parameters/enabled]; then
   echo "1" > /sys/module/zswap/parameters/enabled
   fi;
   if [ -e /sys/module/zswap/parameters/compressor ]; then
   echo "lz4" > /sys/module/zswap/parameters/compressor
   fi;
   if [ -e /sys/module/zswap/parameters/max_pool_percent ]; then
   echo "30" > /sys/module/zswap/parameters/max_pool_percent
   fi;
   if [ -e /sys/module/zswap/parameters/zpool ]; then
   echo "z3fold" > /sys/module/zswap/parameters/zpool
   fi;
  fi;
  
 fi

  # LMK Calculator
  # This is a Calculator for the Android Low Memory Killer 
  # It detects the Free RAM and set the LMK to right configuration
  # for more RAM but also better Multitasking 
  # Algorithms COPYRIGHT by PDesire and the THDR Alliance 
  # Code COPYRIGHT korom42


calculator=0
divisor=$(awk -v x=$TOTAL_RAM 'BEGIN{print x/256}')

var_one=$(awk -v x=$TOTAL_RAM -v y=2 'BEGIN{print sqrt(x)*sqrt(2)}')
var_two=$(awk -v x=$TOTAL_RAM -v p=3.14 'BEGIN{print x*sqrt(p)}')
var_three=$(awk -v x=$var_one -v y=$var_two -v z=$divisor 'BEGIN{print (x+y)/z}')
var_four=$(awk -v x=$var_three -v p=3.14 'BEGIN{print x/(sqrt(p)*2)}')
f_LMK=$(awk -v x=$var_four -v p=3.14 'BEGIN{print x/(p*2)}')
LMK=$(round ${f_LMK} 0)

 # Low Memory Killer Generator
 # Settings inspired by HTC stock firmware 
 # Tuned by korom42 for multi-tasking and saving CPU cycles

f_LMK1=$(awk -v x=$LMK 'BEGIN{print x*3*1024/4}') #Low Memory Killer 1
LMK1=$(round ${f_LMK1} 0)

f_LMK2=$(awk -v x=$LMK1 'BEGIN{print x*1.5}') #Low Memory Killer 2
LMK2=$(round ${f_LMK2} 0)

f_LMK3=$(awk -v x=$LMK1 'BEGIN{print x*1.8}') #Low Memory Killer 3
LMK3=$(round ${f_LMK3} 0)

f_LMK4=$(awk -v x=$LMK1 'BEGIN{print x*3.5}') #Low Memory Killer 4
LMK4=$(round ${f_LMK4} 0)

f_LMK5=$(awk -v x=$LMK1 'BEGIN{print x*4.5}') #Low Memory Killer 5
LMK5=$(round ${f_LMK5} 0)

f_LMK6=$(awk -v x=$LMK1 'BEGIN{print x*5.5}') #Low Memory Killer 6
LMK6=$(round ${f_LMK6} 0)

ADJ1=0
ADJ2=100
ADJ3=200
ADJ4=300
ADJ5=900
ADJ6=906

#minfree="$LMK1,$LMK2,$LMK3,$LMK4,$LMK5,$LMK6"
#ADJ="$ADJ1,$ADJ2,$ADJ3,$ADJ4,$ADJ5,$ADJ6"
#wLMK=$(awk -v x=$minfree' BEGIN { print x >> "/sys/module/lowmemorykiller/parameters/minfree" }')
#wADJ=$(awk -v x=$ADJ' BEGIN { print x >> "/sys/module/lowmemorykiller/parameters/adj" }')

if [ -e "/sys/module/lowmemorykiller/parameters/enable_adaptive_lmk" ]; then
	set_value 1 /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
else
	logdata "#  *WARNING* Adaptive LMK is not present on your Kernel" 
fi
 
if [ -e "/sys/module/lowmemorykiller/parameters/minfree" ]; then
   set_value "$LMK1,$LMK2,$LMK3,$LMK4,$LMK5,$LMK6" /sys/module/lowmemorykiller/parameters/minfree
   set_value "$ADJ1,$ADJ2,$ADJ3,$ADJ4,$ADJ5,$ADJ6" /sys/module/lowmemorykiller/parameters/adj
   setprop lmk.autocalc true
else
	logdata "#  *WARNING* LMK cannot currently be modified on your Kernel" 
fi

    if [ $TOTAL_RAM -lt 2097152 ]; then
	disable_swap

    setprop ro.config.low_ram true
    setprop ro.board_ram_size low
    
	#Enable B service adj transition for 2GB or less memory
    setprop ro.vendor.qti.sys.fw.bservice_enable true
    setprop ro.vendor.qti.sys.fw.bservice_limit 5
    setprop ro.vendor.qti.sys.fw.bservice_age 5000

    #Enable Delay Service Restart
    setprop ro.vendor.qti.am.reschedule_service true
      
	elif [ $TOTAL_RAM -lt 3145728 ]; then
    disable_swap
	#disable_lmk
	
    elif [ $TOTAL_RAM -lt 4194304 ]; then
    disable_swap
	#disable_lmk
    fi
 
    if [ $TOTAL_RAM -gt 4194304 ]; then
    disable_swap
	#disable_lmk
    fi

# =========
# Vitual Memory
# =========

chmod 0644 /proc/sys/*;
sysctl vm.drop_caches=1
sysctl vm.oom_dump_tasks=1
sysctl vm.oom_kill_allocating_task=0
sysctl vm.dirty_background_ratio=1
sysctl vm.dirty_ratio=5
sysctl vm.vfs_cache_pressure=30
sysctl vm.overcommit_memory=50
sysctl vm.overcommit_ratio=0
sysctl vm.laptop_mode=0
sysctl vm.block_dump=0
sysctl vm.dirty_writeback_centisecs=0
sysctl vm.dirty_expire_centisecs=0
sysctl dir-notify-enable=0
sysctl fs.lease-break-time=20
sysctl fs.leases-enable=1
sysctl vm.compact_memory=1
sysctl vm.compact_unevictable_allowed=1
sysctl vm.page-cluster=1
#sysctl vm.extfrag_threshold=500
#sysctl vm.watermark_scale_factor=10
#sysctl stat_interval=1200
sysctl vm.panic_on_oom=0

# =========
# Entropy 
# =========

# Anything more than 64/128 is stupid
# It won't increase your performance
# It will increase battery drain
# So leave it as it is

sysctl kernel.random.read_wakeup_threshold=64
sysctl kernel.random.write_wakeup_threshold=128

logdata "#  Virtual Memory Tweaks = Activated" 

sync;

}

function CPU_tuning() {

if [ "$SOC" != "${SOC/msm/}" ] || [ "$SOC" != "${SOC/MSM/}" ] ; then
logdata "#  Snapdragon SoC detected" 

    # disable thermal bcl hotplug to switch governor
    write /sys/module/msm_thermal/core_control/enabled "0"
    write /sys/module/msm_thermal/parameters/enabled "N"
	
 else
 	logdata "#  Non-Snapdragon SoC detected" 

 	# Linaro HMP, between 0 and 1024, maybe compare to the capacity of current cluster
	# PELT and period average smoothing sampling, so the parameter style differ from WALT by Qualcomm a lot.
	# https://lists.linaro.org/pipermail/linaro-dev/2012-November/014485.html
	# https://www.anandtech.com/show/9330/exynos-7420-deep-dive/6
	# set_value 60 /sys/kernel/hmp/load_avg_period_ms
	set_value 256 /sys/kernel/hmp/down_threshold
	set_value 640 /sys/kernel/hmp/up_threshold
	set_value 0 /sys/kernel/hmp/boost

	# Exynos hotplug
	set_value 0 /sys/power/cpuhotplug/enabled
	set_value 0 /sys/devices/system/cpu/cpuhotplug/enabled
	
fi


	if [ -e /sys/devices/soc/soc:qcom,bcl/mode ]; then
    chmod 644 /sys/devices/soc/soc:qcom,bcl/mode
    write /sys/devices/soc/soc:qcom,bcl/mode -n disable
    write /sys/devices/soc/soc:qcom,bcl/hotplug_mask 0
    write /sys/devices/soc/soc:qcom,bcl/hotplug_soc_mask 0
    write /sys/devices/soc/soc:qcom,bcl/mode -n enable
    fi
	
	# Perfd, nothing to worry about, if error the script will continue

	if [ -e /data/system/perfd ]; then
	stop perfd
	fi
	
	#if [ -e /data/system/perfd/default_values ]; then
	#rm /data/system/perfd/default_values
	#fi
	 
	sleep 0.1
	 
	# A simple loop to bring all cores online that we counted earlier
	 
	num=0
	
	while [ $num -lt $cores ]
	
	do
	
	set_value 1 /sys/devices/system/cpu/cpu$num/online
	
	#num=`expr $num + 1`
	num=$(( $num + 1 ))
	
	sleep 0.1
	
	done

    if [ -d "/dev/stune" ]; then
	write /dev/stune/top-app/schedtune.boost 1
	write /dev/stune/background/schedtune.boost 0
	write /dev/stune/foreground/schedtune.boost 0
	write /dev/stune/schedtune.prefer_idle 0
	write /proc/sys/kernel/sched_child_runs_first 0
	#write /proc/sys/kernel/sched_cfs_boost 0
	write /dev/stune/background/schedtune.prefer_idle 0
	write /dev/stune/foreground/schedtune.prefer_idle 0
	write /dev/stune/top-app/schedtune.prefer_idle 1
	
	if [ -e "/proc/sys/kernel/sched_autogroup_enabled" ]; then
		write /proc/sys/kernel/sched_autogroup_enabled 0
	fi
	
	if [ -e "/proc/sys/kernel/sched_is_big_little" ]; then
		write /proc/sys/kernel/sched_is_big_little 1
	fi
	
	if [ -e "/proc/sys/kernel/sched_boost" ]; then
		write /proc/sys/kernel/sched_boost 0
	fi
	fi
	
	if [ -e /sys/devices/system/cpu/cpu0/cpufreq ]; then
    		GOV_PATH_L=/sys/devices/system/cpu/cpu0/cpufreq
	fi
	if [ -e /sys/devices/system/cpu/cpu$bcores/cpufreq ]; then
    		GOV_PATH_B=/sys/devices/system/cpu/cpu$bcores/cpufreq
	fi
	
	string1=/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors;
	string2=/sys/devices/system/cpu/cpu$bcores/cpufreq/scaling_available_governors;

	if grep -w 'schedutil' $string1 && grep -w 'schedutil' $string2; then
		
	logdata "#  EAS Kernel Detected : Tuning 'schedutil'" 
    if [ -e $SVD ] && [ -e $GLD ]; then

	
	set_value "schedutil" $SVD/scaling_governor 
	set_value "schedutil" $GLD/scaling_governor
	


    if [ $PROFILE -eq 1 ];then
	
    if [ -e "/proc/sys/kernel/sched_use_walt_task_util" ]; then
		write /proc/sys/kernel/sched_use_walt_task_util 1
		write /proc/sys/kernel/sched_use_walt_cpu_util 1
		write /proc/sys/kernel/sched_walt_init_task_load_pct 10
		write /proc/sys/kernel/sched_walt_cpu_high_irqload 10000000
		write /proc/sys/kernel/sched_rt_runtime_us 980000
	fi

	write $SVD/schedutil/up_rate_limit_us 1000
	write $SVD/schedutil/down_rate_limit_us 8000
	write $SVD/schedutil/iowait_boost_enable 0

	write /sys/module/cpu_boost/parameters/dynamic_stune_boost 8
	write /proc/sys/kernel/sched_nr_migrate 64
	write /proc/sys/kernel/sched_cstate_aware 1
	write /proc/sys/kernel/sched_initial_task_util 0

	sleep 0.1
	
	write $GLD/schedutil/up_rate_limit_us 1000
	write $GLD/schedutil/down_rate_limit_us 8000
	write $GLD/schedutil/iowait_boost_enable 0

	if [ -e "/sys/module/cpu_boost" ]; then
	set_value 1 /sys/module/cpu_boost/parameters/input_boost_enabled
    if [ $coresmax -eq 1 ];then
    set_value "0:0 1:0" /sys/module/cpu_boost/parameters/input_boost_freq
    elif [ $coresmax -eq 3 ];then
    set_value "0:0 1:0 2:0 3:0" /sys/module/cpu_boost/parameters/input_boost_freq
    elif [ $coresmax -eq 5 ];then
    set_value "0:0 1:0 2:0 3:0 4:0 5:0" /sys/module/cpu_boost/parameters/input_boost_freq
    elif [ $coresmax -eq 7 ];then
    set_value "0:0 1:0 2:0 3:0 4:0 5:0 6:0 7:0" /sys/module/cpu_boost/parameters/input_boost_freq
    elif [ $coresmax -eq 9 ];then
    set_value "0:0 1:0 2:0 3:0 4:0 5:0 6:0 7:0 8:0 9:0" /sys/module/cpu_boost/parameters/input_boost_freq
    fi
	set_value 600 /sys/module/cpu_boost/parameters/input_boost_ms
	fi
	if [ -e "/sys/module/msm_performance/parameters/touchboost/sched_boost_on_input" ]; then
		write /sys/module/msm_performance/parameters/touchboost/sched_boost_on_input N
	fi
	else
    if [ -e "/proc/sys/kernel/sched_use_walt_task_util" ]; then
		write /proc/sys/kernel/sched_use_walt_task_util 0
		write /proc/sys/kernel/sched_use_walt_cpu_util 0
		write /proc/sys/kernel/sched_walt_init_task_load_pct 0
		write /proc/sys/kernel/sched_walt_cpu_high_irqload 0
		write /proc/sys/kernel/sched_rt_runtime_us 980000
	fi
	
	write $SVD/schedutil/up_rate_limit_us 2000
	write $SVD/schedutil/down_rate_limit_us 5000
	write $SVD/schedutil/iowait_boost_enable 0

	write /sys/module/cpu_boost/parameters/dynamic_stune_boost 6
	write /proc/sys/kernel/sched_nr_migrate 48
	write /proc/sys/kernel/sched_cstate_aware 1
	write /proc/sys/kernel/sched_initial_task_util 0

	sleep 0.1
	
	write $GLD/schedutil/up_rate_limit_us 2000
	write $GLD/schedutil/down_rate_limit_us 5000
	write $GLD/schedutil/iowait_boost_enable 0
	
	if [ -e "/sys/module/cpu_boost" ]; then
	set_value 1 /sys/module/cpu_boost/parameters/input_boost_enabled
    if [ $coresmax -eq 1 ];then
    set_value "0:0 1:0" /sys/module/cpu_boost/parameters/input_boost_freq
    elif [ $coresmax -eq 3 ];then
    set_value "0:0 1:0 2:0 3:0" /sys/module/cpu_boost/parameters/input_boost_freq
    elif [ $coresmax -eq 5 ];then
    set_value "0:0 1:0 2:0 3:0 4:0 5:0" /sys/module/cpu_boost/parameters/input_boost_freq
    elif [ $coresmax -eq 7 ];then
    set_value "0:0 1:0 2:0 3:0 4:0 5:0 6:0 7:0" /sys/module/cpu_boost/parameters/input_boost_freq
    elif [ $coresmax -eq 9 ];then
    set_value "0:0 1:0 2:0 3:0 4:0 5:0 6:0 7:0 8:0 9:0" /sys/module/cpu_boost/parameters/input_boost_freq
    fi
	set_value 500 /sys/module/cpu_boost/parameters/input_boost_ms
    fi
	
	if [ -e "/sys/module/msm_performance/parameters/touchboost/sched_boost_on_input" ]; then
		write /sys/module/msm_performance/parameters/touchboost/sched_boost_on_input N
	fi
    fi
    chmod 444 $SVD/schedutil/*
	chmod 444 $GLD/schedutil/*
	fi
	
	elif grep -w 'sched' $string1 && grep -w 'sched' $string2; then		
		
	logdata "#  EAS Kernel Detected : Tuning 'sched'" 

	set_value "sched" /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
	set_value "sched" /sys/devices/system/cpu/cpu$bcores/cpufreq/scaling_governor
	
    
	if [ -e /dev/stune/foreground/schedtune.boost ]; then
    if [ $PROFILE -eq 1 ];then

	write /dev/stune/foreground/schedtune.boost 8
	else
    write /dev/stune/foreground/schedtune.boost 6
	fi
	fi;
	
	else
	#if grep -w 'interactive' $string1; then
    if [ -e $string1 ] && [ -e $string2 ]; then
	
	logdata "#  HMP Kernel Detected : Tuning 'Interactive'" 

	set_value "interactive" /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
	set_value "interactive" /sys/devices/system/cpu/cpu$bcores/cpufreq/scaling_governor
	
    chown 0.0 /sys/devices/system/cpu/cpu0/cpufreq/interactive/*
	chown 0.0 /sys/devices/system/cpu/cpu$bcores/cpufreq/interactive/*
	chmod 0666 /sys/devices/system/cpu/cpu0/cpufreq/interactive/*
	chmod 0666 /sys/devices/system/cpu/cpu$bcores/cpufreq/interactive/*

	# shared interactive parameters
	set_param cpu0 timer_rate 20000
	set_param cpu$bcores timer_rate 20000
	set_param cpu0 timer_slack 180000
	set_param cpu$bcores timer_slack 180000
	set_param cpu0 boost 0
	set_param cpu$bcores boost 0
	set_param cpu0 boostpulse_duration 0
	set_param cpu$bcores boostpulse_duration 0
	set_param cpu0 use_sched_load 1
	set_param cpu$bcores use_sched_load 1
	set_param cpu0 ignore_hispeed_on_notif 0
	set_param cpu$bcores ignore_hispeed_on_notif 0
	set_value 0 /sys/devices/system/cpu/cpu0/cpufreq/interactive/enable_prediction
	set_value 0 /sys/devices/system/cpu/cpu$bcores/cpufreq/interactive/enable_prediction
	
	# Input Boost
	if [ -e "/sys/module/cpu_boost/parameters/input_boost_freq" ]; then
	if [ $coresmax -eq 1 ];then
	set_value "0:0 1:0" /sys/module/cpu_boost/parameters/input_boost_freq
	elif [ $coresmax -eq 3 ];then
	set_value "0:0 1:0 2:0 3:0" /sys/module/cpu_boost/parameters/input_boost_freq
	elif [ $coresmax -eq 5 ];then
	set_value "0:0 1:0 2:0 3:0 4:0 5:0" /sys/module/cpu_boost/parameters/input_boost_freq
	elif [ $coresmax -eq 7 ];then
	set_value "0:0 1:0 2:0 3:0 4:0 5:0 6:0 7:0" /sys/module/cpu_boost/parameters/input_boost_freq
	elif [ $coresmax -eq 9 ];then
	set_value "0:0 1:0 2:0 3:0 4:0 5:0 6:0 7:0 8:0 9:0" /sys/module/cpu_boost/parameters/input_boost_freq
	fi
	set_value 20 /sys/module/cpu_boost/parameters/input_boost_ms
	else
	logdata "#  *WARNING* Your Kernel does not support CPU BOOST  " 
	fi

	if [ -e "/sys/module/cpu_boost/parameters/boost_ms" ]; then
	set_value 0 /sys/module/cpu_boost/parameters/boost_ms
	fi

	#Disable TouchBoost
	if [ -e "/sys/module/msm_performance/parameters/touchboost" ]; then
	set_value 0 /sys/module/msm_performance/parameters/touchboost
	else
	logdata "#  *WARNING* Your Kernel does not support TOUCH BOOST  " 
	fi

    if [ $PROFILE -eq 1 ];then
    case ${SOC,,} in
    "msm8998" | "apq8098_latv") #sd835

	echo 2 > /sys/devices/system/cpu/cpu4/core_ctl/min_cpus
	echo 60 > /sys/devices/system/cpu/cpu4/core_ctl/busy_up_thres
	echo 30 > /sys/devices/system/cpu/cpu4/core_ctl/busy_down_thres
	echo 100 > /sys/devices/system/cpu/cpu4/core_ctl/offline_delay_ms
	echo 1 > /sys/devices/system/cpu/cpu4/core_ctl/is_big_cluster
	echo 4 > /sys/devices/system/cpu/cpu4/core_ctl/task_thres
	
	set_param cpu0 above_hispeed_delay "18000 1580000:98000"
	set_param cpu0 hispeed_freq 1180000
	set_param cpu0 go_hispeed_load 98
	set_param cpu0 target_loads "80 380000:30 480000:41 580000:29 680000:4 780000:60 1180000:88 1280000:70 1380000:78 1480000:97"
	set_param cpu0 min_sample_time 18000
	set_param cpu4 above_hispeed_delay "18000 1380000:78000 1480000:18000 1580000:98000 1880000:138000"
	set_param cpu4 hispeed_freq 1280000
	set_param cpu4 go_hispeed_load 98
	set_param cpu4 target_loads "80 380000:39 580000:58 780000:63 980000:81 1080000:92 1180000:77 1280000:98 1380000:86 1580000:98"
	set_param cpu4 min_sample_time 18000

	write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 300000
	write /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 300000
	
	for cpubw in /sys/class/devfreq/*qcom,cpubw* ; do
    write $cpubw/governor "bw_hwmon"
    write $cpubw/polling_interval 50
    write $cpubw/min_freq 1525
    write $cpubw/bw_hwmon/mbps_zones "3143 5859 11863 13763"
    write $cpubw/bw_hwmon/sample_ms 4
    write $cpubw/bw_hwmon/io_percent 34
    write $cpubw/bw_hwmon/hist_memory 20
    write $cpubw/bw_hwmon/hyst_length 10
    write $cpubw/bw_hwmon/low_power_ceil_mbps 0
    write $cpubw/bw_hwmon/low_power_io_percent 34
    write $cpubw/bw_hwmon/low_power_delay 20
    write $cpubw/bw_hwmon/guard_band_mbps 0
    write $cpubw/bw_hwmon/up_scale 250
    write $cpubw/bw_hwmon/idle_mbps 1600
	done
	for memlat in /sys/class/devfreq/*qcom,memlat-cpu* ; do
    write $memlat/governor "mem_latency"
    write $memlat/polling_interval 10
    write $memlat/mem_latency/ratio_ceil 400
	done

    write /sys/class/devfreq/soc:qcom,mincpubw/governor "cpufreq"
	write /sys/module/lpm_levels/system/pwr/cpu0/ret/idle_enabled N
	write /sys/module/lpm_levels/system/pwr/cpu1/ret/idle_enabled N
	write /sys/module/lpm_levels/system/pwr/cpu2/ret/idle_enabled N
	write /sys/module/lpm_levels/system/pwr/cpu3/ret/idle_enabled N
	write /sys/module/lpm_levels/system/perf/cpu4/ret/idle_enabled N
	write /sys/module/lpm_levels/system/perf/cpu5/ret/idle_enabled N
	write /sys/module/lpm_levels/system/perf/cpu6/ret/idle_enabled N
	write /sys/module/lpm_levels/system/perf/cpu7/ret/idle_enabled N
	write /sys/module/lpm_levels/system/pwr/pwr-l2-dynret/idle_enabled N
	write /sys/module/lpm_levels/system/pwr/pwr-l2-ret/idle_enabled N
	write /sys/module/lpm_levels/system/perf/perf-l2-dynret/idle_enabled N
	write /sys/module/lpm_levels/system/perf/perf-l2-ret/idle_enabled N
	write /sys/module/lpm_levels/parameters/sleep_disabled N

	echo 0-3 > /dev/cpuset/background/cpus
	echo 0-3 > /dev/cpuset/system-background/cpus
	echo 0 > /proc/sys/kernel/sched_boost
    ;;

    "msm8996") #sd820
        
	set_value 280000 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	set_value 280000 /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq

	set_value 25 /proc/sys/kernel/sched_downmigrate
	set_value 45 /proc/sys/kernel/sched_upmigrate
	set_value "0:1280000 1:1280000 2:0 3:0" /sys/module/cpu_boost/parameters/input_boost_freq
	set_param cpu0 above_hispeed_delay "58000 1280000:98000 1580000:58000"
	set_param cpu0 hispeed_freq 1180000
	set_param cpu0 go_hispeed_load 98
	set_param cpu0 target_loads "80 380000:9 580000:36 780000:62 880000:71 980000:87 1080000:75 1180000:98"
	set_param cpu0 min_sample_time 18000
	set_param cpu2 above_hispeed_delay "38000 1480000:98000 1880000:138000"
	set_param cpu2 hispeed_freq 1380000
	set_param cpu2 go_hispeed_load 98
	set_param cpu2 target_loads "80 380000:39 480000:35 680000:29 780000:63 880000:71 1180000:91 1380000:83 1480000:98"
	set_param cpu2 min_sample_time 18000

    ;;

    "msm8994" | "msm8992") #sd810/808
	
	set_value 380000 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	set_value 380000 /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
	set_value 2 /sys/devices/system/cpu/cpu4/core_ctl/min_cpus
	set_value 2 /sys/devices/system/cpu/cpu4/core_ctl/max_cpus
	set_value "0:1344000 4:1440000" /sys/module/msm_performance/parameters/cpu_max_freq
	set_value 1344000 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
	set_value 1440000 /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
	set_value "0:1180000 1:1180000 2:1180000 3:1180000 4:0 5:0 6:0 7:0" /sys/module/cpu_boost/parameters/input_boost_freq
	set_param cpu0 above_hispeed_delay "98000"
	set_param cpu0 hispeed_freq 1180000
	set_param cpu0 go_hispeed_load 97
	set_param cpu0 target_loads "80 580000:59 680000:54 780000:63 880000:85 1180000:98 1280000:94"
	set_param cpu0 min_sample_time 38000
	set_param cpu4 above_hispeed_delay "18000 1180000:98000"
	set_param cpu4 hispeed_freq 880000
	set_param cpu4 go_hispeed_load 98
	set_param cpu4 target_loads "80 580000:64 680000:58 780000:19 880000:97"
	set_param cpu4 min_sample_time 78000
	
    ;;

    "msm8974" | "APQ8084")  #sd800-801-805
	
	set_param cpu0 above_hispeed_delay "18000 1480000:78000 1780000:138000"
	set_param cpu0 hispeed_freq 1180000
	set_param cpu0 go_hispeed_load 99
	set_param cpu0 boostpulse_duration 18000
	set_param cpu0 target_loads "1 580000:60 680000:81 880000:42 980000:90 1480000:80 1680000:99"
	set_param cpu0 min_sample_time 18000

    ;;

    "sdm660") #sd660

	set_value "0:1480000 1:1480000 2:1480000 3:1480000 4:0 5:0 6:0 7:0" /sys/module/cpu_boost/parameters/input_boost_freq
	set_param cpu0 above_hispeed_delay "98000"
	set_param cpu0 hispeed_freq 1480000
	set_param cpu0 go_hispeed_load 98
	set_param cpu0 target_loads "80 880000:59 1080000:90 1380000:78 1480000:98"
	set_param cpu0 min_sample_time 38000
	set_param cpu4 above_hispeed_delay "18000 1680000:98000 1880000:138000"
	set_param cpu4 hispeed_freq 1080000
	set_param cpu4 go_hispeed_load 83
	set_param cpu4 target_loads "80 1380000:70 1680000:98"
	set_param cpu4 min_sample_time 18000
	
    ;;
    "msm8956" | "msm8976")  #sd652/650
	set_value 50 /sys/module/cpu_boost/parameters/input_boost_ms
	set_value "0:1380000 1:1380000 2:1380000 3:1380000 4:0 5:0 6:0 7:0" /sys/module/cpu_boost/parameters/input_boost_freq
	set_param cpu0 above_hispeed_delay "98000 1380000:58000"
	set_param cpu0 hispeed_freq 1180000
	set_param cpu0 go_hispeed_load 97
	set_param cpu0 target_loads "80 680000:68 780000:60 980000:97 1180000:63 1280000:97 1380000:84"
	set_param cpu0 min_sample_time 58000
	set_param cpu4 above_hispeed_delay "18000 1580000:98000"
	set_param cpu4 hispeed_freq 1280000
	set_param cpu4 go_hispeed_load 98
	set_param cpu4 target_loads "80 880000:47 980000:68 1280000:74 1380000:92 1580000:98"
	set_param cpu4 min_sample_time 18000

    ;;

    "sdm636" ) #sd636
	set_value "0:1480000 1:1480000 2:1480000 3:1480000 4:0 5:0 6:0 7:0" /sys/module/cpu_boost/parameters/input_boost_freq
	set_param cpu0 above_hispeed_delay "18000 1380000:78000 1480000:98000 1580000:78000"
	set_param cpu0 hispeed_freq 1080000
	set_param cpu0 go_hispeed_load 98
	set_param cpu0 target_loads "80 880000:62 1080000:94 1380000:75 1480000:96"
	set_param cpu0 min_sample_time 58000
	set_param cpu4 above_hispeed_delay "18000 1680000:98000"
	set_param cpu4 hispeed_freq 1080000
	set_param cpu4 go_hispeed_load 81
	set_param cpu4 target_loads "80 1380000:70 1680000:98"
	set_param cpu4 min_sample_time 18000
    
	;;

    "msm8953" )  #sd625/626
	set_value "0:1680000 1:1680000 2:1680000 3:1680000 4:0 5:0 6:0 7:0" /sys/module/cpu_boost/parameters/input_boost_freq
	set_param cpu0 above_hispeed_delay "98000 1880000:138000"
	set_param cpu0 hispeed_freq 1680000
	set_param cpu0 go_hispeed_load 97
	set_param cpu0 target_loads "80 980000:63 1380000:72 1680000:97"
	set_param cpu0 min_sample_time 18000
    ;;

	
	"universal8895")  #EXYNOS8895 (S8)
	set_param cpu0 above_hispeed_delay "38000 1380000:98000"
	set_param cpu0 hispeed_freq 1180000
	set_param cpu0 go_hispeed_load 98
	set_param cpu0 target_loads "80 780000:53 880000:70 980000:50 1180000:71 1380000:97 1680000:92"
	set_param cpu0 min_sample_time 58000
	set_param cpu4 above_hispeed_delay "18000 1680000:98000 1880000:138000"
	set_param cpu4 hispeed_freq 1380000
	set_param cpu4 go_hispeed_load 98
	set_param cpu4 target_loads "80 780000:40 880000:34 980000:66 1080000:31 1180000:72 1380000:86 1680000:98"
	set_param cpu4 min_sample_time 18000
    ;;

	
	"universal8890")  #EXYNOS8890 (S7)
	set_param cpu0 above_hispeed_delay "18000 1280000:38000 1480000:98000 1580000:18000"
	set_param cpu0 hispeed_freq 1180000
	set_param cpu0 go_hispeed_load 98
	set_param cpu0 target_loads "80 480000:49 680000:34 780000:61 880000:33 980000:63 1080000:69 1180000:77 1480000:98"
	set_param cpu0 min_sample_time 18000
	set_param cpu4 above_hispeed_delay "18000 1580000:98000 1880000:138000"
	set_param cpu4 hispeed_freq 1380000
	set_param cpu4 go_hispeed_load 93
	set_param cpu4 target_loads "80 780000:33 880000:67 980000:42 1080000:75 1180000:65 1280000:74 1480000:97"
	set_param cpu4 min_sample_time 18000
    ;;

	"universal7420") #EXYNOS7420 (S6)
	set_param cpu0 above_hispeed_delay "58000 1280000:18000 1380000:98000 1480000:58000"
	set_param cpu0 hispeed_freq 1180000
	set_param cpu0 go_hispeed_load 97
	set_param cpu0 target_loads "80 480000:29 580000:12 680000:69 780000:22 880000:36 1080000:80 1180000:89 1480000:63"
	set_param cpu0 min_sample_time 38000
	set_param cpu4 above_hispeed_delay "18000 1480000:78000 1580000:98000 1880000:138000"
	set_param cpu4 hispeed_freq 1380000
	set_param cpu4 go_hispeed_load 96
	set_param cpu4 target_loads "80 880000:27 980000:44 1080000:71 1180000:32 1280000:64 1380000:78 1480000:87 1580000:98"
	set_param cpu4 min_sample_time 18000
    ;;

	
	"kirin970")  # Huawei Kirin 970
	set_param cpu0 above_hispeed_delay "18000 1480000:38000 1680000:98000"
	set_param cpu0 hispeed_freq 1180000
	set_param cpu0 go_hispeed_load 97
	set_param cpu0 target_loads "80 980000:61 1180000:88 1380000:70 1480000:96"
	set_param cpu0 min_sample_time 38000
	set_param cpu4 above_hispeed_delay "18000 1580000:98000 1780000:138000"
	set_param cpu4 hispeed_freq 1280000
	set_param cpu4 go_hispeed_load 94
	set_param cpu4 target_loads "80 980000:72 1280000:77 1580000:98"
	set_param cpu4 min_sample_time 18000
    ;;
	
	"kirin960")  # Huawei Kirin 960
	set_param cpu0 above_hispeed_delay "38000 1680000:98000"
	set_param cpu0 hispeed_freq 1380000
	set_param cpu0 go_hispeed_load 97
	set_param cpu0 target_loads "80 980000:97 1380000:78 1680000:98"
	set_param cpu0 min_sample_time 78000
	set_param cpu4 above_hispeed_delay "18000 1380000:98000 1780000:138000"
	set_param cpu4 hispeed_freq 880000
	set_param cpu4 go_hispeed_load 95
	set_param cpu4 target_loads "80 1380000:59 1780000:98"
	set_param cpu4 min_sample_time 38000
    ;;

	"kirin950") # Huawei Kirin 950
	set_param cpu0 above_hispeed_delay "18000 1480000:98000"
	set_param cpu0 hispeed_freq 1280000
	set_param cpu0 go_hispeed_load 97
	set_param cpu0 target_loads "80 780000:69 980000:76 1280000:80 1480000:96"
	set_param cpu0 min_sample_time 58000
	set_param cpu4 above_hispeed_delay "18000 1780000:138000"
	set_param cpu4 hispeed_freq 1180000
	set_param cpu4 go_hispeed_load 80
	set_param cpu4 target_loads "80 1180000:75 1480000:93 1780000:98"
	set_param cpu4 min_sample_time 38000
    ;;

	
	"MT6797T" | "MT6797" | "mt6797T" | "mt6797") #Helio X25 / X20	 
	set_value 50 /proc/hps/down_threshold
	set_value 80 /proc/hps/up_threshold
	set_value "3 2 0" /proc/hps/num_base_perf_serv
	set_param cpu0 above_hispeed_delay "18000 1380000:98000"
	set_param cpu0 hispeed_freq 1180000
	set_param cpu0 go_hispeed_load 93
	set_param cpu0 boostpulse_duration [balance_uni_boostpulse_duration]
	set_param cpu0 target_loads "80 380000:8 580000:14 680000:9 780000:41 880000:56 1080000:65 1180000:92 1380000:85 1480000:97"
	set_param cpu0 min_sample_time 18000
    ;;
	
	"MT6795" | "mt6795") #Helio X10
	set_value 50 /proc/hps/down_threshold
	set_value 85 /proc/hps/up_threshold
	set_value 2 /proc/hps/num_base_perf_serv
	set_param cpu0 above_hispeed_delay "18000 1480000:58000"
	set_param cpu0 hispeed_freq 1180000
	set_param cpu0 go_hispeed_load 98
	set_param cpu0 boostpulse_duration 38000
	set_param cpu0 target_loads "85 780000:62 1180000:68 1280000:87 1480000:99"
	set_param cpu0 min_sample_time 18000
    ;;
	
	*)
	
	
	if [ "$SOC" = "moorefield" ]; then 
	echo "Intel chip detected"
	else
	logdata "# *WARNING* Governor tweaks failed - Unrecognized chip : $SOC" 
	fi
	
    ;;

    esac

    case ${SOC,,} in
    "moorefield") # Intel Atom
    set_param cpu0 above_hispeed_delay "58000"
	set_param cpu0 hispeed_freq 1480000
	set_param cpu0 go_hispeed_load 99
	set_param cpu0 boostpulse_duration 18000
	set_param cpu0 target_loads "85 580000:40 680000:89 780000:35 880000:40 980000:52 1080000:66 1180000:99 1280000:70 1380000:87 1480000:93 1580000:98"
	set_param cpu0 min_sample_time 18000
	;;
    esac
 
    else

    case ${SOC,,} in
    "msm8998" | "apq8098_latv") #sd835

	echo 2 > /sys/devices/system/cpu/cpu4/core_ctl/min_cpus
	echo 60 > /sys/devices/system/cpu/cpu4/core_ctl/busy_up_thres
	echo 30 > /sys/devices/system/cpu/cpu4/core_ctl/busy_down_thres
	echo 100 > /sys/devices/system/cpu/cpu4/core_ctl/offline_delay_ms
	echo 1 > /sys/devices/system/cpu/cpu4/core_ctl/is_big_cluster
	echo 4 > /sys/devices/system/cpu/cpu4/core_ctl/task_thres

	# configure governor settings for little cluster
	set_value "0:1680000 1:1680000 2:1680000 3:1680000 4:0 5:0 6:0 7:0" /sys/module/cpu_boost/parameters/input_boost_freq
	set_param cpu0 above_hispeed_delay "18000 1580000:98000"
	set_param cpu0 hispeed_freq 1180000
	set_param cpu0 go_hispeed_load 98
	set_param cpu0 target_loads "80 380000:30 480000:41 580000:29 680000:4 780000:60 1180000:88 1280000:70 1380000:78 1480000:97"
	set_param cpu0 min_sample_time 18000

	# configure governor settings for big cluster
    set_param cpu4 above_hispeed_delay "18000 1380000:78000 1480000:18000 1580000:98000 1880000:138000"
	set_param cpu4 hispeed_freq 1280000
	set_param cpu4 go_hispeed_load 98
	set_param cpu4 target_loads "80 380000:39 580000:58 780000:63 980000:81 1080000:92 1180000:77 1280000:98 1380000:86 1580000:98"
	set_param cpu4 min_sample_time 18000


	write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 300000
	write /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 300000
	
		
	for cpubw in /sys/class/devfreq/*qcom,cpubw* ; do
    write $cpubw/governor "bw_hwmon"
    write $cpubw/polling_interval 50
    write $cpubw/min_freq 1525
    write $cpubw/bw_hwmon/mbps_zones "3143 5859 11863 13763"
    write $cpubw/bw_hwmon/sample_ms 4
    write $cpubw/bw_hwmon/io_percent 34
    write $cpubw/bw_hwmon/hist_memory 20
    write $cpubw/bw_hwmon/hyst_length 10
    write $cpubw/bw_hwmon/low_power_ceil_mbps 0
    write $cpubw/bw_hwmon/low_power_io_percent 34
    write $cpubw/bw_hwmon/low_power_delay 20
    write $cpubw/bw_hwmon/guard_band_mbps 0
    write $cpubw/bw_hwmon/up_scale 250
    write $cpubw/bw_hwmon/idle_mbps 1600
    done
    for memlat in /sys/class/devfreq/*qcom,memlat-cpu* ; do
    write $memlat/governor "mem_latency"
    write $memlat/polling_interval 10
    write $memlat/mem_latency/ratio_ceil 400
    done

    write /sys/class/devfreq/soc:qcom,mincpubw/governor "cpufreq"
	write /sys/module/lpm_levels/system/pwr/cpu0/ret/idle_enabled N
	write /sys/module/lpm_levels/system/pwr/cpu1/ret/idle_enabled N
	write /sys/module/lpm_levels/system/pwr/cpu2/ret/idle_enabled N
	write /sys/module/lpm_levels/system/pwr/cpu3/ret/idle_enabled N
	write /sys/module/lpm_levels/system/perf/cpu4/ret/idle_enabled N
	write /sys/module/lpm_levels/system/perf/cpu5/ret/idle_enabled N
	write /sys/module/lpm_levels/system/perf/cpu6/ret/idle_enabled N
	write /sys/module/lpm_levels/system/perf/cpu7/ret/idle_enabled N
	write /sys/module/lpm_levels/system/pwr/pwr-l2-dynret/idle_enabled N
	write /sys/module/lpm_levels/system/pwr/pwr-l2-ret/idle_enabled N
	write /sys/module/lpm_levels/system/perf/perf-l2-dynret/idle_enabled N
	write /sys/module/lpm_levels/system/perf/perf-l2-ret/idle_enabled N
	write /sys/module/lpm_levels/parameters/sleep_disabled N

	echo 0-3 > /dev/cpuset/background/cpus
	echo 0-3 > /dev/cpuset/system-background/cpus
	echo 0 > /proc/sys/kernel/sched_boost
    ;;

    "msm8996")
        
	set_value 280000 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	set_value 280000 /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq

	set_value 25 /proc/sys/kernel/sched_downmigrate
	set_value 45 /proc/sys/kernel/sched_upmigrate
	set_value "0:1280000 1:1280000 2:0 3:0" /sys/module/cpu_boost/parameters/input_boost_freq
	set_param cpu0 above_hispeed_delay "98000 1580000:58000"
	set_param cpu0 hispeed_freq 1180000
	set_param cpu0 go_hispeed_load 97
	set_param cpu0 target_loads "80 380000:15 480000:5 580000:62 780000:71 880000:96 980000:87 1080000:98"
	set_param cpu0 min_sample_time 18000
	set_param cpu2 above_hispeed_delay "18000 1280000:98000 1380000:58000 1480000:98000 1880000:138000"
	set_param cpu2 hispeed_freq 1180000
	set_param cpu2 go_hispeed_load 98
	set_param cpu2 target_loads "80 380000:22 580000:48 680000:72 880000:88 1180000:98 1280000:85 1480000:92 1580000:98"
	set_param cpu2 min_sample_time 18000

    ;;

    "msm8994" | "msm8992")
	
	set_value 380000 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	set_value 380000 /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
	set_value 2 /sys/devices/system/cpu/cpu4/core_ctl/min_cpus
	set_value 2 /sys/devices/system/cpu/cpu4/core_ctl/max_cpus
	set_value "0:1344000 4:1440000" /sys/module/msm_performance/parameters/cpu_max_freq
	set_value 1344000 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
	set_value 1440000 /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
	set_value "0:1180000 1:1180000 2:1180000 3:1180000 4:0 5:0 6:0 7:0" /sys/module/cpu_boost/parameters/input_boost_freq
	set_param cpu0 above_hispeed_delay "98000 1280000:18000"
	set_param cpu0 hispeed_freq 1180000
	set_param cpu0 go_hispeed_load 97
	set_param cpu0 target_loads "80 580000:46 680000:16 780000:63 880000:91 1180000:98"
	set_param cpu0 min_sample_time 18000
	set_param cpu4 above_hispeed_delay "18000 1180000:98000 1380000:78000"
	set_param cpu4 hispeed_freq 880000
	set_param cpu4 go_hispeed_load 97
	set_param cpu4 target_loads "80 580000:44 680000:58 780000:71 880000:96"
	set_param cpu4 min_sample_time 38000
	
    ;;

    "msm8974" | "APQ8084")
	
	setprop ro.qualcomm.perf.cores_online 2
	set_param cpu0 above_hispeed_delay "18000 1480000:78000 1780000:138000"
	set_param cpu0 hispeed_freq 1180000
	set_param cpu0 go_hispeed_load 99
	set_param cpu0 boostpulse_duration 18000
	set_param cpu0 target_loads "49 380000:37 580000:65 680000:81 880000:45 980000:91 1480000:80 1680000:99"
	set_param cpu0 min_sample_time 18000

    ;;

    "sdm660")

	set_value 50 /sys/module/cpu_boost/parameters/input_boost_ms
	set_value "0:1080000 1:1080000 2:1080000 3:1080000 4:0 5:0 6:0 7:0" /sys/module/cpu_boost/parameters/input_boost_freq
	set_param cpu0 above_hispeed_delay "18000 1480000:58000"
	set_param cpu0 hispeed_freq 1080000
	set_param cpu0 go_hispeed_load 91
	set_param cpu0 boostpulse_duration 38000
	set_param cpu0 target_loads "80 880000:63 1080000:81 1380000:75 1480000:99"
	set_param cpu0 min_sample_time 18000
	set_param cpu4 above_hispeed_delay "58000 1380000:18000 1680000:58000 1780000:138000"
	set_param cpu4 hispeed_freq 1080000
	set_param cpu4 go_hispeed_load 83
	set_param cpu4 boostpulse_duration 38000
	set_param cpu4 target_loads "80 1680000:99"
	set_param cpu4 min_sample_time 18000
	
    ;;
    "msm8956" | "msm8976")
	set_value 50 /sys/module/cpu_boost/parameters/input_boost_ms
	set_value "0:980000 1:980000 2:980000 3:980000 4:0 5:0 6:0 7:0" /sys/module/cpu_boost/parameters/input_boost_freq
	set_param cpu0 boost 0
	set_param cpu4 boost 0
	set_param cpu0 above_hispeed_delay "18000 1180000:38000 1280000:58000 1380000:18000"
	set_param cpu0 hispeed_freq 980000
	set_param cpu0 go_hispeed_load 98
	set_param cpu0 boostpulse_duration 58000
	set_param cpu0 target_loads "80 680000:58 780000:98 980000:65 1180000:79"
	set_param cpu0 min_sample_time 18000
	set_param cpu4 above_hispeed_delay "18000 1580000:58000"
	set_param cpu4 hispeed_freq 1280000
	set_param cpu4 go_hispeed_load 97
	set_param cpu4 boostpulse_duration 18000
	set_param cpu4 target_loads "80 880000:69 1080000:90 1280000:74 1380000:91 1580000:99"
	set_param cpu4 min_sample_time 18000

    ;;

    "sdm636" )
	set_value "0:1480000 1:1480000 2:1480000 3:1480000 4:0 5:0 6:0 7:0" /sys/module/cpu_boost/parameters/input_boost_freq
	set_param cpu0 above_hispeed_delay "18000 1380000:78000 1480000:98000 1580000:38000"
	set_param cpu0 hispeed_freq 1080000
	set_param cpu0 go_hispeed_load 98
	set_param cpu0 target_loads "80 880000:62 1080000:98 1380000:84 1480000:97"
	set_param cpu0 min_sample_time 58000
	set_param cpu4 above_hispeed_delay "18000 1680000:98000"
	set_param cpu4 hispeed_freq 1080000
	set_param cpu4 go_hispeed_load 86
	set_param cpu4 target_loads "80 1380000:84 1680000:98"
	set_param cpu4 min_sample_time 18000
    
	;;

    "msm8953" )
	set_value "0:1680000 1:1680000 2:1680000 3:1680000 4:0 5:0 6:0 7:0" /sys/module/cpu_boost/parameters/input_boost_freq
	set_param cpu0 above_hispeed_delay "18000 1680000:98000 1880000:138000"
	set_param cpu0 hispeed_freq 1380000
	set_param cpu0 go_hispeed_load 94
	set_param cpu0 target_loads "80 980000:66 1380000:96"
	set_param cpu0 min_sample_time 18000
    ;;

	
	"universal8895")
	set_param cpu0 above_hispeed_delay "38000 1380000:98000"
	set_param cpu0 hispeed_freq 1180000
	set_param cpu0 go_hispeed_load 82
	set_param cpu0 target_loads "80 680000:27 780000:39 880000:61 980000:68 1380000:98 1680000:94"
	set_param cpu0 min_sample_time 18000
	set_param cpu4 above_hispeed_delay "18000 1680000:98000 1880000:138000"
	set_param cpu4 hispeed_freq 1380000
	set_param cpu4 go_hispeed_load 98
	set_param cpu4 target_loads "80 780000:73 880000:79 980000:55 1080000:69 1180000:84 1380000:98"
	set_param cpu4 min_sample_time 18000
    ;;

	
	"universal8890")
	set_param cpu0 above_hispeed_delay "38000 1280000:18000 1480000:98000 1580000:58000"
	set_param cpu0 hispeed_freq 1180000
	set_param cpu0 go_hispeed_load 96
	set_param cpu0 target_loads "80 480000:51 680000:28 780000:56 880000:63 1080000:71 1180000:75 1280000:97"
	set_param cpu0 min_sample_time 18000
	set_param cpu4 above_hispeed_delay "18000 1480000:98000 1880000:138000"
	set_param cpu4 hispeed_freq 1280000
	set_param cpu4 go_hispeed_load 98
	set_param cpu4 target_loads "80 780000:4 880000:77 980000:14 1080000:90 1180000:68 1280000:92 1480000:96"
	set_param cpu4 min_sample_time 18000
    ;;

	"universal7420")
    set_param cpu0 above_hispeed_delay "38000 1280000:78000 1380000:98000 1480000:58000"
	set_param cpu0 hispeed_freq 1180000
	set_param cpu0 go_hispeed_load 96
	set_param cpu0 target_loads "80 480000:28 580000:19 680000:37 780000:51 880000:61 1080000:83 1180000:66 1280000:91 1380000:96"
	set_param cpu0 min_sample_time 18000
	set_param cpu4 above_hispeed_delay "98000 1880000:138000"
	set_param cpu4 hispeed_freq 1480000
	set_param cpu4 go_hispeed_load 97
	set_param cpu4 target_loads "80 880000:74 980000:56 1080000:80 1180000:92 1380000:85 1480000:93 1580000:98"
	set_param cpu4 min_sample_time 18000
    ;;

	
	"kirin970")  # Huawei Kirin 970
	set_param cpu0 above_hispeed_delay "18000 1380000:38000 1480000:98000"
	set_param cpu0 hispeed_freq 1180000
	set_param cpu0 go_hispeed_load 98
	set_param cpu0 target_loads "80 980000:60 1180000:87 1380000:70 1480000:98"
	set_param cpu0 min_sample_time 18000
	set_param cpu4 above_hispeed_delay "18000 1580000:98000 1780000:138000"
	set_param cpu4 hispeed_freq 1280000
	set_param cpu4 go_hispeed_load 98
	set_param cpu4 target_loads "80 1280000:98 1480000:91 1580000:98"
	set_param cpu4 min_sample_time 18000
	
    ;;
	
	"kirin960")  # Huawei Kirin 960
	set_param cpu0 above_hispeed_delay "38000 1680000:98000"
	set_param cpu0 hispeed_freq 1380000
	set_param cpu0 go_hispeed_load 97
	set_param cpu0 target_loads "80 980000:93 1380000:97"
	set_param cpu0 min_sample_time 58000
	set_param cpu4 above_hispeed_delay "18000 1780000:138000"
	set_param cpu4 hispeed_freq 880000
	set_param cpu4 go_hispeed_load 84
	set_param cpu4 target_loads "80 1380000:98"
	set_param cpu4 min_sample_time 38000
	
    ;;

	"kirin950") # Huawei Kirin 950
	set_param cpu0 above_hispeed_delay "18000 1480000:98000"
	set_param cpu0 hispeed_freq 1280000
	set_param cpu0 go_hispeed_load 98
	set_param cpu0 target_loads "80 780000:62 980000:71 1280000:77 1480000:98"
	set_param cpu0 min_sample_time 18000
	set_param cpu4 above_hispeed_delay "18000 1480000:98000 1780000:138000"
	set_param cpu4 hispeed_freq 780000
	set_param cpu4 go_hispeed_load 80
	set_param cpu4 target_loads "80 1180000:89 1480000:98"
	set_param cpu4 min_sample_time 38000
	
    ;;

	
	"MT6797T" | "MT6797" | "mt6797T" | "mt6797") #Helio X25 / X20	 
	set_value 60 /proc/hps/down_threshold
	set_param cpu0 io_is_busy 0
	
	set_value 95 /proc/hps/up_threshold
	set_value "2 2 0" /proc/hps/num_base_perf_serv
	set_param cpu0 above_hispeed_delay "18000 1480000:58000"
	set_param cpu0 hispeed_freq 980000
	set_param cpu0 go_hispeed_load 99
	set_param cpu0 boostpulse_duration 38000
	set_param cpu0 target_loads "85 380000:32 480000:10 580000:22 680000:36 780000:61 880000:91 980000:76 1080000:80 1180000:99 1380000:68 1480000:99"
	set_param cpu0 min_sample_time 18000
	
    ;;

	
	"MT6795" | "mt6795") #Helio X10
	
	set_value 60 /proc/hps/down_threshold
	set_param cpu0 io_is_busy 0
	
	set_value 95 /proc/hps/up_threshold
	set_value 1 /proc/hps/num_base_perf_serv
	set_param cpu0 above_hispeed_delay "18000 1280000:38000 1480000:58000"
	set_param cpu0 hispeed_freq 1180000
	set_param cpu0 go_hispeed_load 97
	set_param cpu0 boostpulse_duration 18000
	set_param cpu0 target_loads "85 780000:63 1180000:68 1280000:92 1480000:99"
	set_param cpu0 min_sample_time 18000
	
    ;;

	*)
	
	if [ "$SOC" = "moorefield" ]; then 
	echo "Intel chip detected"
	else
	logdata "# *WARNING* Governor tweaks failed - Unrecognized chip : $SOC" 
	fi
		
    ;;

    esac

    case ${SOC,,} in
    "moorefield") # Intel ATOM
    set_param cpu0 above_hispeed_delay "58000"
	set_param cpu0 hispeed_freq 1480000
	set_param cpu0 go_hispeed_load 99
	set_param cpu0 boostpulse_duration 18000
	set_param cpu0 target_loads "85 580000:38 680000:88 780000:43 980000:66 1080000:91 1180000:99 1280000:91 1380000:87 1480000:93 1580000:98"
	set_param cpu0 min_sample_time 18000
	;;
    esac

    fi
 
 
# =========
# HMP Scheduler Tweaks
# =========

write /proc/sys/kernel/sched_select_prev_cpu_us 0
write /proc/sys/kernel/sched_spill_nr_run 5
write /proc/sys/kernel/sched_restrict_cluster_spill 1
write /proc/sys/kernel/sched_prefer_sync_wakee_to_waker 1
#write /proc/sys/kernel/sched_window_stats_policy 2
#write /proc/sys/kernel/sched_upmigrate 45
#write /proc/sys/kernel/sched_downmigrate 25
#write /proc/sys/kernel/sched_spill_nr_run 3
write /proc/sys/kernel/sched_spill_load 90
write /proc/sys/kernel/sched_init_task_load 40
#if [ -e "/proc/sys/kernel/sched_heavy_task" ]; then
#    write /proc/sys/kernel/sched_heavy_task 0
#fi
#write /proc/sys/kernel/sched_upmigrate_min_nice 15
#write /proc/sys/kernel/sched_ravg_hist_size 4
#if [ -e "/proc/sys/kernel/sched_small_wakee_task_load" ]; then
#write /proc/sys/kernel/sched_small_wakee_task_load 65
#fi
#if [ -e "/proc/sys/kernel/sched_wakeup_load_threshold" ]; then
#write /proc/sys/kernel/sched_wakeup_load_threshold 110
#fi
#if [ -e "/proc/sys/kernel/sched_small_task" ]; then
#write /proc/sys/kernel/sched_small_task 10
#fi
#if [ -e "/proc/sys/kernel/sched_big_waker_task_load" ]; then
#write /proc/sys/kernel/sched_big_waker_task_load 80
#fi
#if [ -e "/proc/sys/kernel/sched_rt_runtime_us" ]; then
#write /proc/sys/kernel/sched_rt_runtime_us 950000
#fi
#if [ -e "/proc/sys/kernel/sched_rt_period_us" ]; then
#write /proc/sys/kernel/sched_rt_period_us 1000000
#fi
#if [ -e "/proc/sys/kernel/sched_enable_thread_grouping" ]; then
#write /proc/sys/kernel/sched_enable_thread_grouping 1
#fi
#if [ -e "/proc/sys/kernel/sched_rr_timeslice_ms" ]; then
#write /proc/sys/kernel/sched_rr_timeslice_ms 20
#fi
#if [ -e "/proc/sys/kernel/sched_migration_fixup" ]; then
write /proc/sys/kernel/sched_migration_fixup 1
#fi
#if [ -e "/proc/sys/kernel/sched_freq_dec_notify" ]; then
write /proc/sys/kernel/sched_freq_dec_notify 400000
#fi
#if [ -e "/proc/sys/kernel/sched_freq_inc_notify" ]; then
write /proc/sys/kernel/sched_freq_inc_notify 3000000
#fi
#if [ -e "/proc/sys/kernel/sched_boost" ]; then
#write /proc/sys/kernel/sched_boost 0
#fi
#if [ -e "/proc/sys/kernel/sched_enable_power_aware" ]; then
#    write /proc/sys/kernel/sched_enable_power_aware 1
#fi

	else
	logdata "# *WARNING* Governor tweaks failed - Unsupported governor: $govn" 

	fi
	fi
	
	# Enable Thermal engine
	enable_bcl

    # Enable power efficient work_queue mode
	if [ -e /sys/module/workqueue/parameters/power_efficient ]; then
	set_value "Y" /sys/module/workqueue/parameters/power_efficient 
	logdata "#  Power efficient work_queue mode = Activated" 
	else
	logdata "# *WARNING* Your kernel doesn't support power efficient work_queue mode" 
	fi

#	if [ -e "/sys/devices/system/cpu/cpu0/cpufreq/interactive/screen_off_maxfreq" ]; then
#		set_param cpu0 screen_off_maxfreq 307200
#	fi
#	if [ -e "/sys/devices/system/cpu/cpu0/cpufreq/interactive/powersave_bias" ]; then
		set_param cpu0 powersave_bias 1
#	fi

}

# =========
# CPU Governor Tuning
# =========

CPU_tuning
 
# =========
# GPU Tweaks
# =========

 logdata "#  Governor Tweaks = Activated" 

 # set GPU default power level to 6 instead of 4 or 5
 set_value /sys/class/kgsl/kgsl-3d0/default_pwrlevel 6
	
 if [ -e "/sys/module/adreno_idler" ]; then
	write /sys/module/adreno_idler/parameters/adreno_idler_active "Y"
	write /sys/module/adreno_idler/parameters/adreno_idler_idleworkload "8000"
 logdata "# Adreno Idler (GPU) = Activated" 
 else
 logdata "#  *WARNING* Your Kernel does not support Adreno Idler" 
 fi

# =========
# RAM TWEAKS
# =========

RAM_tuning

# =========
# REDUCE DEBUGGING
# =========

write /sys/module/binder/parameters/debug_mask "0"
write /sys/module/bluetooth/parameters/disable_ertm "Y"
write /sys/module/bluetooth/parameters/disable_esco "Y"
write /sys/module/debug/parameters/enable_event_log "0"
write /sys/module/dwc3/parameters/ep_addr_rxdbg_mask "0" 
write /sys/module/dwc3/parameters/ep_addr_txdbg_mask "0"
write /sys/module/edac_core/parameters/edac_mc_log_ce "0"
write /sys/module/edac_core/parameters/edac_mc_log_ue "0"
write /sys/module/glink/parameters/debug_mask"0"
write /sys/module/hid_apple/parameters/fnmode"0"
write /sys/module/hid_magicmouse/parameters/emulate_3button "N"
write /sys/module/hid_magicmouse/parameters/emulate_scroll_wheel "N"
write /sys/module/ip6_tunnel/parameters/log_ecn_error "N"
write /sys/module/lowmemorykiller/parameters/debug_level "0"
write /sys/module/mdss_fb/parameters/backlight_dimmer  "N"
write /sys/module/msm_show_resume_irq/parameters/debug_mask "0"
write /sys/module/msm_smd/parameters/debug_mask "0"
write /sys/module/msm_smem/parameters/debug_mask "0" 
write /sys/module/otg_wakelock/parameters/enabled "N" 
write /sys/module/service_locator/parameters/enable "0" 
write /sys/module/sit/parameters/log_ecn_error "N"
write /sys/module/smem_log/parameters/log_enable "0"
write /sys/module/smp2p/parameters/debug_mask "0"
write /sys/module/sync/parameters/fsync_enabled "N"
write /sys/module/touch_core_base/parameters/debug_mask "0"
write /sys/module/usb_bam/parameters/enable_event_log "0"

set_value 0 /sys/module/wakelock/parameters/debug_mask
set_value 0 /sys/module/userwakelock/parameters/debug_mask
set_value 0 /sys/module/earlysuspend/parameters/debug_mask
set_value 0 /sys/module/alarm/parameters/debug_mask
set_value 0 /sys/module/alarm_dev/parameters/debug_mask
set_value 0 /sys/module/binder/parameters/debug_mask
set_value 0 /sys/devices/system/edac/cpu/log_ce
set_value 0 /sys/devices/system/edac/cpu/log_ue

sysctl kernel.panic_on_oops=0
sysctl kernel.panic=0

for i in $( find /sys/ -name debug_mask); do
 write $i 0;
done;

if [ -e /sys/module/logger/parameters/log_mode ]; then
 write /sys/module/logger/parameters/log_mode 2
fi;

logdata "#  Limit Logging & Debugging = Activated" 

sleep 0.1

# =========
# I/O TWEAKS
# =========

sch=$(cat "/sys/block/mmcblk0/queue/scheduler");

	set_io cfq /sys/block/mmcblk0
	set_io cfq /sys/block/sda

#for mmcblk in /sys/block/mmcblk0 ; do
    write /sys/block/mmcblk0/queue/add_random "0"
    write /sys/block/mmcblk0/queue/rotational "0"
    write /sys/block/mmcblk0/queue/read_ahead_kb "128"
    write /sys/block/mmcblk0/bdi/read_ahead_kb "128"
#done

for i in /sys/block/loop*; do
	write $i/queue/add_random 0
	write $i/queue/iostats 0
   	write $i/queue/nomerges 1
   	write $i/queue/rotational 0
   	write $i/queue/rq_affinity 1
done
for j in /sys/block/ram*; do
	write $j/queue/add_random 0
	write $j/queue/iostats 0
	write $j/queue/nomerges 1
	write $j/queue/rotational 0
   	write $j/queue/rq_affinity 1
done

for k in /sys/block/sd*; do
	write $k/queue/add_random 0
	write $k/queue/iostats 0
done


logdata "#  I/O Tweaks = Activated" 

# =========
# TCP TWEAKS
# =========

algos=$(</proc/sys/net/ipv4/tcp_available_congestion_control);
if [[ $algos == *"sociopath"* ]]
then
write /proc/sys/net/ipv4/tcp_congestion_control "sociopath"
logdata "#  TCP : sociopath algorithm = Selected" 
elif [[ $algos == *"westwood"* ]]
then
write /proc/sys/net/ipv4/tcp_congestion_control "westwood"
logdata "#  TCP : westwood algorithm = Selected" 
else
write /proc/sys/net/ipv4/tcp_congestion_control "cubic"
logdata "#  TCP : cubic algorithm = Selected" 
fi

write /proc/sys/net/ipv4/tcp_ecn 2
write /proc/sys/net/ipv4/tcp_dsack 1
write /proc/sys/net/ipv4/tcp_low_latency 1
write /proc/sys/net/ipv4/tcp_timestamps 1
write /proc/sys/net/ipv4/tcp_sack 1
write /proc/sys/net/ipv4/tcp_window_scaling 1

# =========
# Minor Tweaks
# =========

# Enable fast USB charging

write /sys/KERNEL/FAST_CHARGE/force_fast_charge 1

# Disable Gentle Fair Sleepers

if [ -e /sys/kernel/debug/sched_features ]
then

write /sys/kernel/debug/sched_features NO_GENTLE_FAIR_SLEEPERS
write /sys/kernel/debug/sched_features START_DEBIT
write /sys/kernel/debug/sched_features NO_NEXT_BUDDY
write /sys/kernel/debug/sched_features LAST_BUDDY
write /sys/kernel/debug/sched_features CACHE_HOT_BUDDY
write /sys/kernel/debug/sched_features WAKEUP_PREEMPTION
write /sys/kernel/debug/sched_features ARCH_POWER
write /sys/kernel/debug/sched_features NO_HRTICK
write /sys/kernel/debug/sched_features NO_DOUBLE_TICK
write /sys/kernel/debug/sched_features LB_BIAS
write /sys/kernel/debug/sched_features NONTASK_POWER
write /sys/kernel/debug/sched_features TTWU_QUEUE
write /sys/kernel/debug/sched_features NO_FORCE_SD_OVERLAP
write /sys/kernel/debug/sched_features RT_RUNTIME_SHARE
write /sys/kernel/debug/sched_features NO_LB_MIN

fi

logdata "#  Misc Tweaks = Activated" 

# =========
# Blocking Wakelocks
# =========

if [ -e "/sys/class/misc/boeffla_wakelock_blocker/wakelock_blocker" ]; then
write /sys/class/misc/boeffla_wakelock_blocker/wakelock_blocker "wlan_pno_wl;wlan_ipa;wcnss_filter_lock;[timerfd];hal_bluetooth_lock;IPA_WS;sensor_ind;wlan;netmgr_wl;qcom_rx_wakelock;wlan_wow_wl;wlan_extscan_wl;"
logdata "#  Boeffla wake-locks blocker = Activated" 
fi


if [ -e "/sys/module/wakeup/parameters" ]; then
if [ -e "/sys/module/bcmdhd/parameters/wlrx_divide" ]; then
set_value /sys/module/bcmdhd/parameters/wlrx_divide 8
fi
if [ -e "/sys/module/bcmdhd/parameters/wlctrl_divide" ]; then
set_value /sys/module/bcmdhd/parameters/wlctrl_divide 8
fi
if [ -e "/sys/module/wakeup/parameters/enable_bluetooth_timer" ]; then
set_value /sys/module/wakeup/parameters/enable_bluetooth_timer Y
fi
if [ -e "/sys/module/wakeup/parameters/enable_wlan_ipa_ws" ]; then
set_value /sys/module/wakeup/parameters/enable_wlan_ipa_ws N
fi
if [ -e "/sys/module/wakeup/parameters/enable_wlan_pno_wl_ws N" ]; then
set_value /sys/module/wakeup/parameters/enable_wlan_pno_wl_ws N
fi
if [ -e "/sys/module/wakeup/parameters/enable_wcnss_filter_lock_ws N" ]; then
set_value /sys/module/wakeup/parameters/enable_wcnss_filter_lock_ws N
fi
if [ -e "/sys/module/wakeup/parameters/wlan_wake" ]; then
set_value N /sys/module/wakeup/parameters/wlan_wake
fi
if [ -e "/sys/module/wakeup/parameters/wlan_ctrl_wake" ]; then
set_value N /sys/module/wakeup/parameters/wlan_ctrl_wake
fi
if [ -e "/sys/module/wakeup/parameters/wlan_rx_wake" ]; then
set_value N /sys/module/wakeup/parameters/wlan_rx_wake
fi
if [ -e "/sys/module/wakeup/parameters/enable_msm_hsic_ws" ]; then
set_value N /sys/module/wakeup/parameters/enable_msm_hsic_ws
fi
if [ -e "/sys/module/wakeup/parameters/enable_si_ws" ]; then
set_value N /sys/module/wakeup/parameters/enable_si_ws
fi
if [ -e "/sys/module/wakeup/parameters/enable_si_ws" ]; then
set_value N /sys/module/wakeup/parameters/enable_si_ws
fi
if [ -e "/sys/module/wakeup/parameters/enable_bluedroid_timer_ws" ]; then
set_value N /sys/module/wakeup/parameters/enable_bluedroid_timer_ws
fi
if [ -e "/sys/module/wakeup/parameters/enable_ipa_ws" ]; then
set_value N /sys/module/wakeup/parameters/enable_ipa_ws
fi
if [ -e "/sys/module/wakeup/parameters/enable_netlink_ws" ]; then
set_value N /sys/module/wakeup/parameters/enable_netlink_ws
fi
if [ -e "/sys/module/wakeup/parameters/enable_netmgr_wl_ws" ]; then
set_value N /sys/module/wakeup/parameters/enable_netmgr_wl_ws
fi
if [ -e "/sys/module/wakeup/parameters/enable_qcom_rx_wakelock_ws" ]; then
set_value N /sys/module/wakeup/parameters/enable_qcom_rx_wakelock_ws
fi
if [ -e "/sys/module/wakeup/parameters/enable_timerfd_ws" ]; then
set_value N /sys/module/wakeup/parameters/enable_timerfd_ws
fi
if [ -e "/sys/module/wakeup/parameters/enable_wlan_extscan_wl_ws" ]; then
set_value N /sys/module/wakeup/parameters/enable_wlan_extscan_wl_ws
fi
if [ -e "/sys/module/wakeup/parameters/enable_wlan_rx_wake_ws" ]; then
set_value N /sys/module/wakeup/parameters/enable_wlan_rx_wake_ws
fi
if [ -e "/sys/module/wakeup/parameters/enable_wlan_wake_ws" ]; then
set_value N /sys/module/wakeup/parameters/enable_wlan_wake_ws
fi
if [ -e "/sys/module/wakeup/parameters/enable_wlan_wow_wl_ws" ]; then
set_value N /sys/module/wakeup/parameters/enable_wlan_wow_wl_ws
fi
if [ -e "/sys/module/wakeup/parameters/enable_wlan_ws" ]; then
set_value N /sys/module/wakeup/parameters/enable_wlan_ws
fi
if [ -e "/sys/module/wakeup/parameters/enable_wlan_ctrl_wake_ws" ]; then
set_value N /sys/module/wakeup/parameters/enable_wlan_ctrl_wake_ws
fi
logdata "#  Kernel Wake-locks Blocking = Activated" 
else
logdata "# *WARNING* Your kernel doesn't support wake-lock Blocking" 
fi

# =========
# Google Services Drain fix
# =========

sleep 0.1
su -c "pm enable com.google.android.gms"
sleep 0.1
su -c "pm enable com.google.android.gsf"
sleep 0.1
su -c "pm enable com.google.android.gms/.update.SystemUpdateActivity"
sleep 0.1
su -c "pm enable com.google.android.gms/.update.SystemUpdateService"
sleep 0.1
su -c "pm enable com.google.android.gms/.update.SystemUpdateService$ActiveReceiver"
sleep 0.1
su -c "pm enable com.google.android.gms/.update.SystemUpdateService$Receiver"
sleep 0.1
su -c "pm enable com.google.android.gms/.update.SystemUpdateService$SecretCodeReceiver"
sleep 0.1
su -c "pm enable com.google.android.gsf/.update.SystemUpdateActivity"
sleep 0.1
su -c "pm enable com.google.android.gsf/.update.SystemUpdatePanoActivity"
sleep 0.1
su -c "pm enable com.google.android.gsf/.update.SystemUpdateService"
sleep 0.1
su -c "pm enable com.google.android.gsf/.update.SystemUpdateService$Receiver"
sleep 0.1
su -c "pm enable com.google.android.gsf/.update.SystemUpdateService$SecretCodeReceiver"


# =========
# CLEAN UP
# =========

# Search all subdirectories

for f in $(find /cache -name '*.apk' -or -name '*.tmp' -or -name '*.temp' -or -name '*.log' -or -name '*.txt' -or -name '*.0'); do rm $f; done
for f in $(find /data -name '*.tmp' -or -name '*.temp' -or -name '*.log' -or -name '*.0'); do rm $f; done
for f in $(find /sdcard -name '*.tmp' -or -name '*.temp' -or -name '*.log' -or -name '*.0'); do rm $f; done


logdata "#  Clean-up = Executed" 

# =========
# Battery Check
# =========

BATTLEVEL=`cat /sys/class/power_supply/battery/capacity`;
logdata "#  Battery Charge = $BATTLEVEL % "

# FS-TRIM
fstrim -v /cache
fstrim -v /data
fstrim -v /system
logdata "#  FS-TRIM = Executed" 

start perfd

logdata "# ==============================" 
logdata "#  END : $sDATE" 

exit 0
