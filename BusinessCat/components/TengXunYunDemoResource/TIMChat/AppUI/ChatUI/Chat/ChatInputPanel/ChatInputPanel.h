//
//  ChatInputPanel.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/17.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatInputPanel;

@protocol ChatInputPanelDelegate<NSObject>
- (void)didChangeFrame:(ChatInputPanel *)panel;
@end


@interface ChatInputPanel : ChatInputBaseView<ChatInputToolBarDelegate>
{
@protected
    ChatInputToolBar                    *_toolBar;
@protected
    __weak UIView<ChatInputAbleView>           *_panel;
    
@protected
    UIView<ChatInputAbleView>           *_emojPanel;
    UIView<ChatInputAbleView>           *_funcPanel;
}

@property (nonatomic,weak) id<ChatInputPanelDelegate> myDelegate ;


- (instancetype)initRichChatInputPanel;

- (void)setInputText:(NSString *)text;

- (IMAMsg *)getMsgDraft;

- (void)setMsgDraft:(IMAMsg *)draft;

@end


@interface RichChatInputPanel : ChatInputPanel

@end
