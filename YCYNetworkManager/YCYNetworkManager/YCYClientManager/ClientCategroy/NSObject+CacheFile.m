//
//  NSObject+CacheFile.m
//  YCYNetworkManager
//
//  Created by terry on 16/4/27.
//  Copyright © 2016年 terry. All rights reserved.
//
#define responseCachePath @"responseCache"
#import "NSObject+CacheFile.h"
#import "NSString+MD5.h"

@implementation NSObject (CacheFile)
+ (NSString *)pathInCacheDirectory:(NSString *)fileName
{
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cachePaths objectAtIndex:0];
    return [cachePath stringByAppendingPathComponent:fileName];
}
//创建缓存文件夹
+ (BOOL) createDirInCache:(NSString *)dirName
{
    NSString *dirPath = [self pathInCacheDirectory:dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    BOOL isCreated = NO;
    if ( !(isDir == YES && existed == YES) )
    {
        isCreated = [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (existed) {
        isCreated = YES;
    }
    return isCreated;
}

+ (BOOL)saveResponseData:(NSDictionary *)responseData toPath:(NSString *)requestPath
{
    if (responseData && requestPath) {
        if ([self createDirInCache:responseCachePath]) {
            NSString *cachePath = [NSString stringWithFormat:@"%@/%@.plist",[self pathInCacheDirectory:responseCachePath],[requestPath MD5]];
            return [responseData writeToFile:cachePath atomically:YES];
        } else {
            return NO;
        }
        
    } else {
        return NO;
    }
}

+ (id)loadCacheFileDataWithPath:(NSString *)requestPath
{
    if (requestPath) {
        NSString *cachePath = [NSString stringWithFormat:@"%@/%@.plist",[self pathInCacheDirectory:responseCachePath],[requestPath MD5]];
        return [NSMutableDictionary dictionaryWithContentsOfFile:cachePath];
    } else {
        return nil;
    }
}

@end
