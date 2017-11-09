//
//  CGMessageDetailEntity.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/10.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGMessageDetailEntity : NSObject
@property (nonatomic, copy) NSString *headerColor;
@property (nonatomic, copy) NSString *headerImg;
@property (nonatomic, copy) NSString *pushId;
@property (nonatomic, assign) NSInteger pushLayout;
@property (nonatomic, assign) NSInteger pushType;
@property (nonatomic, copy) NSString *infoId;
@property (nonatomic, copy) NSString *infoTitle;
@property (nonatomic, copy) NSString *infoIntro;
@property (nonatomic, copy) NSString *infoPic;
@property (nonatomic, copy) NSString *infoHtml;
@property (nonatomic, copy) NSString *command;
@property (nonatomic, copy) NSString *commandAction;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *recordId;
@property (nonatomic, copy) NSString *recordType;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, strong) NSMutableArray *list;
@end

@interface CGMessageDetailListEntity : NSObject
@property (nonatomic, copy) NSString *infoId;
@property (nonatomic, copy) NSString *infoTitle;
@property (nonatomic, copy) NSString *infoIntro;
@property (nonatomic, copy) NSString *infoPic;
@property (nonatomic, copy) NSString *infoHtml;
@property (nonatomic, copy) NSString *command;
@property (nonatomic, copy) NSString *commandAction;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *recordId;
@property (nonatomic, copy) NSString *recordType;
@end
