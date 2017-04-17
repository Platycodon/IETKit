//
//  NSString+IETAdd.h
//  CXNT
//
//  Created by Lucifer on 16/9/18.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IETAdd)


/*
 * 普通常用功能
 */
// 获取 bundle ID
+ (nullable NSString *)stringWithBundleIdentifer;

// 获取 UUID,即随机字符串
+ (nullable NSString *)stringWithUuid;

/*
 * 加密
 */
- (nullable NSString *)md5String;

- (BOOL)isPhoneNumber;

- (BOOL)containsString:(NSString  * _Nonnull )string;

- (BOOL)isIDCard;

#pragma mark - Predicate

+ (nonnull NSString *)predicatOfEmail;//邮箱
+ (nonnull NSString *)predicatOfPhoneNumber;//手机号
//+ (nonnull NSString *)predicatOfCarNumber;//车牌号
+ (nonnull NSString *)predicatOfIdentityNumber;//身份证号
+ (nonnull NSString *)predicatOfNickName;//昵称
+ (nonnull NSString *)predicatOfName;
@end
