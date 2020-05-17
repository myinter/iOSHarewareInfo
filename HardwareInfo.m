//
//  HardwareInfo.m
//  TMSearchUI
//
//  Created by 熊韦华 on 2020/2/17.
//

#import "HardwareInfo.h"
#import <sys/utsname.h>
#import <mach/mach.h>
#import <sys/sysctl.h>
#import <sys/types.h>


static processor_info_array_t prevCPUInfo = NULL;
static mach_msg_type_number_t numPrevCPUInfo;

static bool locked;

// iPhone
//if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
//if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
//if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
//if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
//if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
//if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
//if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
//if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
//if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
//if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
//if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
//if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
//if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
//if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
//if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
//if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
//if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
//if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
//if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
//if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
//if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
//if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
//if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
//if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
//if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
//if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
//if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
//if ([platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS MAX";
//if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
//if ([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
//if ([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
//if ([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
//
//
//// iPod
//if ([platform isEqualToString:@"iPod1,1"])  return @"iPod Touch 1";
//if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2";
//if ([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3";
//if ([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4";
//if ([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5";
//if ([platform isEqualToString:@"iPod7,1"])  return @"iPod Touch 6";
//if ([platform isEqualToString:@"iPod9,1"])  return @"iPod Touch 7";
//
//// iPad
//if ([platform isEqualToString:@"iPad1,1"])  return @"iPad 1";
//if ([platform isEqualToString:@"iPad2,1"])  return @"iPad 2";
//if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
//if ([platform isEqualToString:@"iPad2,3"])  return @"iPad 2";
//if ([platform isEqualToString:@"iPad2,4"])  return @"iPad 2";
//if ([platform isEqualToString:@"iPad2,5"])  return @"iPad Mini 1";
//if ([platform isEqualToString:@"iPad2,6"])  return @"iPad Mini 1";
//if ([platform isEqualToString:@"iPad2,7"])  return @"iPad Mini 1";
//if ([platform isEqualToString:@"iPad3,1"])  return @"iPad 3";
//if ([platform isEqualToString:@"iPad3,2"])  return @"iPad 3";
//if ([platform isEqualToString:@"iPad3,3"])  return @"iPad 3";
//if ([platform isEqualToString:@"iPad3,4"])  return @"iPad 4";
//if ([platform isEqualToString:@"iPad3,5"])  return @"iPad 4";
//if ([platform isEqualToString:@"iPad3,6"])  return @"iPad 4";
//if ([platform isEqualToString:@"iPad4,1"])  return @"iPad Air";
//if ([platform isEqualToString:@"iPad4,2"])  return @"iPad Air";
//if ([platform isEqualToString:@"iPad4,3"])  return @"iPad Air";
//if ([platform isEqualToString:@"iPad4,4"])  return @"iPad Mini 2";
//if ([platform isEqualToString:@"iPad4,5"])  return @"iPad Mini 2";
//if ([platform isEqualToString:@"iPad4,6"])  return @"iPad Mini 2";
//if ([platform isEqualToString:@"iPad4,7"])  return @"iPad mini 3";
//if ([platform isEqualToString:@"iPad4,8"])  return @"iPad mini 3";
//if ([platform isEqualToString:@"iPad4,8"])  return @"iPad mini 3";
//if ([platform isEqualToString:@"iPad4,9"])  return @"iPad mini 4";
//if ([platform isEqualToString:@"iPad5,2"])  return @"iPad mini 4";
//if ([platform isEqualToString:@"iPad5,3"])  return @"iPad Air 2";
//if ([platform isEqualToString:@"iPad5,4"])  return @"iPad Air 2";
//if ([platform isEqualToString:@"iPad6,3"])  return @"iPad Pro (9.7-inch)";
//if ([platform isEqualToString:@"iPad6,4"])  return @"iPad Pro (9.7-inch)";
//if ([platform isEqualToString:@"iPad6,7"])  return @"iPad Pro (12.9-inch)";
//if ([platform isEqualToString:@"iPad6,8"])  return @"iPad Pro (12.9-inch)";
//if ([platform isEqualToString:@"iPad6,11"])  return @"iPad 5";
//if ([platform isEqualToString:@"iPad6,12"])  return @"iPad 5";
//if ([platform isEqualToString:@"iPad7,1"])  return @"iPad Pro 2(12.9-inch)";
//if ([platform isEqualToString:@"iPad7,2"])  return @"iPad Pro 2(12.9-inch)";
//if ([platform isEqualToString:@"iPad7,3"])  return @"iPad Pro (10.5-inch)";
//if ([platform isEqualToString:@"iPad7,4"])  return @"iPad Pro (10.5-inch)";
//if ([platform isEqualToString:@"iPad7,5"])  return @"iPad 6";
//if ([platform isEqualToString:@"iPad7,6"])  return @"iPad 6";
//if ([platform isEqualToString:@"iPad7,11"])  return @"iPad 7";
//if ([platform isEqualToString:@"iPad7,12"])  return @"iPad 7";
//if ([platform isEqualToString:@"iPad8,1"])  return @"iPad Pro (11-inch) ";
//if ([platform isEqualToString:@"iPad8,2"])  return @"iPad Pro (11-inch) ";
//if ([platform isEqualToString:@"iPad8,3"])  return @"iPad Pro (11-inch) ";
//if ([platform isEqualToString:@"iPad8,4"])  return @"iPad Pro (11-inch) ";
//if ([platform isEqualToString:@"iPad8,5"])  return @"iPad Pro 3 (12.9-inch) ";
//if ([platform isEqualToString:@"iPad8,6"])  return @"iPad Pro 3 (12.9-inch) ";
//if ([platform isEqualToString:@"iPad8,7"])  return @"iPad Pro 3 (12.9-inch) ";
//if ([platform isEqualToString:@"iPad8,8"])  return @"iPad Pro 3 (12.9-inch) ";
//if ([platform isEqualToString:@"iPad11,1"])  return @"iPad mini 5";
//if ([platform isEqualToString:@"iPad11,2"])  return @"iPad mini 5";
//if ([platform isEqualToString:@"iPad11,3"])  return @"iPad Air 3";
//if ([platform isEqualToString:@"iPad11,4"])  return @"iPad Air 3";
//
//// 其他
//if ([platform isEqualToString:@"i386"])   return @"iPhone Simulator";
//if ([platform isEqualToString:@"x86_64"])  return @"iPhone Simulator";


