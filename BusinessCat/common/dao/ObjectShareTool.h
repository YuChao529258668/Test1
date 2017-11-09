//
//  ObjectShareTool.h
//  CGSays
//
//  Created by mochenyang on 2016/9/27.
//  Copyright © 2016年 cgsyas. All rights reserved.
//  app全局共享类

#import <Foundation/Foundation.h>
#import "CGUserEntity.h"
#import "WKWebViewJavascriptBridge.h"
#import <WebKit/WebKit.h>
#import "H5WebView.h"
#import <Reachability/Reachability.h>
#import "CGSettingEntity.h"
#import "CGInviteFriendEntity.h"

@interface ObjectShareTool : NSObject<UIGestureRecognizerDelegate,UIActionSheetDelegate>

+(ObjectShareTool *)sharedInstance;

//当前用户信息
@property(nonatomic,retain)CGUserEntity *currentUser;

@property(nonatomic,strong)NSTimer *webviewTimer;

//岗位知识大类
@property (nonatomic, strong) NSMutableArray *knowledgeBigTypeData;

@property (nonatomic, assign) NSInteger errcode;

@property(nonatomic,strong)H5WebView *webview;

@property (nonatomic, assign) NSInteger isLaunchScreen;//欢迎页是否加载完

@property(nonatomic,assign)int appEnterBackgroupTime;//app进入后台的时间

@property(nonatomic,assign)int appEnterBackgroupSecond;//app退出后台时的剩余时间

@property(nonatomic,strong)Reachability *reachability;

@property (nonatomic, strong) CGSettingEntity *settingEntity;
@property (nonatomic, strong) CGInviteFriendEntity *inviteFriend;

@property (nonatomic, assign) NSInteger isloginState;

//登录界面获取验证码倒计时的定时器
@property(nonatomic,assign)int loginTimerCount;//倒计时，剩余数
@property(nonatomic,retain)NSTimer *loginVerifyTimer;
@property(nonatomic,retain)NSString *loginPhoneNum;
-(void)startLoginTimer;//开启登录验证码倒计时函数
-(void)stopLoginTimer;//关闭登录验证码倒计时函数

//今日知识内存缓存key：packageId+catalogId value：列表
@property(nonatomic,strong)NSMutableDictionary *knowledgeDict;
//发现侧边栏内存缓存
@property(nonatomic,strong)NSMutableDictionary *discoverDict;

@end
