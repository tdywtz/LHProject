//
//  HttpRequestManger.h
//  lhproject
//
//  Created by bangong on 16/3/24.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequestManger : NSObject
+ (NSURLSessionDataTask *_Nullable)GET:(NSString *_Nonnull)URLString
                            parameters:(id _Nullable)parameters
                              progress:(void (^ _Nullable)(NSProgress * _Nonnull downloadProgress))progress
                               success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                               failure:(void (^ _Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;


/**
 *  get数据
 *
 *  @param URLString 网址
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (NSURLSessionDataTask * _Nonnull)GET:(NSString * _Nonnull)URLString
                               success:(void (^ _Nonnull)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                               failure:(void (^ _Nonnull)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;
/**
 *  post数据
 *
 *  @param URLString  网址
 *  @param parameters 数据字典
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (NSURLSessionDataTask * _Nonnull)POST:(NSString * _Nonnull)URLString
                             parameters:(NSDictionary * _Nonnull)parameters
                                success:(void (^ _Nonnull)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                                failure:(void (^ _Nonnull)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;
/**
 *  批量上传图片
 *
 *  @param URLString  网址
 *  @param parameters 数据字典
 *  @param images     图片数组
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (NSURLSessionDataTask * _Nonnull)POST:(NSString * _Nonnull)URLString
                             parameters:(NSDictionary * _Nonnull)parameters
                                 images:(NSArray <__kindof UIImage *> * _Nonnull)images
                                success:(void (^ _Nonnull)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                                failure:(void (^ _Nonnull)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;
@end
