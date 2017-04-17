//
//  IETPinyinClassifer.m
//  CXNT
//
//  Created by Lucifer on 16/9/20.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "IETPinyinClassifer.h"

@implementation IETPinyinClassifer

+ (NSCharacterSet *)lowercaseCharacterSet
{
    static NSCharacterSet *set = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        set = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz"];
    });
    return set;
}

+ (NSCharacterSet *)uppercaseCharacterSet
{
    static NSCharacterSet *set = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        set = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    });
    return set;
}

+ (NSDictionary *)classifyObjects:(NSArray *)objects pinyinKeyPath:(NSString *)keyPath
{
    NSMutableDictionary *vocabularyIndexHash = [NSMutableDictionary new];
    
    for (id obj in objects) {
        id value = [obj valueForKeyPath:keyPath];
        if ([value isKindOfClass:[NSString class]]) {
            NSString *pinyin = value;
            NSString *firstLetter = pinyin.length ? [[pinyin substringToIndex:1] uppercaseString] : @"#";
            if ([firstLetter rangeOfCharacterFromSet:[self uppercaseCharacterSet]].location == NSNotFound) {
                firstLetter = @"#";
            }
            
            NSMutableArray *classfiedArray = vocabularyIndexHash[firstLetter];
            if (classfiedArray == nil) {
                classfiedArray = [NSMutableArray new];
                vocabularyIndexHash[firstLetter] = classfiedArray;
            }
            [classfiedArray addObject:obj];
        }
    }
    for (NSString *key in vocabularyIndexHash) {
        NSMutableArray *classfiedArray = vocabularyIndexHash[key];
        [classfiedArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *value1 = [obj1 valueForKeyPath:keyPath];
            NSString *value2 = [obj2 valueForKeyPath:keyPath];
            return [value1 compare:value2 options:NSCaseInsensitiveSearch];
        }];
    }
    
    return vocabularyIndexHash;
}

@end
