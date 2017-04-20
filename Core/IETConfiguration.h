//
//  IETConfiguration.h
//  CXNT
//
//  Created by Lucifer on 16/9/18.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IETConfiguration : NSObject


@property (nonatomic) Class driverClass;
/*
 * hosts 配置
 */
@property (nonatomic, copy) NSString *httpHost;
@property (nonatomic, copy) NSString *uploadHost;

/*
 * 文件上传目录
 */
@property (nonatomic, copy) NSString *picDictionary;
@property (nonatomic, copy) NSString *videoDictionary;
@property (nonatomic, copy) NSString *audioDictionary;

/*
 * appKey 配置
 */
@property (nonatomic, copy) NSString *appKey;

/*
 * token加密秘钥 配置
 */
@property (nonatomic, copy) NSString *securityKey;

@property (nonatomic, copy) NSString *errorDomain;

/*
 * http请求超时时间
 */
@property (nonatomic, assign) NSTimeInterval requestTimeoutTime;

/**
 vc的背景色
 */
@property (nonatomic, copy) UIColor *vcBackgroundColor;

/**
 vc返回箭头图片名
 */
@property (nonatomic, copy) NSString *backArrowName;


+ (instancetype)defaultConfiguration;


@end
