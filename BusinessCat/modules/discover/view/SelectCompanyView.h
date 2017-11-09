//
//  SelectCompanyView.h
//  CGSays
//
//  Created by zhu on 2017/1/16.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SelectCompanyCancelBlock)(void);
@interface SelectCompanyView : UIView

-(instancetype)initWithArray:(NSMutableArray *)array cancel:(SelectCompanyCancelBlock)cancel;

//弹出
-(void)show;
@end
