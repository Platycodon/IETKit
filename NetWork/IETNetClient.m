//
//  IETNetClient.m
//  CXNT
//
//  Created by Lucifer on 16/9/19.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "IETNetClient.h"
#import "AFNetworking.h"
#import "IETConfiguration.h"
#import "NSDate+IETAdd.h"
#import "NSString+IETAdd.h"
#import "IETSession.h"
#import "NSDictionary+IETAdd.h"

@interface IETNetClient ()

@property (nonatomic, strong) AFHTTPSessionManager *httpManager;
@property (nonatomic, strong) AFHTTPSessionManager *uploadManager;

@property (nonatomic, copy) NSString *httpHost;
@property (nonatomic, copy) NSString *uploadHost;

@end

@implementation IETNetClient
{
    NSTimeInterval _timeoutTime;
}

+ (instancetype)sharedObject
{
    static dispatch_once_t once;
    static IETNetClient *client;
    dispatch_once (&once,^{
        client = [[IETNetClient alloc] initWithHttpUrl:[IETConfiguration defaultConfiguration].httpHost
                                             uploadUrl:[IETConfiguration defaultConfiguration].uploadHost];
    });
    return client;
}


- (instancetype)initWithHttpUrl:(NSString *)httpUrl
                      uploadUrl:(NSString *)uploadUrl
{
    if (self = [super init]) {
        _timeoutTime = [IETConfiguration defaultConfiguration].requestTimeoutTime;
        _httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:httpUrl]];
        _uploadManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:uploadUrl]];
        
        AFHTTPRequestSerializer *request = [AFHTTPRequestSerializer serializer];
        request.timeoutInterval = [IETConfiguration defaultConfiguration].requestTimeoutTime;
        AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers | NSJSONReadingAllowFragments];
        
        _httpManager.requestSerializer = request;
        _httpManager.responseSerializer = response;
        
        _uploadManager.requestSerializer = request;
        _uploadManager.responseSerializer = response;
        
    }
    return self;
}



- (NSString *)tokenWithUrl:(NSString *)url
{
    return [[[@"/" stringByAppendingString:url] stringByAppendingString:[[[NSDate date] stringWithFormat:@"yyyyMMddHH"] stringByAppendingString:[IETConfiguration defaultConfiguration].securityKey]] md5String];
}

- (NSString *)apiKey
{
    return [[IETSession sharedObject] apiKey];
}

- (NSString *)appendApiKeyAndTokenForUrl:(NSString *)url
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if ([self apiKey].length>0) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"?api_key=%@&api_token=%@&app_version=%@",[self apiKey],[self tokenWithUrl:url],app_Version]];
    }else{
       
        url = [url stringByAppendingString:[NSString stringWithFormat:@"?api_token=%@&app_version=%@",[self tokenWithUrl:url],app_Version]];
    }
    return url;
}

- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString*  outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                        NULL, /* allocator */
                                                                                        (__bridge CFStringRef)input,
                                                                                        NULL, /*解决含有的转义字符*/
                                                                                        (CFStringRef)@"",
                                                                                        kCFStringEncodingUTF8);
    return outputStr;
}

- (void)analyseResponseObject:(id)responseObject WithSuccess:(void (^)(id _Nullable, NSString *))success failure:(void (^)(NSError * _Nonnull))failure
{
    if (![responseObject isKindOfClass:[NSDictionary class]]) {
        NSError *error = [NSError errorWithDomain:[IETConfiguration defaultConfiguration].errorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey:@"json格式错误..."}];
        if (failure) {
            failure(error);
        }
        return;
    }    NSDictionary *res = (NSDictionary *)responseObject;
    if (![[res objectOrNilForKey:@"success"] boolValue]) {
        NSError *error = [NSError errorWithDomain:[IETConfiguration defaultConfiguration].errorDomain code:[[res objectOrNilForKey:@"code"] integerValue] userInfo:@{NSLocalizedDescriptionKey:[res objectOrNilForKey:@"message"]}];
        if (failure) {
            failure(error);
        }
        return;
    }else{
        if (success) {
            success([res objectOrNilForKey:@"data"],[res objectOrNilForKey:@"message"]);
        }
    }
}

