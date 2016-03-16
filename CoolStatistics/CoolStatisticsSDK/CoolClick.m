//
//  CoolClick.m
//  CoolStatistics
//
//  Created by ian on 15/4/16.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoolClick.h"
#import "NetworkService.h"
#import "CoolManager.h"
@implementation CoolClick

#pragma mark - 开启统计

+ (void)startWithAppkey:(NSString *)appKey
{
    [self startWithAppkey:appKey reportPolicy:BATCH channelId:nil];
}

+ (void)startWithAppkey:(NSString *)appKey reportPolicy:(ReportPolicy)rp channelId:(NSString *)cid
{
    if (!cid) {
        cid = @"appStore";
    }
    // 记录appKey
    [CoolManager shareInstance].appKey = appKey;
    [CoolManager shareInstance].cid = cid;
    if(rp == BATCH){
        [[CoolManager shareInstance] batchNotification];
    }else if(rp == SEND_INTERVAL){
        [[CoolManager shareInstance] sendIntervalNotification];
    }else if (rp == SEND_ON_EXIT){
        [[CoolManager shareInstance] sendOnExitNotification];
    }
}

# pragma mark - 事件统计
+ (void)event:(NSString *)eventId
{
    [self event:eventId setUnixTime:@""];
}

+ (void)beginEvent:(NSString *)eventId
{
    ([CoolManager shareInstance].eventBoolDic)[eventId] = [self UnixTime];
}

+ (void)endEvent:(NSString *)eventId
{
    if (![([CoolManager shareInstance].eventBoolDic)[eventId] isEqualToString:@""]) {
        [self event:eventId setUnixTime:([CoolManager shareInstance].eventBoolDic)[eventId]];
        ([CoolManager shareInstance].eventBoolDic)[eventId] = @"";
    }
}

+ (void)event:(NSString *)eventId setUnixTime:(NSString *)time
{
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSDictionary *tempDic = nil;
    if ([time isEqualToString:@""]) {
        tempDic = @{cool_eventid : eventId,
                    cool_eventbegintime : tempDic,
                    cool_eventendtime: tempDic
                    };
    }else{
        tempDic = @{cool_eventid : eventId,
                    cool_eventbegintime : time,
                    cool_eventendtime: timeSp
                    };
    }

    [[CoolManager shareInstance].coolMutableArray addObject:tempDic];
}

#pragma mark - private method

+ (NSString *)UnixTime
{
    return [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
}

@end
