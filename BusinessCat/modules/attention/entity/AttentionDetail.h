//
//  AttentionDetail.h
//  CGSays
//
//  Created by mochenyang on 2016/10/25.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttentionDetail : NSObject

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSString * icon;
@property(nonatomic,retain) NSString *desc;
@property (nonatomic, strong) NSString * infoId;
@property (nonatomic, assign) NSInteger isCreate;
@property (nonatomic, assign) NSInteger isSubscribe;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger condition;

@end
