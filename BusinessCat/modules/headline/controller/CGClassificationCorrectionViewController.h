//
//  CGClassificationCorrectionViewController.h
//  CGSays
//
//  Created by zhu on 2016/12/27.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"
typedef void (^CGClassificationCorrectionBlock)(NSString *navType);

@interface CGClassificationCorrectionViewController : CTBaseViewController{
  CGClassificationCorrectionBlock resultBlock;
}
-(instancetype)initWithBlock:(CGClassificationCorrectionBlock)block;
@property (nonatomic, copy) NSString *bigtype;
@end
