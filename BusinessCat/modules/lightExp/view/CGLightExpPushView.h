//
//  CGLightExpPushView.h
//  CGSays
//
//  Created by zhu on 2016/12/1.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGLightExpEntity.h"

typedef void (^CGLightExpPushViewReMoreGroupBlock)(CGLightExpEntity *reMoveEntity);
typedef void (^CGLightExpPushViewReMoreBlock)(NSMutableArray *array);
typedef void (^CGLightExpPushViewBlock)(NSArray *array);
typedef void (^CGLightExpPushViewSortBlock)(NSMutableArray *array);
typedef void (^CGLightExpPushViewAppClickBlock)(CGApps *app);
typedef void (^CGLightExpPushViewEditingBlock)(BOOL editing);
typedef void (^CGLightExpPushViewChangeNameBlock)(NSString *name);
typedef void (^CGLightExpPushViewAddGroupBlock)(NSString *groupId);
typedef void (^CGLightExpPushViewCancelpBlock)(BOOL isCancel);
@interface CGLightExpPushView : UIView
//初始化，使用block回调供外部进行相关的下一步操作
-(instancetype)initWithEntity:(CGLightExpEntity *)entity editing:(BOOL)editing block:(CGLightExpPushViewBlock)block sortBlock:(CGLightExpPushViewSortBlock)sortBlock remove:(CGLightExpPushViewReMoreBlock)remove removeGroup:(CGLightExpPushViewReMoreGroupBlock)removeGroup appClick:(CGLightExpPushViewAppClickBlock)appClick changeEditing:(CGLightExpPushViewEditingBlock)changeEditing changeName:(CGLightExpPushViewChangeNameBlock)changeName addGroup:(CGLightExpPushViewAddGroupBlock)addGroup cancel:(CGLightExpPushViewCancelpBlock)cancel;
//弹出
-(void)showInView:(UIView *)view;
-(void)reloadDataWithEntity:(CGLightExpEntity *)entity;
@end
