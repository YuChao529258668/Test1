//
//  CGPermissionsEntity.h
//  CGKnowledge
//
//  Created by zhu on 2017/7/4.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGPermissionsEntity : NSObject
@property (nonatomic, assign) NSInteger integral;
@property (nonatomic, assign) NSInteger viewPermit;
@property (nonatomic, copy) NSString *viewPrompt;
@property (nonatomic, copy) NSString *title;
@end
