//
//  QiniuBiz.h
//  CGSays
//
//  Created by mochenyang on 2016/10/20.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGBaseBiz.h"
#import <QiniuSDK.h>
#import <HappyDNS/HappyDNS.h>

@interface QiniuBiz : CGBaseBiz

//批量上传图片
-(void)uploadFileWithImages:(NSMutableArray *)images phAssets:(NSMutableArray *)phAssets keys:(NSMutableArray *)keys original:(BOOL)original progress:(QNUpProgressHandler)progress success:(void(^)(void))success fail:(void (^)(NSError *error))fail;

@end