- (NSString *)mineTypeForFilePath:(NSString *)filePath
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return nil;
    }
    
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,(__bridge CFStringRef)[filePath pathExtension],NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass(UTI,kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType) {
        return @"application/octet-stream";
    }
    return (__bridge NSString *)(MIMEType);
}

-(NSURLSessionDataTask *)POSTWithUrl:(NSString *)url params:(NSDictionary *)params success:(void (^)(id _Nullable, NSString *))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    url=[self appendApiKeyAndTokenForUrl:url];
    return [_httpManager POST:[self encodeToPercentEscapeString:url]
                   parameters:newParams
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          [self analyseResponseObject:responseObject WithSuccess:success failure:failure];
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          if (failure) {
                              failure(error);
                          }
                      }];
}

-(NSURLSessionDataTask *)POSTWithUrl:(NSString *)url RESTfulKey:(NSString *)key params:(NSDictionary *)params success:(void (^)(id _Nullable, NSString *))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    id value = [newParams objectOrNilForKey:key];
    if (value != nil) {
        if ([value isKindOfClass:[NSNumber class]]) {
            value = [(NSNumber *)value stringValue];
        }
        url = [url stringByAppendingPathComponent:value];
        [newParams removeObjectForKey:key];
    }
    return [self POSTWithUrl:url params:newParams success:success failure:failure];
}

-(NSURLSessionDataTask *)POSTWithUrl:(NSString *)url RESTfulKeys:(NSArray<NSString *> *)keys params:(NSDictionary *)params success:(void (^)(id _Nullable, NSString *))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    for (NSString *key in keys) {
        id value = [newParams objectOrNilForKey:key];
        if (value != nil) {
            if ([value isKindOfClass:[NSNumber class]]) {
                value = [(NSNumber *)value stringValue];
            }
            url = [url stringByAppendingPathComponent:value];
            [newParams removeObjectForKey:key];
        }
    }
    return [self POSTWithUrl:url params:newParams success:success failure:failure];
}

- (NSURLSessionDataTask *)GETWithUrl:(NSString *)url params:(NSDictionary *)params success:(void (^)(id _Nullable, NSString *))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    url=[self appendApiKeyAndTokenForUrl:url];
    return [_httpManager GET:[self encodeToPercentEscapeString:url]
                  parameters:newParams
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         [self analyseResponseObject:responseObject WithSuccess:success failure:failure];
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         if (failure) {
                             failure(error);
                         }
                     }];
}

-(NSURLSessionDataTask *)GETWithUrl:(NSString *)url RESTfulKey:(NSString *)key params:(NSDictionary *)params success:(void (^)(id _Nullable, NSString *))success failure:(void (^)(NSError * _Nonnull))failure
{
    
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    id value = [newParams objectOrNilForKey:key];
    if (value != nil) {
        if ([value isKindOfClass:[NSNumber class]]) {
            value = [(NSNumber *)value stringValue];
        }
        url = [url stringByAppendingPathComponent:value];
        [newParams removeObjectForKey:key];
    }
    return [self GETWithUrl:url params:newParams success:success failure:failure];
}

-(NSURLSessionDataTask *)GETWithUrl:(NSString *)url RESTfulKeys:(NSArray<NSString *> *)keys params:(NSDictionary *)params success:(void (^)(id _Nullable, NSString *))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    for (NSString *key in keys) {
        id value = [newParams objectOrNilForKey:key];
        if (value != nil) {
            if ([value isKindOfClass:[NSNumber class]]) {
                value = [(NSNumber *)value stringValue];
            }
            
            url = [url stringByAppendingPathComponent:value];
            [newParams removeObjectForKey:key];
        }
    }
    return [self GETWithUrl:url params:newParams success:success failure:failure];
}