@implementation CPUUsageInfo

@end

CPU_TYPE GetCPUType()
{
    static CPU_TYPE cpu_type = CPU_TYPE_UNKNOW;
    static dispatch_once_t onceToken;
    
    
    dispatch_once(&onceToken, ^{
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *phoneType = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
        NSString *deviceLevel = [phoneType stringByReplacingOccurrencesOfString:@"iPhone" withString:@""];
        deviceLevel = [deviceLevel stringByReplacingOccurrencesOfString:@"iPad" withString:@""];
        deviceLevel = [deviceLevel stringByReplacingOccurrencesOfString:@"iPod" withString:@""];
        float deviceLevelValue = [deviceLevel floatValue];
        if ([phoneType containsString:@"iPhone"]) {
            if (deviceLevelValue >= 13.0) {
                cpu_type = CPU_TYPE_UpperThanA13;
            } else if (deviceLevelValue >= 12.0)
            {
                cpu_type = CPU_TYPE_A13_APPLE;
            }else if (deviceLevelValue >= 11.0)
            {
                cpu_type = CPU_TYPE_A12_APPLE;
            }else if (deviceLevelValue >= 10.0)
            {
                cpu_type = CPU_TYPE_A11_APPLE;
            }else if (deviceLevelValue >= 9.0)
            {
                cpu_type = CPU_TYPE_A10_APPLE;
            }else if (deviceLevelValue >= 8.0)
            {
                cpu_type = CPU_TYPE_A9_APPLE;
            }else if (deviceLevelValue >= 7.0)
            {
                cpu_type = CPU_TYPE_A8_APPLE;
            }else if (deviceLevelValue >= 6.0)
            {
                cpu_type = CPU_TYPE_A7_APPLE;
            }else if (deviceLevelValue >= 5.0)
            {
                cpu_type = CPU_TYPE_A6_APPLE;
            }else if (deviceLevelValue >= 4.0)
            {
                cpu_type = CPU_TYPE_A5_APPLE;
            }else if (deviceLevelValue >= 3.0)
            {
                cpu_type = CPU_TYPE_A4_APPLE;
            }else{
                cpu_type = CPU_TYPE_LowerThanA4;
            }
        }else if ([phoneType containsString:@"iPad"])
        {
            if (deviceLevelValue >= 11.0) {
                cpu_type = CPU_TYPE_A13_APPLE;
            } else if (deviceLevelValue >= 9.0)
            {
                cpu_type = CPU_TYPE_UNKNOW;
            }else if (deviceLevelValue >= 8.0)
            {
                cpu_type = CPU_TYPE_A11X_A12X_APPLE;
            }else if (deviceLevelValue >= 7.0)
            {
                cpu_type = CPU_TYPE_A10_A10X_APPLE;
            }else if (deviceLevelValue >= 6.0)
            {
                cpu_type = CPU_TYPE_A9X_APPLE;
            }else if (deviceLevelValue >= 5.0)
            {
                cpu_type = CPU_TYPE_A8X_APPLE;
            }else if (deviceLevelValue >= 4.0)
            {
                cpu_type = CPU_TYPE_A7_APPLE;
            }else if (deviceLevelValue >= 3.0)
            {
                cpu_type = CPU_TYPE_A5X_A6X_APPLE;
            }else if (deviceLevelValue >= 2.0)
            {
                cpu_type = CPU_TYPE_A5_APPLE;
            }else if (deviceLevelValue >= 4.0)
            {
                cpu_type = CPU_TYPE_A5_APPLE;
            }else if (deviceLevelValue >= 1.0)
            {
                cpu_type = CPU_TYPE_A4_APPLE;
            }else{
                cpu_type = CPU_TYPE_LowerThanA4;
            }
        }
        else if ([phoneType containsString:@"iPod"])
        {
            if (deviceLevelValue >= 10.0)
            {
                cpu_type = CPU_TYPE_UNKNOW;
            }
            else if (deviceLevelValue >= 9.0)
            {
                cpu_type = CPU_TYPE_A10_APPLE;
            }
            else if (deviceLevelValue >= 7.0)
            {
                cpu_type = CPU_TYPE_A8_APPLE;
            }
            else if (deviceLevelValue >= 5.0)
            {
                cpu_type = CPU_TYPE_A5_APPLE;
            }
            else if (deviceLevelValue >= 4.0)
            {
                cpu_type = CPU_TYPE_A5_APPLE;
            }
            else
            {
                cpu_type = CPU_TYPE_LowerThanA4;
            }
        }else
        {
            if ([phoneType containsString:@"i386"]) {
                cpu_type = CPU_TYPE_I386_SIMULATOR;
            }else if ([phoneType containsString:@"x86_64"])
            {
                cpu_type = CPU_TYPE_X64_SIMULATOR;
            }else
            {
                cpu_type = CPU_TYPE_UNKNOW;
            }
        }
    });
    
    #ifdef DEBUG
        cpu_type = CPU_TYPE_UpperThanA13;
    #endif

    return cpu_type;
}

