//
//  SettingManager.m
//  UltimateShow
//
//  Created by young on 16/12/17.
//  Copyright © 2016年 young. All rights reserved.
//

#import "SettingManager.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

NSString * const kResolution = @"kResolution";
NSString * const kCapacity = @"kCapacity";
NSString * const kJoinMode = @"kJoinMode";
NSString * const kCdnEnable = @"kCdnEnable";

NSString * const kServerAddressArrayData = @"kServerAddressArrayData";

@implementation ServerAddressModel
- (BOOL)isDefaultServer
{
    return _defaultServer;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.serverAddress forKey:@"ServerAddress"];
    [aCoder encodeBool:self.isDefaultServer forKey:@"DefaultServer"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.serverAddress = [aDecoder decodeObjectForKey:@"ServerAddress"];
        self.defaultServer = [aDecoder decodeBoolForKey:@"DefaultServer"];
    }
    return self;
}
@end

@interface SettingManager ()
{
    NSUserDefaults *_userDefaults;
    
    NSMutableArray<ServerAddressModel *> *_serverArray;
}

+ (SettingManager *)manager;

@end

@implementation SettingManager

+ (SettingManager *)manager
{
    static SettingManager *_manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _manager = [[SettingManager alloc] init];
    });
    return _manager;
}

+ (void)setResolution:(Resolution)value
{
    [[SettingManager manager] setResolution:value];
}

+ (Resolution)getResolution
{
    return [[SettingManager manager] getResolution];
}

+ (void)setCapacity:(NSUInteger)value
{
    [[SettingManager manager] setCapacity:value];
}

+ (NSUInteger)getCapacity
{
    return [[SettingManager manager] getCapacity];
}

+ (void)setJoinMode:(JoinModeValue)value
{
    [[SettingManager manager] setJoinMode:value];
}

+ (JoinModeValue)getJoinMode
{
    return [[SettingManager manager] getJoinMode];
}

+ (void)setCdnEnable:(BOOL)enable
{
    [[SettingManager manager] setCdnEnable:enable];
}

+ (BOOL)getCdnEnable
{
    return [[SettingManager manager] getCdnEnable];
}

+ (NSString *)getDefaultServerAddress
{
    return [[SettingManager manager] getDefaultServerAddress];
}

+ (void)addServerAddress:(NSString *)server isDefault:(BOOL)isDefault
{
    [[SettingManager manager] addServerAddress:server isDefault:isDefault];
}

+ (void)removeServerAddressAtIndex:(NSUInteger)index
{
    [[SettingManager manager] removeServerAddressAtIndex:index];
}

+ (void)updateServerAddressAtIndex:(NSUInteger)index server:(NSString *)newServer isDefault:(BOOL)isDefault;
{
    [[SettingManager manager] updateServerAddressAtIndex:index server:newServer isDefault:isDefault];
}

+ (NSArray<ServerAddressModel *> *)getAllServerAddress
{
    return [[SettingManager manager] getAllServerAddress];
}

+ (BOOL)privacyNeedToShowBadge
{
    BOOL audioShow = NO;
    AVAuthorizationStatus audioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (audioStatus == AVAuthorizationStatusRestricted || audioStatus == AVAuthorizationStatusDenied) {
        audioShow = YES;
    }
    
    BOOL videoShow = NO;
    AVAuthorizationStatus videoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (videoStatus == AVAuthorizationStatusRestricted || videoStatus == AVAuthorizationStatusDenied) {
        videoShow = YES;
    }
    
    return audioShow || videoShow;
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        _serverArray = [NSMutableArray array];
        _userDefaults = [NSUserDefaults standardUserDefaults];
        NSData *encodeData = [_userDefaults objectForKey:kServerAddressArrayData];
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:encodeData];
        if (array && array.count) {
            [_serverArray addObjectsFromArray:array];
        } else {
            [self addServerAddress:@"http:router.justalkcloud.com:8080" isDefault:YES];
        }
        
    }
    return self;
}

- (ServerAddressModel *)getDictionaryDefaultServerAddress
{
    ServerAddressModel *model = nil;
    for (ServerAddressModel *temp in _serverArray) {
        if (temp.isDefaultServer) {
            model = temp;
            break;
        }
    }
    return model;
}

- (void)cancelDefaultServerAddress
{
    ServerAddressModel *model = [self getDictionaryDefaultServerAddress];
    if (model) {
        model.defaultServer = NO;
    }
}

- (NSString *)getDefaultServerAddress
{
    ServerAddressModel *model = [self getDictionaryDefaultServerAddress];
    return model.serverAddress;
}

