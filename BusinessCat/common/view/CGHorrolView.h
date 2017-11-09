//
//  CGHorrolView.h
//  CGSays
//
//  Created by mochenyang on 2016/9/26.
//  Copyright © 2016年 cgsyas. All rights reserved.
//  横向滚动控件

#import <UIKit/UIKit.h>
#import "TeamCircleLastStateEntity.h"
#import "CGHorrolEntity.h"

typedef void (^CGHorrolViewBlock)(int index,CGHorrolEntity *data,BOOL clickOnShow);

@interface CGHorrolView : UIView

@property(nonatomic,retain)UIScrollView *scrollview;

@property(nonatomic,retain)NSMutableArray *array;

//初始化，使用block的方式，提供选中回调到外部
-(instancetype)initWithFrame:(CGRect)frame array:(NSMutableArray *)array finish:(CGHorrolViewBlock)finish;

//供外部主动调用选中某个Item
-(void)setSelectIndex:(int)index;

//动态改变名字
-(void)setNameByIndex:(int)index name:(NSString *)name;

-(void)insertEntity:(CGHorrolEntity *)entity;

-(void)replaceEntity:(CGHorrolEntity *)entity;

-(void)notificationDiscoverHasLastDataWith:(TeamCircleLastStateEntity *)entity;

@end
