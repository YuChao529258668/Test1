//
//  NetWorkUtil.h
//  VieProd
//
//  Created by Calon Mo on 16/3/21.
//  Copyright © 2016年 VieProd. All rights reserved.
//  网络请求统一接口，app全部使用post请求
//  可以继承CTBaseBiz.h进行初始化使用

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import <AFNetworking.h>

typedef void (^FinishBlockCallBack)(NSDictionary *data);
typedef void (^FailBlockCallBack)(NSError *error);

@interface CTNetWorkUtil : NSObject{
    FinishBlockCallBack successcallback;
    FailBlockCallBack failcallback;
}

//@property (nonatomic,retain) ASIHTTPRequest *request;
@property(nonatomic,retain)NSString *urlString;
@property(nonatomic,retain)NSMutableDictionary *paramDict;

+(CTNetWorkUtil *)sharedManager;

/**
 * 加载loading动画
 */
- (void)startBlockAnimation;

/**
 * 停止加载动画
 */
- (void)stopBlockAnimation;


/**
 *  停止网络请求
 */
- (void)abort;

/**
 *  POST请求
 *  url         接口完整地址
 *  param       请求参数    json格式
 *  success     请求成功回调
 *  fail        请求失败回调
 */
- (void)sendPostRequestWithURL:(NSString *)urlString param:(NSDictionary *)param success:(void(^)(id data))success fail:(void (^)(NSError *error))fail;

/**
 *  文件下载请求
 *  url         接口完整地址
 *  success     请求成功回调
 */
- (void)sendDownLoadRequestWithURL:(NSString *)urlString filename:(NSString *)filename success:(void(^)(id data))success;


#pragma mark -

/**
 *   带请求动画的 POST 请求，基于 sendPostRequestWithURL 的封装
 *  url         接口完整地址
 *  param       请求参数    json格式
 *  success     请求成功回调
 *  fail        请求失败回调
 */
- (void)UIPostRequestWithURL:(NSString *)urlString param:(NSDictionary *)param success:(void(^)(id data))success fail:(void (^)(NSError *error))fail;

@end
