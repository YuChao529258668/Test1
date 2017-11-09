//
//  CGPayMethodEntity.h
//  CGKnowledge
//
//  Created by zhu on 2017/6/14.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGPayMethodEntity : NSObject
@property (nonatomic, copy) NSString *method;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, strong) NSMutableArray *prompt;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, copy) NSString *helpCateId;
@property (nonatomic, copy) NSString *helpTitle;
@end

@interface CGPromptEntity : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *cateId;
@end
