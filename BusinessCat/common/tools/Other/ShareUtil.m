//
//  ShareUtil.m
//  CGSays
//
//  Created by mochenyang on 2016/10/10.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "ShareUtil.h"
//#import "UMSocialUIManager.h"
#import <UMengUShare/UShareUI/UMSocialUIManager.h>
#import <UMSocialCore/UMSocialCore.h>
#import "ZYShareView.h"
#import "CGQrCodeView.h"

@interface ShareUtil(){
    
}

@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSString *desc;
@property(nonatomic,retain)id image;
@property(nonatomic,retain)NSString *url;
@property(nonatomic,retain)UIView *target;


@end

@implementation ShareUtil

-(void)showShareMenuWithTitle:(NSString *)title desc:(NSString *)desc image:(id)image url:(NSString *)url view:(UIView *)view{
    self.title = title;
    self.desc = desc;
    self.image = image;
    self.url = url;
    self.target = view;
    if(![CTStringUtil stringNotBlank:self.desc]){
        self.desc = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    }
    if(![CTStringUtil stringNotBlank:self.image]){
        self.image = [UIImage imageNamed:@"mainicon"];
    }
    
    __weak typeof(self) weakSelf = self;
    //显示分享面板
  [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
    [weakSelf shareDataWithPlatform:platformType];
  }];
}

-(void)showShareMenuWithTitle:(NSString *)title desc:(NSString *)desc isqrcode:(BOOL)isqrcode image:(id)image url:(NSString *)url block:(CGSystemShare)success{
  self.title = title;
  self.desc = desc;
  self.image = image;
  self.url = url;
  __weak typeof(self) weakSelf = self;
  NSMutableArray *array = [NSMutableArray array];
  
  if ([WXApi isWXAppInstalled]) {
    //微信
    ZYShareItem *item1 = [ZYShareItem itemWithTitle:@"微信"
                                               icon:@"weixinhaoyou"
                                            handler:^{
                                                [weakSelf shareDataWithPlatform:UMSocialPlatformType_WechatSession];
                                            }];
    [array addObject:item1];
    if (!self.isDownFire) {
      ZYShareItem *item2 = [ZYShareItem itemWithTitle:@"微信朋友圈"
                                                 icon:@"wixinpengyouquan"
                                              handler:^{
                                                  [weakSelf shareDataWithPlatform:UMSocialPlatformType_WechatTimeLine];
                                              }];
      [array addObject:item2];
      ZYShareItem *item3 = [ZYShareItem itemWithTitle:@"微信收藏"
                                                 icon:@"weixinshouc"
                                              handler:^{
                                                  [weakSelf shareDataWithPlatform:UMSocialPlatformType_WechatFavorite];
                                              }];
      [array addObject:item3];
    }
  }
  
  if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
    
    NSLog(@"install--");
    ZYShareItem *item4 = [ZYShareItem itemWithTitle:@"QQ"
                                               icon:@"QQ"
                                            handler:^{ [weakSelf shareDataWithPlatform:UMSocialPlatformType_QQ];
                                            }];
    [array addObject:item4];
    if (!self.isDownFire) {
      ZYShareItem *item5 = [ZYShareItem itemWithTitle:@"QQ空间"
                                                 icon:@"QQkongjian"
                                              handler:^{ [weakSelf shareDataWithPlatform:UMSocialPlatformType_Qzone];
                                              }];
      [array addObject:item5];
    }
  }
  
    BOOL hasSinaWeibo = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibosso://wb4266495195"]];
  if (hasSinaWeibo) {
    // 创建代表每个按钮的模型
    if (!self.isDownFire) {
      ZYShareItem *item0 = [ZYShareItem itemWithTitle:@"新浪"
                                                 icon:@"xinlangweibo"
                                              handler:^{[weakSelf shareDataWithPlatform:UMSocialPlatformType_Sina];
                                              }];
      [array addObject:item0];
    }
  }
  
  NSMutableArray *systemArray = [NSMutableArray array];
  if (!self.isDownFire) {
    ZYShareItem *item7 = [ZYShareItem itemWithTitle:@"系统分享"
                                               icon:@"toutiaoxitongfenxiang"
                                            handler:^{
                                              NSMutableArray *array = [NSMutableArray array];
                                              if (title.length>0) {
                                                [array addObject:title];
                                              }
                                              if (image) {
                                                [array addObject:image];
                                              }
                                              if (url.length>0) {
                                                [array addObject:url];
                                              }
                                              success(array);
                                            }];
    [systemArray addObject:item7];
  }
  ZYShareItem *item8 = [ZYShareItem itemWithTitle:@"复制链接"
                                             icon:@"ttoutiaofuzhilianjie"
                                          handler:^{
                                            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                                            NSString *str = [NSString stringWithFormat:@"%@ %@",title,url];
                                            pasteboard.string = str;
                                            UIWindow *window = [UIApplication sharedApplication].keyWindow;
                                            [[CTToast makeText:@"已完成复制!"]show:window];
                                          }];
  [systemArray addObject:item8];
  if (isqrcode&&!self.isDownFire) {
    ZYShareItem *item9 = [ZYShareItem itemWithTitle:[self.title isEqualToString:@"好友邀请你使用沟通猫"]?@"H5二维码":@"二维码"
                                               icon:@"QRcode_shareit"
                                            handler:^{
                                              CGQrCodeView *view = [[CGQrCodeView alloc]initWithUrl:self.url];
                                              UIWindow *window = [UIApplication sharedApplication].keyWindow;
                                              [window addSubview:view];
                                            }];
    [systemArray addObject:item9];
  }
  if ([self.title isEqualToString:@"好友邀请你使用沟通猫"]) {
    ZYShareItem *item10 = [ZYShareItem itemWithTitle:@"微信公众号"
                                                icon:@"QRcode_shareit"
                                             handler:^{
                                               CGQrCodeView *view = [[CGQrCodeView alloc]init];
                                               UIWindow *window = [UIApplication sharedApplication].keyWindow;
                                               [window addSubview:view];
                                             }];
    [systemArray addObject:item10];
  }
  
  NSArray *shareItemsArray = array;
  
  NSArray *functionItemsArray = systemArray;
  
  // 创建shareView
  ZYShareView *shareView = [ZYShareView shareViewWithShareItems:shareItemsArray
                                                  functionItems:functionItemsArray];
  // 弹出shareView
  [shareView show];
}

