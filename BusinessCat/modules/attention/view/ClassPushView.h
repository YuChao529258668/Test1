//
//  ClassPushView.h
//  CGSays
//
//  Created by zhu on 2016/11/15.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ClassPushType) {
  ClassPushTypeThemeControl           = 0, //主题管理
  ClassPushTypeThemeCopy              = 1, //主题复制
  ClassPushTypeConditionControl       = 2, //条件管理
};

typedef void (^ClassPushViewBlock)(NSInteger selectIndex);
typedef void (^ClassPushTypeBlock)(NSInteger classPushType);
@interface ClassPushView : UIView
<UITableViewDelegate,UITableViewDataSource>
- (instancetype)initWithSelectIndex:(ClassPushViewBlock)index title:(NSString *)title;

- (void)setDataWithArray:(NSMutableArray *)array;

//弹出
- (void)showInView;
//收起
- (void)hiddenView;
@end
