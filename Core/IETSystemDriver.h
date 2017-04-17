//
//  IETSystemDriver.h
//  CXNT
//
//  Created by 陆楠 on 2016/10/18.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IETSystemDriverProtocol <NSObject>

@required
+(void)registerPersistenceModels;

@end

@interface IETSystemDriver : NSObject<IETSystemDriverProtocol>

+(void)registerPersistenceModels NS_REQUIRES_SUPER;

@end
