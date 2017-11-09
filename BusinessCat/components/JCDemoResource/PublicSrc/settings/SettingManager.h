//
//  SettingManager.h
//  UltimateShow
//
//  Created by young on 16/12/17.
//  Copyright © 2016年 young. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ResolutionVaule) {
    ResolutionVaule360 = 360,
    ResolutionVaule720 = 720
};

typedef NS_ENUM(NSUInteger, JoinModeValue) {
    JoinModeValueVideo = 100,
    JoinModeValueAudio,
    JoinModeValueRelay
};


@interface ServerAddressModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *serverAddress;
@property (nonatomic, assign, getter=isDefaultServer) BOOL defaultServer;

@end

@interface SettingManager : NSObject


+ (void)setResolution:(Resolution)value;

+ (Resolution)getResolution;

+ (void)setCapacity:(NSUInteger)value;

+ (NSUInteger)getCapacity;

+ (void)setJoinMode:(JoinModeValue)value;

+ (JoinModeValue)getJoinMode;

+ (void)setCdnEnable:(BOOL)enable;

+ (BOOL)getCdnEnable;

+ (NSString *)getDefaultServerAddress;

+ (void)addServerAddress:(NSString *)server isDefault:(BOOL)isDefault;

+ (void)removeServerAddressAtIndex:(NSUInteger)index;

+ (void)updateServerAddressAtIndex:(NSUInteger)index server:(NSString *)newServer isDefault:(BOOL)isDefault;

+ (NSArray<ServerAddressModel *> *)getAllServerAddress;

+ (BOOL)privacyNeedToShowBadge;

@end
