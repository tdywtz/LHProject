//
//  HttpRequestManger.m
//  lhproject
//
//  Created by bangong on 16/3/24.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "HttpRequestManger.h"
#import <AFNetworking.h>
#import "AFHTTPSessionManager+CachePolicy.h"
#import <netinet/in.h>

@implementation HttpRequestManger

+(BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        // printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}


+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                     progress:(void (^)(NSProgress * _Nonnull downloadProgress))progress
                      success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                      failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure{
  
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",@"text/plain",@"text/html",@"application/x-javascript", nil];
    
  return   [manager GET:URLString parameters:parameters progress:progress success:success failure:failure];
}

/**get数据*/
+ (NSURLSessionDataTask *)GET:(NSString *)URLString
    success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
    failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",@"text/plain",
                                                         @"text/html",@"application/x-javascript", nil];
    
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   
    NSURLRequestCachePolicy policy = NSURLRequestReturnCacheDataElseLoad;//取本地缓存
    if ([self connectedToNetwork]) {
        /**
          默认的缓存策略， 如果缓存不存在，直接从服务端获取。
          如果缓存存在，会根据response中的Cache-Control字段判断下一步操作，
          如: Cache-Control字段为must-revalidata, 则询问服务端该数据是否有更新，
          无更新的话直接返回给用户缓存数据，若已更新，则请求服务端.
         */
        policy = NSURLRequestUseProtocolCachePolicy;
    }
    NSURLSessionDataTask *dataTask = [manager GET:URLString CachePolicy:policy progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         failure(task,error);
    }];
    return dataTask;
    
}

/**post数据*/
+ (NSURLSessionDataTask *)POST:(NSString *)URLString
  parameters:(NSDictionary *)parameters
     success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
     failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",@"text/plain",@"text/html",@"application/x-javascript", nil];
    return  [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
}

/**上传图片*/
+ (NSURLSessionDataTask *)POST:(NSString *)URLString
  parameters:(NSDictionary *)parameters
      images:(NSArray <__kindof UIImage *> *)images
     success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
     failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",@"text/plain",@"text/html",@"application/x-javascript", nil];
   return  [manager POST:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0;i < images.count ; i++) {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            
            NSString *name = [NSString stringWithFormat:@"%d",i];
            NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg", str,i];
            NSData *date = UIImageJPEGRepresentation(images[i], 1);
            [formData appendPartWithFileData:date name:name fileName:fileName mimeType:@"image/jpg/file"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
}

@end