//总可用内存 = free 未被分配过的内存 + inactive的内存（刚刚退出或者切换到后台的进程使用过，等待变成free）
float GetAvailabelMemorySize(){
    if (sizeof(void*) == 4) {
        NSLog(@"32-bit App");
        //32位系统API
        vm_statistics_data_t vmStats;
        mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
        kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO,(host_info_t)&vmStats, &infoCount);
        if (kernReturn != KERN_SUCCESS) {
            return 0.0;
        }
        return ((vm_page_size * (vmStats.free_count + vmStats.inactive_count)) / 1024.0f) / 1024.0f;
    } else if (sizeof(void*) == 8) {
        //64位系统API
        NSLog(@"64-bit App");
        vm_statistics64_data_t vmStats;
        mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
        kern_return_t kernReturn = host_statistics64(mach_host_self(), HOST_VM_INFO,(host_info64_t)&vmStats, &infoCount);
        if (kernReturn != KERN_SUCCESS) {
            return 0.0;
        }
        return ((vm_page_size * (vmStats.free_count + vmStats.inactive_count)) / 1024.0f) / 1024.0f;
    }
    return 0.0f;
}

float GetFreeMemorySize()
{
    if (sizeof(void*) == 4) {
        NSLog(@"32-bit App");
        //32位系统API
        vm_statistics_data_t vmStats;
        mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
        kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO,(host_info_t)&vmStats, &infoCount);
        if (kernReturn != KERN_SUCCESS) {
            return 0.0;
        }
        return ((vm_page_size * (vmStats.free_count)) / 1024.0f) / 1024.0f;
    } else if (sizeof(void*) == 8) {
        //64位系统API
        NSLog(@"64-bit App");
        vm_statistics64_data_t vmStats;
        mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
        kern_return_t kernReturn = host_statistics64(mach_host_self(), HOST_VM_INFO,(host_info64_t)&vmStats, &infoCount);
        if (kernReturn != KERN_SUCCESS) {
            return 0.0;
        }
        return ((vm_page_size * (vmStats.free_count)) / 1024.0f) / 1024.0f;
    }
    return 0.0f;
}