- (void)shareDataWithPlatform:(UMSocialPlatformType)platformType{
    // 分享数据对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
  if ([self.image isKindOfClass:[NSString class]]) {
    if (![self.image hasPrefix:@"https"]) {
      self.image = [UIImage imageNamed:@"login_image"];
    }
  }
    if(platformType == UMSocialPlatformType_Sina || platformType == UMSocialPlatformType_TencentWb){//新浪微博、腾讯微博
        messageObject.text = [NSString stringWithFormat:@"%@。%@",self.desc,self.url];
        UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:[CTStringUtil stringNotBlank:self.title]?self.title:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"] descr:self.desc thumImage:self.image];
        [shareObject setShareImage:self.image];
        messageObject.shareObject = shareObject;
    }else{
        // 1、纯文本分享
        messageObject.text = self.desc;
      UMShareWebpageObject *webObject = [UMShareWebpageObject shareObjectWithTitle:[CTStringUtil stringNotBlank:self.title]?self.title:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"] descr:self.desc thumImage:self.image];
        [webObject setWebpageUrl:self.url];
        messageObject.shareObject = webObject;
    }
  
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self.target completion:^(id result, NSError *error) {
        NSString *message = nil;
        if (!error) {
            message = [NSString stringWithFormat:@"分享成功"];
        } else {
            message = [NSString stringWithFormat:@"分享失败%ld",(long)error.code];
        }
        [[CTToast makeText:message]show:[UIApplication sharedApplication].keyWindow];
    }];
}

@end
