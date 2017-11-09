//
//  SearchCellLayout.h
//  CGSays
//
//  Created by zhu on 2016/11/24.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "LWLayout.h"
#import "CGSearchSourceCircleEntity.h"

#define MESSAGE_TYPE_IMAGE @"image"
#define MESSAGE_TYPE_WEBSITE @"website"
#define MESSAGE_TYPE_VIDEO @"video"
#define AVATAR_IDENTIFIER @"avatar"

typedef NS_ENUM(NSInteger, SearchImageType) {
  SearchImageTypeText       = 1,
  SearchImageTypeImageText  = 2,
  SearchImageTypeLink       = 3,
  SearchImageTypeTopic      = 4
};

@interface SearchCellLayout : LWLayout

@property (nonatomic,strong) CGSearchSourceCircleEntity* entity;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,assign) CGRect lineRect;
@property (nonatomic,assign) CGRect menuPosition;
@property (nonatomic,assign) CGRect commentBgPosition;
@property (nonatomic,assign) CGRect avatarPosition;
@property (nonatomic,assign) CGRect websitePosition;
@property (nonatomic,copy) NSArray* imagePostions;

//文字过长时，折叠状态的布局模型
- (id)initWithStatusModel:(CGSearchSourceCircleEntity *)entity isUnfold:(BOOL)isUnfold dateFormatter:(NSDateFormatter *)dateFormatter;


////文字过长时，打开状态的布局模型
//- (id)initContentOpendLayoutWithStatusModel:(CGSearchSourceCircleEntity *)entity dateFormatter:(NSDateFormatter *)dateFormatter;



@end
