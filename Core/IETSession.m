//
//  IETSession.m
//  CXNT
//
//  Created by Lucifer on 16/9/18.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "IETSession.h"
#import "NSString+IETAdd.h"
#import "SAMKeychain.h"
#import "NSFileManager+IETAdd.h"
#import "IETConfiguration.h"
#import "IETSystemDriver.h"

#import "IETDataBase.h"

@interface IETSession()

@property (nonatomic, copy) NSString *httpAccount;
@property (nonatomic, copy) NSString *httpPassword;

@property (nonatomic, copy) NSString *userPath;
@property (nonatomic, copy) NSString *userCachePath;

@property (nonatomic, strong) IETDataBase *database;

@end

@implementation IETSession

+ (NSString *)visitorPath
{
    return @"visitor";
}

+ (NSString *)keychainServerName
{
    return [[NSString stringWithBundleIdentifer] stringByAppendingString:@".sessionServer"];
}

+(instancetype)sharedObject
{
    static IETSession *session;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        if ([[self class] hasSavedSession]) {
            session = [[self class] savedSession];
        }else{
            session = [[IETSession alloc] init];
        }
        [session initFiles];
    });
    return session;
}

- (NSString *)documentPath {
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[[NSFileManager defaultManager] documentDictionary] stringByAppendingPathComponent:@"appDoc"]]){
        [[NSFileManager defaultManager] createDirectoryAtPath:[[[NSFileManager defaultManager] documentDictionary] stringByAppendingPathComponent:@"appDoc"] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [[[NSFileManager defaultManager] documentDictionary] stringByAppendingPathComponent:@"appDoc"];
}
- (void)initFiles
{
    if (self.apiKey && self.httpAccount) {
        self.userPath = [[[NSFileManager defaultManager] documentDictionary] stringByAppendingPathComponent:self.httpAccount];
        self.userCachePath = [[[NSFileManager defaultManager] cacheDictionary] stringByAppendingPathComponent:self.httpAccount];
    }else {
        self.userPath = [[[NSFileManager defaultManager] documentDictionary] stringByAppendingPathComponent:[[self class] visitorPath]];
        self.userCachePath = [[[NSFileManager defaultManager] cacheDictionary] stringByAppendingPathComponent:[[self class] visitorPath]];
    }
    NSString *databasePath = [self.userPath stringByAppendingPathComponent:@"db.sqlite"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[databasePath stringByDeletingLastPathComponent]]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[databasePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    self.database = [[IETDataBase alloc] initWithPath:databasePath];
}

- (BOOL)hasLogin
{
    return self.apiKey.length>0;
}

- (void)setHttpAccount:(NSString *)account password:(NSString *)password apiKey:(NSString * _Nonnull)key
{
    _httpAccount = account;
    _httpPassword = password;
    _apiKey = key;
    [self initFiles];
    Class<IETSystemDriverProtocol> driver = [[IETConfiguration defaultConfiguration] driverClass];
    [driver registerPersistenceModels];
}

- (void)resetHttpPassword:(NSString *)password
{
    _httpPassword = password;
}

+ (BOOL)hasSavedSession
{
    NSLog(@"%@",[SAMKeychain allAccounts]);
    return [SAMKeychain accountsForService:[self keychainServerName]].count>0;
}

+ (instancetype)savedSession
{
    if ([[self class] hasSavedSession]) {
        IETSession *saved = [IETSession new];
        NSDictionary *acc = [SAMKeychain accountsForService:[self keychainServerName]].lastObject;
        saved.httpAccount = [acc objectOrNilForKey:kSAMKeychainAccountKey];
        NSData *api_key_data = [[NSFileManager defaultManager] contentsAtPath:[[[NSFileManager defaultManager] documentDictionary] stringByAppendingPathComponent:@"api_key"]];
        saved.apiKey = [NSKeyedUnarchiver unarchiveObjectWithData:api_key_data];
        return saved;
    }
    return nil;
}

- (BOOL)saveSession
{
    NSError *error;
    NSArray *arr = [SAMKeychain accountsForService:[[self class] keychainServerName]];
    [arr enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [SAMKeychain deletePasswordForService:[[self class] keychainServerName] account:[obj objectForKey:@"acct"] error:nil];
    }];
    [SAMKeychain setPassword:_httpPassword forService:[[self class] keychainServerName] account:_httpAccount error:&error];
    [[NSFileManager defaultManager] createFileAtPath:[[[NSFileManager defaultManager] documentDictionary] stringByAppendingPathComponent:@"api_key"] contents:[NSKeyedArchiver archivedDataWithRootObject:self.apiKey] attributes:nil];
    if (error) {
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)cleanSession
{
    NSArray<NSDictionary<NSString *, id> *> *accounts = [SAMKeychain accountsForService:[[self class] keychainServerName]];
    __block NSError *error;
    __weak typeof(self) weakSelf = self;
    [accounts enumerateObjectsUsingBlock:^(NSDictionary<NSString *,id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [SAMKeychain deletePasswordForService:[[weakSelf class] keychainServerName] account:[obj objectForKey:@"account"] error:&error];
    }];
    if (error) {
        return NO;
    }else{
        return YES;
    }
}

- (void)signOutCurrentSession {
    self.apiKey = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[[[NSFileManager defaultManager] documentDictionary] stringByAppendingPathComponent:@"api_key"] error:nil];
    [self initFiles];
}

@end
