//
//  NSData+IETAdd.h
//  CXNT
//
//  Created by Lucifer on 16/9/19.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSData (IETAdd)

- (NSString *)md5String;

- (NSString *)base64EncodedString;

+ (NSData *)dataWithBase64EncodedString:(NSString *)base64EncodedString;

+ (NSData *)createPDFDataFromUIScrollView:(UIScrollView *)scrollView;

@end
