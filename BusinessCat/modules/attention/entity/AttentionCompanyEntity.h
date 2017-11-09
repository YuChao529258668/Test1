//
//  AttentionCompanyEntity.h
//  CGSays
//
//  Created by zhu on 2017/3/14.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttentionCompanyEntity : NSObject
@property (nonatomic, assign) NSInteger defaultUpdate;
@property (nonatomic, strong) NSMutableArray *list;
@end

@interface companyEntity : NSObject
@property (nonatomic, copy) NSString *companyID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger update;
@property (nonatomic, assign) NSInteger type;
@property(nonatomic,retain)NSString *depaName;
@property(nonatomic,retain)NSString *className;
@property (nonatomic, assign) NSInteger auditState;
@end
