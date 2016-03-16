//
//  CoolManager.m
//  CoolStatistics
//
//  Created by ian on 15/4/17.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import "CoolManager.h"
#import "NetworkService.h"
#define XcodeAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
NSString *const cool_event          = @"event";
NSString *const cool_time           = @"time";
NSString *const cool_appKey         = @"appkey";
NSString *const cool_deviceinfo     = @"devicename";
NSString *const cool_systeminfo     = @"systemversion";
NSString *const cool_identifier     = @"idfv";
NSString *const cool_eventid        = @"eventid";
NSString *const cool_eventbegintime = @"eventbegintime";
NSString *const cool_eventendtime   = @"eventendtime";
NSString *const cool_channelId      = @"channelid";
NSString *const cool_appversion     = @"version";

@implementation CoolManager

+ (instancetype)shareInstance
{
    static CoolManager *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedClient = [[CoolManager alloc] init];
    });
    return sharedClient;
}


- (NSMutableDictionary *)eventBoolDic
{
    if (!_eventBoolDic) {
        self.eventBoolDic = [@{} mutableCopy];
    }
    return _eventBoolDic;
}

- (NSMutableDictionary *)eventDic
{
    if (!_eventDic) {
        self.eventDic = [@{} mutableCopy];
    }
    return _eventDic;
}

- (NSMutableArray *)coolMutableArray
{
    if (!_coolMutableArray) {
        _coolMutableArray = [NSMutableArray array];
    }
    return _coolMutableArray;
}

/**
 *  将本地统计的字典写入文件中
 */
- (void)writeLocalDic
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path = [docPath stringByAppendingPathComponent:@"cool.statistics"];
    
    UIDevice *device = [[UIDevice alloc] init];
    NSString *model = device.model;      //获取设备的类别
    NSString *systemVersion = device.systemVersion;//获取当前系统的版本
    NSString *identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];//获取设备唯一标示
    NSString *version = XcodeAppVersion;
    
    NSDictionary *dic = @{cool_deviceinfo : model,
                          cool_systeminfo : systemVersion,
                          cool_identifier : identifier,
                          cool_channelId  : [CoolManager shareInstance].cid,
                          cool_appversion : version,
                          cool_appKey:[CoolManager shareInstance].appKey,
                          cool_event:[CoolManager shareInstance].coolMutableArray
                          };
    [NSKeyedArchiver archiveRootObject:dic toFile:path];
}

- (NSDictionary *)readLocalDic
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path = [docPath stringByAppendingPathComponent:@"cool.statistics"];
    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSLog(@"测试一下%@",dic);
    return dic;
}

- (void)deleteLocalDic
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path = [docPath stringByAppendingPathComponent:@"cool.statistics"];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:path error:nil];
}

#pragma mark - BATCH

- (void)batchNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:[CoolManager shareInstance] selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:[CoolManager shareInstance] selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)applicationWillResignActive
{
    [self writeLocalDic];
}

- (void)applicationDidBecomeActive
{
    if (![self readLocalDic]) {
        return;
    }
    [[NetworkService shareInstance] upload:COOL_UPLOADURL JSONData:[self readLocalDic] handler:^(BOOL success, id result) {
        NSLog(@"%d",success);
        if (success) {
            [self deleteLocalDic];
        }
    }];
}

#pragma mark - SENDINTERVAL
- (void)sendIntervalNotification
{
    [self startTimer];
}

- (void)stopTimer
{
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)startTimer
{
    if (_timer) {
        [_timer setFireDate:[NSDate date]];
    }else{
        _timer = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(uploadInterval) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
}

- (void)uploadInterval
{
    UIDevice *device = [[UIDevice alloc] init];
    NSString *model = device.model;      //获取设备的类别
    NSString *systemVersion = device.systemVersion;//获取当前系统的版本
    NSString *identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];//获取设备唯一标示
    NSString *version = XcodeAppVersion;
    
    NSDictionary *dic = @{cool_deviceinfo : model,
                          cool_systeminfo : systemVersion,
                          cool_identifier : identifier,
                          cool_channelId  : [CoolManager shareInstance].cid,
                          cool_appversion : version,
                          cool_appKey:[CoolManager shareInstance].appKey,
                          cool_event:[CoolManager shareInstance].coolMutableArray
                          };

    if (!dic) {
        return;
    }
    [[NetworkService shareInstance] upload:COOL_UPLOADURL JSONData:dic handler:^(BOOL success, id result) {
        NSLog(@"%d",success);
        if (success) {
            
        }
    }];
}

#pragma mark - SENDONEXIT
- (void)sendOnExitNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:[CoolManager shareInstance] selector:@selector(sendOnExitWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)sendOnExitWillResignActive
{
    [self uploadInterval];
}

@end
