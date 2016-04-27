//
//  YCYClientNetworkManager.h
//  YCYNetworkManager
//
//  Created by terry on 16/4/27.
//  Copyright © 2016年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>

@interface YCYClientNetworkManager : AFHTTPRequestOperationManager
+ (instancetype)sharedInstance;
/**
 *  get请求
 *
 *  @param aPath     请求地址
 *  @param params    请求带的参数
 *  @param cacheTime 缓存时间
 *  @param block     返回block
 */
- (void)Get:(NSString *)aPath withParams:(NSDictionary*)params withCacheDuration:(NSInteger)cacheTime andBlock:(void (^)(id data, NSError *error))block;
/**
 *  post请求
 *
 *  @param aPath         请求地址
 *  @param params        post所带的参数
 *  @param requestParams 请求地址带的参数
 *  @param block         返回block
 */
- (void)Post:(NSString *)aPath withParams:(NSDictionary*)params withbuiltParams:(NSDictionary *)requestParams andBlock:(void (^)(id data, NSError *error))block;
@end
