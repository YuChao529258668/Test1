//
//  OptionButton.h
//  ButtonView
//
//  Created by Justin on 2017/1/16.
//  Copyright © 2017年 Justin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCDoodleToolbar;

typedef NS_ENUM(NSUInteger, DoodleToolbarButtonType) {
//    DoodleToolbarButtonTypeDraw = 0,         //  涂鸦
    DoodleToolbarButtonTypeColour,           //  画笔颜色
    DoodleToolbarButtonTypeClear,            //  清除
    DoodleToolbarButtonTypeRevoke,            //  撤回
    DoodleToolbarButtonTypeFile,                 // 文件
    DoodleToolbarButtonTypeDraw         //  涂鸦
};

@protocol DoodleToolbarDelegate <NSObject>

/**
 按钮的代理事件

 @param doodleToolbar       BoardToolbar对象
 @param button              UIButton对象
 @param buttonType          提供这几种模式，@ref DoodleToolbarType
 */
- (void)doodleToolbar:(JCDoodleToolbar *)doodleToolbar clickButton:(UIButton *)button buttonType:(DoodleToolbarButtonType)buttonType;

@end

@interface JCDoodleToolbar : UIView
// 设置代理
@property (nonatomic, weak) id<DoodleToolbarDelegate> delegate;
// UIButton的对象数组
@property (nonatomic, readonly, strong) NSArray<UIButton *> *buttons;

//YES为按钮水平居中，NO为按钮左对齐，默认YES
@property (nonatomic) BOOL horizontalCenter;

@end
