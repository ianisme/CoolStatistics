//
//  CoolClick.h
//  CoolStatistics
//
//  Created by ian on 15/4/16.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ReportPolicy) {
    BATCH,          //启动发送
    SEND_INTERVAL,  //按30秒一次发送
    SEND_ON_EXIT    //退出或进入后台时发送
};

@interface CoolClick : NSObject

///---------------------------------------------------------------------------------------
/// @name  开启统计
///---------------------------------------------------------------------------------------


/** 开启统计,默认是每次程序启动后发送上次的log.
 *
 *  @param appKey appKey.
 *  @return void
 */
+ (void)startWithAppkey:(NSString *)appKey;

/** 开启统计
 *  @param appKey appKey
 *  @param rp     log发送方式
 *  @param cid    渠道（nil为APPStore渠道）
 */
+ (void)startWithAppkey:(NSString *)appKey reportPolicy:(ReportPolicy)rp channelId:(NSString *)cid;

///---------------------------------------------------------------------------------------
/// @name  事件统计
///---------------------------------------------------------------------------------------


/** 自定义事件,数量统计.
 使用前，请先到App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
 
 @param  eventId 网站上注册的事件Id.
 @return void.
 */
+ (void)event:(NSString *)eventId;

/** 自定义事件,数量统计.
 使用前，请先到App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
**/
+ (void)beginEvent:(NSString *)eventId;

/** 自定义事件,时长统计.
 使用前，请先到App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */
+ (void)endEvent:(NSString *)eventId;

/** 自定义事件,时长统计.
 使用前，请先到App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

@end
