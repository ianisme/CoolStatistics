//
//  NetworkService.m
//  CoolStatistics
//
//  Created by ian on 15/4/15.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import "NetworkService.h"

@implementation NetworkService

+ (instancetype)shareInstance
{
    static NetworkService *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedClient = [[NetworkService alloc] init];
    });
    return sharedClient;
}

- (void)dataRequest:(NSDictionary *)parameters appKeyUrl:(NSString *)appKeyUrl startAPP:(void(^)(BOOL successful, id result))handler;
{
    [self appGet:appKeyUrl parameters:parameters handler:^(BOOL successful, NSDictionary *response) {
        handler(successful, response);
    }];
}

#pragma mark -private method-

- (void)appPost:(NSString *)url parameters:(NSDictionary *)paramsters handler:(void(^)(BOOL successful, id response))handler
{
    NSString *urlString = [COOL_BASEURL stringByAppendingString:url];
    NSURL *newUrl = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:newUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:15];
    [request setHTTPMethod:@"POST"];
    NSString *bodyString = [self convertParamsters:paramsters];
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = bodyData;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            handler(NO , connectionError);
//            NSLog(@"Httperror:%@%ld", connectionError.localizedDescription,(long)connectionError.code);
        }else{
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *responseDic = (NSDictionary *)responseString;
            handler(YES,responseDic);
//            NSLog(@"HttpResponseCode:%ld", (long)responseCode);
        }
    }];
}

- (void)appGet:(NSString *)url parameters:(NSDictionary *)paramsters handler:(void(^)(BOOL successful, id response))handler
{
    NSString *urlString = [COOL_BASEURL stringByAppendingString:[NSString stringWithFormat:@"%@?%@",url,[self convertParamsters:paramsters]]];
    NSURL *newUrl = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:newUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:15];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            handler(NO , connectionError);
            //            NSLog(@"Httperror:%@%ld", connectionError.localizedDescription,(long)connectionError.code);
        }else{
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *responseDic = (NSDictionary *)responseString;
            handler(YES,responseDic);
            //            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            //            NSLog(@"HttpResponseCode:%ld", (long)responseCode);
        }
    }];

}

/**
 *  字典参数拼接
 *
 *  @param paramsters 字典
 *
 *  @return 拼接好的参数
 */
- (NSString *)convertParamsters:(NSDictionary *)paramsters
{
    NSEnumerator *enumerator = [paramsters keyEnumerator];
    id object;
    NSMutableArray *paramstersArray = [NSMutableArray arrayWithCapacity:[paramsters count]];
    while(object = [enumerator nextObject])
    {
        id objectValue = [paramsters objectForKey:object];
        if(objectValue != nil)
        {
           // NSLog(@"%@所对应的value是 %@",object,objectValue);
            [paramstersArray addObject:[NSString stringWithFormat:@"%@=%@",object,objectValue]];
        }
    }
    NSString *tempString = [paramstersArray componentsJoinedByString:@"&"];
    return tempString;
}

/**
 *  JSION上传方法
 *
 *  @param URLString 请求地址
 *  @param jsonData  JSON数据
 *  @param handler   回调操作
 */
- (void)upload:(NSString *)URLString JSONData:(id)jsonData handler:(void (^)(BOOL success, id responseObject))handler
{
    NSURL *url = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonData options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = data;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            handler(NO , connectionError);
            //            NSLog(@"Httperror:%@%ld", connectionError.localizedDescription,(long)connectionError.code);
        }else{
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *responseDic = (NSDictionary *)responseString;
            handler(YES,responseDic);
            //            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            //            NSLog(@"HttpResponseCode:%ld", (long)responseCode);
        }
    }];
}

@end