- (NSURLSessionDataTask *)PUTWithUrl:(NSString *)url params:(NSDictionary *)params success:(void (^)(id _Nullable, NSString *))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    url=[self appendApiKeyAndTokenForUrl:url];
    return [_httpManager PUT:[self encodeToPercentEscapeString:url]
                  parameters:newParams
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         [self analyseResponseObject:responseObject WithSuccess:success failure:failure];
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         if (failure) {
                             failure(error);
                         }
                     }];
}

- (NSURLSessionDataTask *)PUTWithUrl:(NSString *)url RESTfulKey:(NSString *)key params:(NSDictionary *)params success:(void (^)(id _Nullable, NSString *))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    NSString *value = [newParams objectOrNilForKey:key];
    if (value.length) {
        url = [url stringByAppendingPathComponent:value];
        [newParams removeObjectForKey:key];
    }
    return [self PUTWithUrl:url params:params success:success failure:failure];
}
- (NSURLSessionDataTask *)PUTWithUrl:(NSString *)url RESTfulKeys:(NSArray *)keys params:(NSDictionary *)params success:(void (^)(id _Nullable, NSString *))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    for (NSString *key in keys) {
        id value = [newParams objectOrNilForKey:key];
        if (value != nil) {
            if ([value isKindOfClass:[NSNumber class]]) {
                value = [(NSNumber *)value stringValue];
            }
            
            url = [url stringByAppendingPathComponent:value];
            [newParams removeObjectForKey:key];
        }
    }
    return [self PUTWithUrl:url params:newParams success:success failure:failure];
}

- (NSURLSessionDataTask *)DELETEWithUrl:(NSString *)url params:(NSDictionary *)params success:(void (^)(id _Nullable, NSString *))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    url=[self appendApiKeyAndTokenForUrl:url];
    return [_httpManager DELETE:[self encodeToPercentEscapeString:url]
                  parameters:newParams
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         [self analyseResponseObject:responseObject WithSuccess:success failure:failure];
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         if (failure) {
                             failure(error);
                         }
                     }];
}

- (NSURLSessionDataTask *)DELETEWithUrl:(NSString *)url RESTfulKey:(NSString *)key params:(NSDictionary *)params success:(void (^)(id _Nullable, NSString *))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    id value = [newParams objectOrNilForKey:key];
    if (value != nil) {
        if ([value isKindOfClass:[NSNumber class]]) {
            value = [(NSNumber *)value stringValue];
        }
        url = [url stringByAppendingPathComponent:value];
        [newParams removeObjectForKey:key];
    }
    return [self DELETEWithUrl:url params:newParams success:success failure:failure];
}

- (NSURLSessionDataTask *)DELETEWithUrl:(NSString *)url RESTfulKeys:(NSArray<NSString *> *)keys params:(NSDictionary *)params success:(void (^)(id _Nullable, NSString *))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    for (NSString *key in keys) {
        id value = [newParams objectOrNilForKey:key];
        if (value != nil) {
            if ([value isKindOfClass:[NSNumber class]]) {
                value = [(NSNumber *)value stringValue];
            }
            url = [url stringByAppendingPathComponent:value];
            [newParams removeObjectForKey:key];
        }
    }
    return [self DELETEWithUrl:url params:params success:success failure:failure];
}

