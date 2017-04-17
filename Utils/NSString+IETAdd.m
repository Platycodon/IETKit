//
//  NSString+IETAdd.m
//  CXNT
//
//  Created by Lucifer on 16/9/18.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "NSString+IETAdd.h"
#import "NSData+IETAdd.h"

@implementation NSString (IETAdd)

+ (NSString *)stringWithBundleIdentifer
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];;
}

+ (NSString *)stringWithUuid
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}


- (NSString *)md5String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5String];
}

- (BOOL)isPhoneNumber {
    NSString *Regex = [NSString predicatOfPhoneNumber];
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)containsString:(NSString *)string
{
    return @([self rangeOfString:string].length).boolValue;
}

- (BOOL)isIDCard{
    
    BOOL flag;
    if (self.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *ID = [NSString predicatOfIdentityNumber];
    NSPredicate *idTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ID];
    return [idTest evaluateWithObject:self];
    
}

#pragma mark - 

+ (NSString *)predicatOfEmail {
    return @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
}

+ (NSString *)predicatOfPhoneNumber {
    return @"1\\d{10}";
}

+ (NSString *)predicatOfIdentityNumber {
    return @"^(\\d{14}|\\d{17})(\\d|[xX])$";
}

+ (NSString *)predicatOfNickName {
    return @"nickname";
}

+ (NSString *)predicatOfName {
    return @"^[\u4e00-\u9fa5]{2,}$";
}

@end





