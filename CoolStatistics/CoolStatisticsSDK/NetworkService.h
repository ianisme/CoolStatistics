//
//  NetworkService.h
//  CoolStatistics
//
//  Created by ian on 15/4/15.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define COOL_BASEURL @"http://www.baidu.com/"
#define COOL_UPLOADURL @"http://www.baidu.com/"
#define COOL_START_EVENT @"DigitalPublication/publish/Handler/APINewsList.ashx"
@interface NetworkService : NSObject

+ (instancetype)shareInstance;

- (void)dataRequest:(NSDictionary *)parameters appKeyUrl:(NSString *)appKeyUrl startAPP:(void(^)(BOOL successful, id result))handler;
- (void)upload:(NSString *)URLString JSONData:(id)jsonData handler:(void (^)(BOOL success, id result))handler;
@end