//获取设备级别的CPU占用率
void GetDeviceLevelCPUusage(CPUInfoResultBlock resultBlock)
{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            while (locked) {
                usleep(16 * 1000);
            }
            locked = true;
            int mib[2U] = { CTL_HW, HW_NCPU };
            NSLog(@"CPUUsage Begin %F",CFAbsoluteTimeGetCurrent());
            processor_info_array_t cpuInfo = NULL;
            mach_msg_type_number_t numCPUInfo = TASK_BASIC_INFO_COUNT;
            unsigned numCPUs;
            float cpuusageRes = 0.0;
            size_t sizeOfNumCPUs = sizeof(numCPUs);
            int _status = sysctl(mib, 2U, &numCPUs, &sizeOfNumCPUs, NULL, 0U);
            if(_status)
                numCPUs = 1;
            natural_t numCPUsU = 0U;
            kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &numCPUsU, &cpuInfo, &numCPUInfo);
            NSMutableArray *arrayOfCPUInfo = [NSMutableArray arrayWithCapacity:numCPUs];
            
            integer_t inUseCPUResource = 0, totalCPUResource = 0;
            if(err == KERN_SUCCESS) {
                for(unsigned i = 0U; i < numCPUs; ++i) {
                    float usage;
                    integer_t inUse, total;
                    if (prevCPUInfo) {
                        inUse = (
                                  (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                                  + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                                  + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                                  );
                        total = inUse + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
                    }
                    else
                    {
                        //获取每一个CPU的使用率
                        inUse = cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                        total = inUse + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
                    }
                    usage = inUse / (float)total;
                    if (isnan(usage)) {
                        usage = 1.0;
                    }
                    inUseCPUResource += inUse;
                    totalCPUResource += total;
                    NSLog(@"Core : %u, Usage: %.2f%%", i, inUse / (float)total * 100.f);
                    CPUUsageInfo *usageInfo = [CPUUsageInfo new];
                    usageInfo.cpuIndex = i;
                    usageInfo.cpuUsage = usage;
                    usageInfo.totalUnit = total;
                    usageInfo.usedUnit = inUse;
                    [arrayOfCPUInfo addObject:usageInfo];
                }
                
                if (totalCPUResource == 0.0f) {
                    totalCPUResource = inUseCPUResource;
                }
                
                cpuusageRes = inUseCPUResource / (float)totalCPUResource;
                
                if (resultBlock) {
                    if (isnan(cpuusageRes)) {
                        cpuusageRes = 1.0f;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        resultBlock(cpuusageRes,arrayOfCPUInfo);
                    });
                }
                if(prevCPUInfo) {
                    size_t prevCpuInfoSize = sizeof(integer_t) * numPrevCPUInfo;
                    vm_deallocate(mach_task_self(), (vm_address_t)prevCPUInfo, prevCpuInfoSize);
                }
                
                prevCPUInfo = cpuInfo;
                numPrevCPUInfo = numCPUInfo;
                NSLog(@" numCPUs %d cpuusageRes %f",numCPUs,cpuusageRes / numCPUs);
                NSLog(@"CPUUsage End %F",CFAbsoluteTimeGetCurrent());
            } else {
                //        NSLog(@"Error!");
                if (resultBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        resultBlock(0.0f,nil);
                    });
                }
            }
            locked = false;
        });
}

float GetCurrentProcessLevelCPUusage(){
    
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1.0;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // 获取当前进程的全部线程信息
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
//    long tot_sec = 0;
//    long tot_usec = 0;
    float tot_cpu = 0;
    
    //统计每一个线程占用的CPU资源数量
    for (int j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
//            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
//            tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    }
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    return tot_cpu;
}

float GetCurrentProcessMemoryUsage(){
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    return (kerr == KERN_SUCCESS) ? (info.resident_size / 1024.0) / 1024.0 : 1024.0; // size in bytes
}
