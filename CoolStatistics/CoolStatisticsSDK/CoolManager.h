//
//  CoolManager.h
//  CoolStatistics
//
//  Created by ian on 15/4/17.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const cool_event;
extern NSString *const cool_time;
extern NSString *const cool_appKey;
extern NSString *const cool_deviceinfo;
extern NSString *const cool_systeminfo;
extern NSString *const cool_identifier;
extern NSString *const cool_eventid;
extern NSString *const cool_eventbegintime;
extern NSString *const cool_eventendtime;
extern NSString *const cool_channelId;
extern NSString *const cool_appversion;

@interface CoolManager : NSObject
{
    NSTimer *_timer;
}
@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, strong) NSMutableDictionary *eventDic;
@property (nonatomic, strong) NSMutableDictionary *eventBoolDic;
@property (nonatomic, strong) NSMutableArray *coolMutableArray;

+ (instancetype)shareInstance;

- (void)batchNotification;
- (void)sendIntervalNotification;
- (void)sendOnExitNotification;
@end
