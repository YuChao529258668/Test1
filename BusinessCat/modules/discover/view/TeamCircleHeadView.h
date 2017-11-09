//
//  TeamCircleHeadView.h
//  CGKnowledge
//
//  Created by mochenyang on 2017/6/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamCircleCompanyState.h"

typedef void (^TeamCircleHeadViewBlock)(TeamCircleCompanyState *entity);

@interface TeamCircleHeadView : UIView

-(instancetype)initWithFrame:(CGRect)frame block:(TeamCircleHeadViewBlock)block;

-(void)updateHeadView:(TeamCircleCompanyState *)entity cover:(NSString *)cover;

@end
