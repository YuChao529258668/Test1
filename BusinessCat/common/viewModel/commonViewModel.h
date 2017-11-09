//
//  commonViewModel.h
//  CGSays
//
//  Created by zhu on 2017/4/6.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGPushEntity.h"
#import "CGInfoHeadEntity.h"

@interface commonViewModel : NSObject
-(void)messageCommandWithCommand:(NSString *)command parameterId:(NSString *)parameterId commpanyId:(NSString *)commpanyId recordId:(NSString *)recordId messageId:(NSString *)messageId detial:(CGInfoHeadEntity *)detail typeArray:(NSMutableArray *)typeArray;
-(void)messagePushAlertviewWithEnitty:(CGPushEntity *)entity;
@end
