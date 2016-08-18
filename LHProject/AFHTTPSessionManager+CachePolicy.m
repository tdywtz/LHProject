//
//  AFHTTPSessionManager+CachePolicy.m
//  12365auto
//
//  Created by bangong on 16/4/8.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "AFHTTPSessionManager+CachePolicy.h"

@implementation AFHTTPSessionManager (CachePolicy)
/**
 *  get数据
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
                             progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                              success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                              failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;{
    //汉子处理
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:@"GET" URLString:URLString parameters:nil CachePolicy:CachePolicy uploadProgress:nil downloadProgress:downloadProgress success:success failure:failure];
    
   
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                     CachePolicy:(NSURLRequestCachePolicy)CachePolicy
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    request.cachePolicy = CachePolicy;
    
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request
                          uploadProgress:uploadProgress
                        downloadProgress:downloadProgress
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                           if (error) {
                               if (failure) {
                                   failure(dataTask, error);
                               }
                           } else {
                               if (success) {
                                   success(dataTask, responseObject);
                               }
                           }
                       }];
    
    return dataTask;
}

@end
