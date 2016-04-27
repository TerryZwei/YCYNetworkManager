//
//  NSObject+CacheFile.h
//  YCYNetworkManager
//
//  Created by terry on 16/4/27.
//  Copyright © 2016年 terry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CacheFile)
/**
 *  保存网络请求数据到缓存文件
 */
+ (BOOL)saveResponseData:(NSDictionary *)responseData toPath:(NSString *)requestPath;
/**
 *  读取缓存文件的数据
 */
+ (id)loadCacheFileDataWithPath:(NSString *)requestPath;
@end
