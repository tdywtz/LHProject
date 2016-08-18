//
//  AFHTTPSessionManager+CachePolicy.h
//  12365auto
//
//  Created by bangong on 16/4/8.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface AFHTTPSessionManager (CachePolicy)

/**
*  GET（缓存策略）数据
*
*  @param URLString   网址
*  @param CachePolicy 缓存策略
*  @param success     成功回调
*  @param failure     失败回调
*
*  @return NSURLSessionDataTask
*/
- (NSURLSessionDataTask *_Nonnull)GET:(NSString * _Nonnull)URLString
                          CachePolicy:(NSURLRequestCachePolicy)CachePolicy
                             progress:(void (^ _Nonnull)(NSProgress * _Nonnull downloadProgress))downloadProgress
                              success:(void (^ _Nonnull)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                              failure:(void (^ _Nonnull)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;
@end
