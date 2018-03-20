//
//  ChatTimeTipTableViewCell.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/16.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ChatTimeTipTableViewCell.h"

@interface ChatTimeTipTableViewCell()
@property (nonatomic, strong) UIView *bgView; // 灰色圆形

@end

@implementation ChatTimeTipTableViewCell

- (void)setupBgView {
    self.bgView = [UIView new];
    [self.contentView addSubview:self.bgView];
    [self.contentView sendSubviewToBack:self.bgView];
    self.bgView.backgroundColor =  [YCTool colorOfHex:0xe0e3e5];
}
- (void)layoutBgView {
    CGRect rect = self.textLabel.frame;
    //    self.textLabel.text = [NSString stringWithFormat:@"  %@  ", self.textLabel.text]; // 写上这句会死循环
    [self.textLabel sizeToFit];
    CGSize size2 = self.textLabel.size;
    self.textLabel.frame = rect;
    
    float height = size2.height  * 1.4;
    float width = size2.width + 30;
    CGRect frame = CGRectMake(0, 0, width, height);
    self.bgView.frame = frame;
    self.bgView.layer.cornerRadius = height/2;
    self.bgView.center = self.textLabel.center;
}

- (BOOL)canShowMenu
{
    return NO;
}

- (instancetype)initWithC2CReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = kClearColor;
        self.backgroundColor = kClearColor;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 0;
        
        [self setupBgView];
    }
    return self;
}
- (instancetype)initWithGroupReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super init])
    {
        self.contentView.backgroundColor = kClearColor;
        self.backgroundColor = kClearColor;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 0;
        
        [self setupBgView];
    }
    return self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    // do nothing
}

- (void)relayoutFrameOfSubViews
{
    [self layoutBgView];
}


- (void)addC2CCellViews
{
    // do nothing
    
}

- (void)addGroupCellViews
{
    // do nothing
}

- (void)relayoutC2CCellViews
{
    // do nothing
}
- (void)relayoutGroupCellViews
{
    // do nothing
}

- (void)configKVO
{
    // do nothing
}

- (void)configWith:(IMAMsg *)msg
{
    _msg = msg;
    TIMCustomElem *elem = (TIMCustomElem *)[msg.msg getElem:0];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [_msg tipFont];
//    self.textLabel.textColor = kLightGrayColor;
    self.textLabel.textColor = [YCTool colorOfHex:0x555555];
    self.textLabel.text = [elem timeTip];
}

- (void)configContent
{
    
}

- (void)configElemContent
{
    
}
- (void)configSendingTips
{
    // do nothing
}



- (void)showMenu
{
    // do nothing
}

- (NSArray *)showMenuItems
{
    // do nothing
    return nil;
    
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}


@end


@implementation ChatGroupTipTableViewCell

- (void)layoutBgView {
    [super layoutBgView];
    if (self.bgView.frame.size.height > 40) {
        self.bgView.layer.cornerRadius = 6;
    }
}

- (void)configWith:(IMAMsg *)msg
{
    _msg = msg;
    TIMGroupTipsElem *elem = (TIMGroupTipsElem *)[msg.msg getElem:0];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [_msg tipFont];
//    self.textLabel.textColor = kLightGrayColor;
    self.textLabel.text = [elem tipText];
    
    self.textLabel.textColor = [YCTool colorOfHex:0x555555];
}
@end

@implementation ChatSaftyTipTableViewCell

- (void)configWith:(IMAMsg *)msg
{
    _msg = msg;
    TIMElem* elem = [msg.msg getElem:0];
    if ([elem isKindOfClass:[TIMCustomElem class]])
    {
        CustomElemCmd *elemCmd = [CustomElemCmd parseCustom:(TIMCustomElem *)elem];
        if (elemCmd)
        {
            self.textLabel.textAlignment = NSTextAlignmentCenter;
            self.textLabel.font = [_msg tipFont];
            self.textLabel.textColor = kLightGrayColor;
            self.textLabel.text = elemCmd.actionParam;
        }
    }
}

@end

@implementation RevokedTipTableViewCell

- (void)configWith:(IMAMsg *)msg
{
    _msg = msg;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [_msg tipFont];
    self.textLabel.textColor = kLightGrayColor;
    NSString *selfId = [IMAPlatform sharedInstance].host.loginParm.identifier;
    TIMCustomElem *elem = (TIMCustomElem *)[_msg.msg getElem:0];
    NSDictionary *info = [NSJSONSerialization JSONObjectWithData:elem.data options:NSJSONReadingMutableLeaves error:nil];
    NSString *msgSender = [info objectForKey:@"sender"];
    if ([selfId isEqualToString:msgSender]) {
        self.textLabel.text = [NSString stringWithFormat:@"你撤回了一条消息"];
    }
    else
    {
        self.textLabel.text = [NSString stringWithFormat:@"\"%@\" 撤回了一条消息",msgSender];
    }
}

@end
