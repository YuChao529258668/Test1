//
//  CGSearchVoiceView.h
//  CGSays
//
//  Created by zhu on 2017/4/14.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CGSearchVoiceBlock)(NSString *content);
typedef void (^CGSearchTextFieldChangeBlock)(NSString *content);
@interface CGSearchVoiceView : UIView
@property (nonatomic, strong) UITextField *textField;
-(instancetype)initWithPlaceholder:(NSString *)placeholder voiceBlock:(CGSearchVoiceBlock)voiceBlock changeText:(CGSearchTextFieldChangeBlock)changeText;
@end
