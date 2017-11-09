//
//  QiniuBiz.m
//  CGSays
//
//  Created by mochenyang on 2016/10/20.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "QiniuBiz.h"

@implementation QiniuBiz


//获取七牛的上传tokens
-(void)getQiniuUploadTokensWithKeys:(NSMutableArray *)keys success:(void(^)(NSDictionary *tokens))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2],@"saveType",keys,@"keys", nil];
    [self.component sendPostRequestWithURL:URL_COMMON_QINIU_GETTOKENS param:param success:^(id data) {
        NSDictionary *result = data;
        success(result);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//批量上传图片
-(void)uploadFileWithImages:(NSMutableArray *)images phAssets:(NSMutableArray *)phAssets keys:(NSMutableArray *)keys original:(BOOL)original progress:(QNUpProgressHandler)progress success:(void(^)(void))success fail:(void (^)(NSError *error))fail{
    if(images && images.count > 0){
        __block int uploadsuccessNum = 0;//上传成功的数量
        __block int uploadFinishNum = 0;//多少个已经请求完成的数量，包括成功与失败的
        [self getQiniuUploadTokensWithKeys:keys success:^(NSDictionary *tokens) {
            QNConfiguration *config =[QNConfiguration build:^(QNConfigurationBuilder *builder) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                [array addObject:[QNResolver systemResolver]];
                QNDnsManager *dns = [[QNDnsManager alloc] init:array networkInfo:[QNNetworkInfo normal]];
                //是否选择  https  上传
                builder.zone = [[QNAutoZone alloc] initWithDns:dns];
            }];
            QNUploadManager *upManager = [[QNUploadManager alloc]initWithConfiguration:config];
            QNUploadOption *option = [[QNUploadOption alloc]initWithMime:nil progressHandler:progress params:nil checkCrc:YES cancellationSignal:nil];
            if(original){//上传原图
                [phAssets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *key = keys[idx];
                    NSString *token = [tokens objectForKey:key];
                    [upManager putPHAsset:obj key:keys[idx] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                        uploadFinishNum += 1;//一个请求完成
                        if(resp != nil && [[resp allKeys]containsObject:@"key"]){
                            uploadsuccessNum += 1;//一个上传请求成功
                        }
                        if(uploadsuccessNum >= keys.count){//全部上传成功
                            success();
                        }else if(uploadFinishNum >= keys.count){//请求已完成，但有失败的请求
                            fail(nil);
                        }
                    } option:option];
                }];
            }else{//上传非原图
                [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *key = keys[idx];
                    NSString *token = [tokens objectForKey:key];
                    [upManager putData:UIImageJPEGRepresentation(obj, 0.5) key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                        uploadFinishNum += 1;//一个请求完成
                        if(resp != nil && [[resp allKeys]containsObject:@"key"]){
                            uploadsuccessNum += 1;//一个上传请求成功
                        }
                        if(uploadsuccessNum >= keys.count){//全部上传成功
                            success();
                        }else if(uploadFinishNum >= keys.count){//请求已完成，但有失败的请求
                            fail(nil);
                        }
                    } option:option];
                }];
            }
        } fail:^(NSError *error) {
            fail(error);
        }];
    }else{
        success();
    }
}

@end
