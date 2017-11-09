//
//  CGUserOrganizaAuthResult.h
//  CGSays
//
//  Created by mochenyang on 2017/3/29.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGUserOrganizaAuthResult : NSObject

@property(nonatomic,retain) NSString *organizaName;//组织简称
@property (nonatomic, retain) NSString *name;//用户名
@property (nonatomic, retain) NSString *legalPerson;//法人
@property (nonatomic, retain) NSString *additional;//附加照片
@property (nonatomic, retain) NSString *authExplain;//认证说明，比如认证不通过会返回相关说明

@property (nonatomic, strong) UIImage *image;//用于选中的图片保存
@property(nonatomic,retain)NSString *verifyCode;//验证码

@property (nonatomic, copy) NSString *reason;
@end