- (void)addServerAddress:(NSString *)server isDefault:(BOOL)isDefault
{
    if (!server) {
        return;
    }
    
    ServerAddressModel *model = [[ServerAddressModel alloc] init];
    model.serverAddress = server;
    model.defaultServer = isDefault;
    
    if (isDefault) {
        [self cancelDefaultServerAddress];
        [_serverArray insertObject:model atIndex:0];
        [[JCEngineManager sharedManager] setServerAddress:server];
        if ([[JCEngineManager sharedManager] isOnline]) {
            [[JCEngineManager sharedManager] logout];
        }
    } else {
        [_serverArray addObject:model];
    }
    
    NSData *encodeData = [NSKeyedArchiver archivedDataWithRootObject:_serverArray];
    [_userDefaults setObject:encodeData forKey:kServerAddressArrayData];
    [_userDefaults synchronize];
}

- (void)removeServerAddressAtIndex:(NSUInteger)index
{
    if (index >= _serverArray.count) {
        return;
    }
    
    ServerAddressModel *model = [_serverArray objectAtIndex:index];
    BOOL isDefault = model.isDefaultServer;
    [_serverArray removeObject:model];
    
    //如果删除的是默认地址，则把数组的第一个地址设置为默认
    if (isDefault) {
        ServerAddressModel *firstModel = [_serverArray firstObject];
        if (firstModel) {
            firstModel.defaultServer = YES;
            [[JCEngineManager sharedManager] setServerAddress:firstModel.serverAddress];
            if ([[JCEngineManager sharedManager] isOnline]) {
                [[JCEngineManager sharedManager] logout];
            }
        }
    }
    
    NSData *encodeData = [NSKeyedArchiver archivedDataWithRootObject:_serverArray];
    [_userDefaults setObject:encodeData forKey:kServerAddressArrayData];
    [_userDefaults synchronize];
}

- (void)updateServerAddressAtIndex:(NSUInteger)index server:(NSString *)newServer isDefault:(BOOL)isDefault;
{
    if (index >= _serverArray.count) {
        return;
    }
    
    //如果设置为默认地址，就把之前的默认地址设置为普通的
    if (isDefault) {
        [self cancelDefaultServerAddress];
        [[JCEngineManager sharedManager] setServerAddress:newServer];
        if ([[JCEngineManager sharedManager] isOnline]) {
            [[JCEngineManager sharedManager] logout];
        }
    }
    
    ServerAddressModel *model = [_serverArray objectAtIndex:index];
    if (newServer) {
        model.serverAddress = newServer;
    }
    
    model.defaultServer = isDefault;
        
    NSData *encodeData = [NSKeyedArchiver archivedDataWithRootObject:_serverArray];
    [_userDefaults setObject:encodeData forKey:kServerAddressArrayData];
    [_userDefaults synchronize];
}

- (NSArray<ServerAddressModel *> *)getAllServerAddress
{
    return _serverArray;
}

- (void)setResolution:(Resolution)value
{
    if (value != Resolution360 && value != Resolution720) {
        return;
    }
    
    [_userDefaults setInteger:value forKey:kResolution];
    [_userDefaults synchronize];
}

- (Resolution)getResolution
{
    NSInteger value = [_userDefaults integerForKey:kResolution];
    if (value == 0) {
        value = Resolution360;
        [self setResolution:value];
    }
    
    return value;
}

- (void)setCapacity:(NSUInteger)value
{
    [_userDefaults setInteger:value forKey:kCapacity];
    [_userDefaults synchronize];
}

- (NSUInteger)getCapacity
{
    NSInteger value = [_userDefaults integerForKey:kCapacity];
    if (value == 0) {
        value = 4;
        [self setCapacity:value];
    }
    
    return value;
}

- (void)setJoinMode:(JoinModeValue)value
{
    if (value < JoinModeValueVideo || value > JoinModeValueRelay) {
        return;
    }
    
    [_userDefaults setInteger:value forKey:kJoinMode];
    [_userDefaults synchronize];
}

- (JoinModeValue)getJoinMode
{
    NSInteger value = [_userDefaults integerForKey:kJoinMode];
    if (value == 0) {
        value = JoinModeValueVideo;
        [self setJoinMode:value];
    }
    
    return value;
}

- (void)setCdnEnable:(BOOL)enable
{
    [_userDefaults setBool:enable forKey:kCdnEnable];
    [_userDefaults synchronize];
}

- (BOOL)getCdnEnable
{
    return [_userDefaults boolForKey:kCdnEnable];
}
@end
