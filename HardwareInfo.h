//
//  HardwareInfo.h
//  TMSearchUI
//
//  Created by 熊韦华 on 2020/2/17.
//

#import <Foundation/Foundation.h>


//单独每一个处理器核心的使用情况
@interface CPUUsageInfo : NSObject

@property (nonatomic, assign) int cpuIndex; //当前CPU序号
@property (nonatomic, assign) float cpuUsage; //当前CPU占用率
@property (nonatomic, assign) int usedUnit; //当前CPU被计算资源单元数
@property (nonatomic, assign) int totalUnit;//当前CPU总计算资源单元数

@end

/*
 totalUsage 整体所有处理器核心的占用率
 cpusUsage 每一个核心的使用状况
 */
typedef void(^CPUInfoResultBlock)(float totalUsage,NSArray<CPUUsageInfo *> *cpusUsage);

//iOS设备的处理器等级类型。。枚举值越高，CPU等级越高
typedef NS_ENUM(NSInteger, CPU_TYPE) {
    CPU_TYPE_UNKNOW = 0,
    CPU_TYPE_X64_SIMULATOR,
    CPU_TYPE_I386_SIMULATOR,
    CPU_TYPE_LowerThanA4,
    CPU_TYPE_A4_APPLE,
    CPU_TYPE_A5_APPLE,
    CPU_TYPE_A6_APPLE,
    CPU_TYPE_A5X_A6X_APPLE,
    CPU_TYPE_A7_APPLE,
    CPU_TYPE_A8_APPLE,
    CPU_TYPE_A8X_APPLE,
    CPU_TYPE_A9_APPLE,
    CPU_TYPE_A9X_APPLE,
    CPU_TYPE_A10_APPLE,
    CPU_TYPE_A10_A10X_APPLE,
    CPU_TYPE_A11_APPLE,
    CPU_TYPE_A12_APPLE,
    CPU_TYPE_A11X_A12X_APPLE,
    CPU_TYPE_A13_APPLE,
    CPU_TYPE_UpperThanA13
};
/*
 获取当前设备处理器类型
 */
CPU_TYPE GetCPUType();

/*
 获取可用内存容量，单位MB
 可用内存包括 自由内存 和 后台进程被系统设置为墓碑状态下占用的非活跃内存
 这个表明当前app不引起收到内存警告的情况下，可以继续使用的内存容量
 */
float GetAvailabelMemorySize();
/*
 获得处于自由状态的内存容量
 使用处于自由状态的内存不会影响用户切回之前被调动到后台的所占用的内存被设置为inactive状态的app
 进一步的内存用量限制在这个数值内，可以避免因为当前app的操作，使得后台的应用被系统杀掉
 需要考虑到要避免引起其他后台墓碑状态的进程被系统彻底杀掉，导致用户切换到其他APP需要从外存重新载入的情景下，应当使用GetFreeMemorySize()获取的数值作为当前的可用内存大小
*/
float GetFreeMemorySize();
/*
 获得当前进程内存消耗
*/
float GetCurrentProcessMemoryUsage();
/*
 获得当前设备级别的CPU占用率
 这中间的操作非常消耗处理器资源，并且该操作在主线程执行有可能引起UI异常
 所以为了避免误操作引起体验或者功能异常，这里只提供异步版本的API
 如果想刷新获得处理器占用，最好使用定时轮训的方式更新
*/
void GetDeviceLevelCPUusage(CPUInfoResultBlock resultBlock);
/*
 获得当前进程级别的CPU占用率
*/
float GetCurrentProcessLevelCPUusage();
