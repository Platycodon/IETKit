//
//  IETSession.h
//  CXNT
//
//  Created by Lucifer on 16/9/18.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IETDataBase;

@interface IETSession : NSObject

NS_ASSUME_NONNULL_BEGIN
/*
 * http请求，及用户登录账号密码
 */
@property (nonatomic, copy, readonly) NSString *httpAccount;
@property (nonatomic, copy, readonly) NSString *httpPassword;

@property (nonatomic, copy, nullable) NSString  *apiKey;

@property (nonatomic, copy, readonly) NSString *userPath;
@property (nonatomic, copy, readonly) NSString *userCachePath;
@property (nonatomic, copy, readonly) NSString *documentPath;

@property (nonatomic, strong, readonly) IETDataBase *database;

+ (instancetype)sharedObject;

- (BOOL)hasLogin;

/*
 * 设置session，不保存到本地
 */
- (void)setHttpAccount:(NSString * _Nonnull)account password:(NSString * _Nullable)password apiKey:(NSString *_Nonnull)key;

/*
 * session密码修改，不保存到本地
 */
- (void)resetHttpPassword:(NSString *)password;

/*
 * 本地是否存在已有的session数据
 */
+ (BOOL)hasSavedSession;

/*
 * 本地session的保存与清除
 */
- (BOOL)saveSession;
- (BOOL)cleanSession;

/**
 登出当前session操作
 */
- (void)signOutCurrentSession;

NS_ASSUME_NONNULL_END



@end
