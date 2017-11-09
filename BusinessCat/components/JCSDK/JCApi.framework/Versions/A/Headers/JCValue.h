//
//  JCValue.h
//  JCApi
//
//  Created by young on 2017/6/1.
//  Copyright © 2017年 young. All rights reserved.
//


/**
 *  @brief api基础值
 */
typedef NS_ENUM(NSInteger, JCApiBasicValue) {
    JCINVALIDID = -1,  //无效
    JCOK,              //成功
    JCFAILED           //失败
};

/**
 *  @brief api状态值
 */
typedef NS_ENUM(NSInteger, JCApiState) {
    JCApiStateNone = 0,     //初始状态(未初始化)
    JCApiStateInit,         //初始化成功（或登出成功）
    JCApiStateLogouted,     //被登出（已经在A设备登录的账号，在B设备上登录时，在A设备上该账号就是被登出）
    JCApiStateLogining,     //登录中
    JCApiStateLogined,      //登录成功
    JCApiStateLoginFailed,  //登录失败
    JCApiStateLogouting     //登出中
};
