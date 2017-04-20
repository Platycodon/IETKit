//
//  IETNetClient.h
//  CXNT
//
//  Created by Lucifer on 16/9/19.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IETNetClient : NSObject

+ (nonnull instancetype)sharedObject;

NS_ASSUME_NONNULL_BEGIN


/**
 常用post请求

 @param url     接口地址，统一用完整，带json
 @param params  post参数
 @param success 成功回调
 @param failure 失败回调，服务器返回的请求失败也算在内

 @return task
 */
- (nullable NSURLSessionDataTask *)POSTWithUrl:(NSString *)url
                               params:(NSDictionary *)params
                              success:(void (^)(id _Nullable responseObject, NSString *message))success
                              failure:(void (^)(NSError * _Nonnull error))failure;
- (nullable NSURLSessionDataTask *)POSTWithUrl:(NSString *)url
                                    RESTfulKey:(NSString *)key
                                        params:(NSDictionary *)params
                                       success:(void (^)(id _Nullable responseObject, NSString *message))success
                                       failure:(void (^)(NSError * _Nonnull error))failure;
- (nullable NSURLSessionDataTask *)POSTWithUrl:(NSString *)url
                                   RESTfulKeys:(NSArray<NSString *> *)keys
                                        params:(NSDictionary *)params
                                       success:(void (^)(id _Nullable responseObject, NSString *message))success
                                       failure:(void (^)(NSError * _Nonnull error))failure;


/**
 常用get请求

 @param url     接口地址，统一用完整，带json
 @param params  接口地址，统一用完整，带json
 @param success 成功回调
 @param failure 失败回调，服务器返回的请求失败也算在内

 @return task
 */
- (nullable NSURLSessionDataTask * )GETWithUrl:(NSString *)url
                              params:(NSDictionary *)params
                             success:(void (^)(id _Nullable responseObject, NSString *message))success
                             failure:(void (^)(NSError * _Nonnull error))failure;


/**
 支持RESTful格式的get请求

 @param url     接口地址，统一用完整，带json
 @param key     RESTful的primary key 的字段名，参数value会从params中自动匹配
 @param params  参数，包括RESTful中primary key 的键值对
 @param success 成功回调
 @param failure 失败回调，服务器返回的请求失败也算在内

 @return task
 */
- (nullable NSURLSessionDataTask * )GETWithUrl:(NSString *)url
                                    RESTfulKey:(NSString *)key
                                        params:(NSDictionary *)params
                                       success:(void (^)(id _Nullable responseObject, NSString *message))success
                                       failure:(void (^)(NSError * _Nonnull error))failure;

- (nullable NSURLSessionDataTask * )GETWithUrl:(NSString *)url
                                   RESTfulKeys:(NSArray<NSString *> *)keys
                                        params:(NSDictionary *)params
                                       success:(void (^)(id _Nullable responseObject, NSString *message))success
                                       failure:(void (^)(NSError * _Nonnull error))failure;


/**
 常用delete请求

 @param url     接口地址，统一用完整，带json
 @param params  delete参数
 @param success 成功回调
 @param failure 失败回调，服务器返回的请求失败也算在内

 @return task
 */
- (nullable NSURLSessionDataTask * )DELETEWithUrl:(NSString *)url
                                 params:(NSDictionary *)params
                                success:(void (^)(id _Nullable responseObject, NSString *message))success
                                failure:(void (^)(NSError * _Nonnull error))failure;
- (nullable NSURLSessionDataTask * )DELETEWithUrl:(NSString *)url
                                    RESTfulKey:(NSString *)key
                                        params:(NSDictionary *)params
                                       success:(void (^)(id _Nullable responseObject, NSString *message))success
                                       failure:(void (^)(NSError * _Nonnull error))failure;
