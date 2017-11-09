//
//  CGAttestationController.h
//  CGSays
//
//  Created by mochenyang on 2017/3/21.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
#import "CGUserOrganizaJoinEntity.h"

typedef void (^CGUserAttestationBlock)(NSString *success);

@interface CGAttestationController : CTBaseViewController

@property (nonatomic, copy) CGUserAttestationBlock block;

-(instancetype)initWithOrganiza:(CGUserOrganizaJoinEntity *)organiza block:(CGUserAttestationBlock)block;

-(void)refresh:(CGUserOrganizaJoinEntity *)organiza;

@end