- (NSURLSessionDataTask *)uploadFile:(NSString *)filePath toUrl:(NSString *)url params:(NSDictionary *)params progress:(void (^)(NSProgress * _Nonnull))progress success:(void (^)(id _Nullable, NSString *))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    url=[self appendApiKeyAndTokenForUrl:url];
    NSString *mimeType = [self mineTypeForFilePath:filePath];
    NSDictionary *fileAtt = [[NSFileManager defaultManager]attributesOfItemAtPath:filePath error:nil];
    NSInputStream *inputStream = [[NSInputStream alloc] initWithFileAtPath:filePath];
    NSUInteger length = [[fileAtt objectForKey:NSFileSize] unsignedIntegerValue];
    
    return [_uploadManager POST:[self encodeToPercentEscapeString:url] parameters:newParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithInputStream:inputStream name:@"upfile" fileName:filePath.lastPathComponent length:length mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (uploadProgress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self analyseResponseObject:responseObject WithSuccess:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (NSURLSessionDataTask *)uploadFiles:(NSArray<NSString *> *)filePaths toUrl:(NSString *)url params:(NSDictionary *)params progress:(void (^)(NSProgress * _Nonnull))progress success:(void (^)(id _Nullable, NSString *))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    url=[self appendApiKeyAndTokenForUrl:url];
    
    return [_uploadManager POST:[self encodeToPercentEscapeString:url]
                     parameters:newParams
      constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
          [filePaths enumerateObjectsUsingBlock:^(NSString * _Nonnull filePath, NSUInteger idx, BOOL * _Nonnull stop) {
              NSString *mimeType = [self mineTypeForFilePath:filePath];
              NSDictionary *fileAtt = [[NSFileManager defaultManager]attributesOfItemAtPath:filePath error:nil];
              NSInputStream *inputStream = [[NSInputStream alloc] initWithFileAtPath:filePath];
              NSUInteger length = [[fileAtt objectForKey:NSFileSize] unsignedIntegerValue];
              [formData appendPartWithInputStream:inputStream name:@"upfile" fileName:filePath.lastPathComponent length:length mimeType:mimeType];
          }];
      }
                       progress:^(NSProgress * _Nonnull uploadProgress) {
                           if (uploadProgress) {
                               progress(uploadProgress);
                           }
                       }
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            [self analyseResponseObject:responseObject WithSuccess:success failure:failure];
                        }
                        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            if (failure) {
                                failure(error);
                            }
                        }];
}

- (NSURLSessionDataTask *)uploadImage:(UIImage *)image toUrl:(NSString *)url params:(NSDictionary *)params progress:(void (^)(NSProgress * _Nonnull))progress success:(void (^)(id _Nullable, NSString *))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    url=[self appendApiKeyAndTokenForUrl:url];
    return [_uploadManager POST:[self encodeToPercentEscapeString:url]
                     parameters:newParams
      constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
          [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.3) name:@"files" fileName:[[NSString stringWithUuid] stringByAppendingPathExtension:@"jpg"] mimeType:@"image/jpeg"];
      }
                       progress:^(NSProgress * _Nonnull uploadProgress) {
                           if (uploadProgress) {
                               progress(uploadProgress);
                           }
                       }
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            [self analyseResponseObject:responseObject WithSuccess:success failure:failure];
                        }
                        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            if (failure) {
                                failure(error);
                            }
                        }];
}

-(NSURLSessionDataTask *)uploadImages:(NSArray<UIImage *> *)images toUrl:(NSString *)url params:(NSDictionary *)params progress:(void (^)(NSProgress * _Nonnull))progress success:(void (^)(id _Nullable, NSString *))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    url=[self appendApiKeyAndTokenForUrl:url];
    return [_uploadManager POST:[self encodeToPercentEscapeString:url]
                     parameters:newParams
      constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
          [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
              NSString *uuid = [NSString stringWithUuid];
              [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.3) name:uuid fileName:[uuid stringByAppendingPathExtension:@"jpg"] mimeType:@"image/jpeg"];
          }];
      }
                       progress:^(NSProgress * _Nonnull uploadProgress) {
                           if (uploadProgress) {
                               progress(uploadProgress);
                           }
                       }
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            [self analyseResponseObject:responseObject WithSuccess:success failure:failure];
                        }
                        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            if (failure) {
                                failure(error);
                            }
                        }];
}


- (NSURLSessionDownloadTask *)downloadFromUrl:(NSString *)url topath:(NSString *)path progress:(void (^)(NSProgress * _Nonnull))progress success:(void (^)(NSURL * _Nullable, NSString *))success failure:(void (^)(NSError * _Nonnull))failure {
    return [_uploadManager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error && failure) {
            failure(error);
        }else{
            if (success) {
                success(filePath,@"");
            }
        }
    }];
}

@end