- (nullable NSURLSessionDataTask * )DELETEWithUrl:(NSString *)url
                                      RESTfulKeys:(NSArray<NSString *> *)keys
                                           params:(NSDictionary *)params
                                          success:(void (^)(id _Nullable responseObject, NSString *message))success
                                          failure:(void (^)(NSError * _Nonnull error))failure;


/**
 常用put请求

 @param url     接口地址，统一用完整，带json
 @param params  put参数
 @param success 成功回调
 @param failure 失败回调，服务器返回的请求失败也算在内

 @return task
 */
- (nullable NSURLSessionDataTask * )PUTWithUrl:(NSString *)url
                              params:(NSDictionary *)params
                             success:(void (^)(id _Nullable responseObject, NSString *message))success
                             failure:(void (^)(NSError * _Nonnull error))failure;
- (nullable NSURLSessionDataTask * )PUTWithUrl:(NSString *)url
                                    RESTfulKey:(NSString *)key
                                        params:(NSDictionary *)params
                                       success:(void (^)(id _Nullable responseObject, NSString *message))success
                                       failure:(void (^)(NSError * _Nonnull error))failure;

- (nullable NSURLSessionDataTask *)PUTWithUrl:(NSString *)url
                         RESTfulKeys:(NSArray *)keys
                              params:(NSDictionary *)params
                             success:(void (^)(id _Nullable responseObject, NSString *message))success
                             failure:(void (^)(NSError * _Nonnull error))failure;


/**
 从本地上传单个文件

 @param filePath 所需上传的文件的path
 @param url      上传接口
 @param params   参数
 @param progress 上传进度回调
 @param success  成功回调
 @param failure  失败回调，服务器返回的请求失败也算在内

 @return task
 */
- (nullable NSURLSessionDataTask * )uploadFile:(NSString *)filePath
                                 toUrl:(NSString *)url
                                params:(NSDictionary *)params
                              progress:(void (^)(NSProgress * _Nonnull))progress
                               success:(void (^)(id _Nullable responseObject, NSString *message))success
                               failure:(void (^)(NSError * _Nonnull error))failure;


/**
 从本地上传多个文件

 @param filePaths 所需上传的所有文件的path组成的数组
 @param url       上传接口
 @param params    参数
 @param progress  上传进度回调
 @param success   成功回调
 @param failure   失败回调，服务器返回的请求失败也算在内

 @return task
 */
- (nullable NSURLSessionDataTask * )uploadFiles:(NSArray<NSString *> *)filePaths
                                 toUrl:(NSString *)url
                                params:(NSDictionary *)params
                              progress:(void (^)(NSProgress * _Nonnull))progress
                               success:(void (^)(id _Nullable responseObject, NSString *message))success
                               failure:(void (^)(NSError * _Nonnull error))failure;

- (nullable NSURLSessionDataTask * )uploadImage:(UIImage *)image
                                           toUrl:(NSString *)url
                                          params:(NSDictionary *)params
                                        progress:(void (^)(NSProgress * _Nonnull))progress
                                         success:(void (^)(id _Nullable responseObject, NSString *message))success
                                         failure:(void (^)(NSError * _Nonnull error))failure;

- (nullable NSURLSessionDataTask * )uploadImages:(NSArray<UIImage *> *)images
                                          toUrl:(NSString *)url
                                         params:(NSDictionary *)params
                                       progress:(void (^)(NSProgress * _Nonnull))progress
                                        success:(void (^)(id _Nullable responseObject, NSString *message))success
                                        failure:(void (^)(NSError * _Nonnull error))failure;

/**
 下载图片
 */
- (nullable NSURLSessionDownloadTask * )downloadFromUrl:(NSString *)url
                                           topath:(NSString *)path
                                         progress:(void (^)(NSProgress * _Nonnull))progress
                                          success:(void (^)(NSURL * _Nullable filePath, NSString *message))success
                                          failure:(void (^)(NSError * _Nonnull error))failure;


NS_ASSUME_NONNULL_END

@end









