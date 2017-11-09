//
//  MenuView.h
//  UltimateShow
//
//  Created by 沈世达 on 17/4/6.
//  Copyright © 2017年 young. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCMenuView;

typedef NS_ENUM(NSUInteger, MenuButtonType) {
    MenuButtonTypeVideo = 0,    //  视频会议
    MenuButtonTypeDoodle,       //  白板涂鸦
    MenuButtonTypeShare         //  屏幕共享
};

@protocol MenuViewDelegate <NSObject>

- (void)menuView:(JCMenuView *)menuView clickButton:(UIButton *)button buttonType:(MenuButtonType)buttonType;

- (void)closeMenu;

@end

@interface JCMenuView : UIView

@property (nonatomic, weak) id<MenuViewDelegate> delegte;

@property (nonatomic, readonly, strong) NSArray<UIButton *> *buttons;

@end
