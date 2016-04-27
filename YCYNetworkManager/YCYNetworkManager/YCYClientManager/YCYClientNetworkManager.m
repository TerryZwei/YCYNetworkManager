//
//  YCYClientNetworkManager.m
//  YCYNetworkManager
//
//  Created by terry on 16/4/27.
//  Copyright © 2016年 terry. All rights reserved.
//

#import "YCYClientNetworkManager.h"
#import "NSObject+CacheFile.h"

static YCYClientNetworkManager *_sharedClient = nil;
static dispatch_once_t onceToken;

@implementation YCYClientNetworkManager
+ (instancetype)sharedInstance
{
    dispatch_once(&onceToken, ^{
        //设置baseUrl
        _sharedClient = [[YCYClientNetworkManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    });
    return _sharedClient;
}
/**
 *  请求配置
 */
- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    //返回结果处理
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    //请求10秒超时
    self.requestSerializer.timeoutInterval = 10;
    //请求参数用json格式
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
    self.securityPolicy.allowInvalidCertificates = YES;
    
    return self;
    
}

- (void)Get:(NSString *)aPath withParams:(NSDictionary*)params withCacheDuration:(NSInteger)cacheTimeSeconds andBlock:(void (^)(id data, NSError *error))block
{
    NSString *combinedURL = [aPath stringByAppendingString:[self serializeParams:params]];
    NSDictionary *cacheResponseData = [[NSObject loadCacheFileDataWithPath:combinedURL] mutableCopy];
    NSTimeInterval currentTime = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]*1000;
    
    if (cacheTimeSeconds > 0 && (cacheResponseData && [cacheResponseData[@"cacheTime"] doubleValue] > currentTime) && (cacheResponseData[@"code"] && [cacheResponseData[@"code"] intValue] == 0)) {
        NSLog(@"%.0f---%.0f",[cacheResponseData[@"cacheTime"] doubleValue],currentTime);
        //读取缓存
        block(cacheResponseData,nil);
        return;
    } else {
        //请求网络
        [self GET:aPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (cacheTimeSeconds > 0) {
                NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
                //当前时间戳
                NSTimeInterval cacheExprieTime = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]*1000+cacheTimeSeconds*1000;
                //                NSInteger timestap = round(cacheExprieTime);
                NSString *timestap = [NSString stringWithFormat:@"%.0f",cacheExprieTime];
                [tempDict setObject:timestap  forKey:@"cacheTime"];
                //保存到当前缓存文件
                [NSObject saveResponseData:tempDict toPath:combinedURL];
            }
            block(responseObject,nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block(nil, error);
        }];
    }
    
}

- (void)Post:(NSString *)aPath withParams:(NSDictionary*)params withbuiltParams:(NSDictionary *)requestParams andBlock:(void (^)(id data, NSError *error))block
{
    NSString *combinedURL = [aPath stringByAppendingString:[self serializeParams:requestParams]];
    [self POST:combinedURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}


- (NSString *)serializeParams:(NSDictionary *)params {
    NSMutableArray *parts = [NSMutableArray array];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id<NSObject> obj, BOOL *stop) {
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSString *encodedValue = [obj.description stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject: part];
    }];
    NSString *queryString = [parts componentsJoinedByString: @"&"];
    return queryString ? [NSString stringWithFormat:@"?%@", queryString] : @"";
}

@end
