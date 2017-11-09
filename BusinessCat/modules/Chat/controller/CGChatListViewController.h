//
//  CGChatListViewController.h
//  CGKnowledge
//
//  Created by 余超 on 2017/10/30.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CTBaseViewController.h"

#import "ConversationListViewController.h"

//// 巫总 token
//#define kUserSig @"eJxlj01PhDAURff8CsIW0dIPOpi4cBjHMBk0fgVlQwotpAGhoRXGGP*7ipNI4tue8*5798Oybdt53D*csrLs3zqTm3clHPvcdoBz8geVkjxnJkcD-wfFQclB5KwyYpihTwiBACwdyUVnZCWPBqLcRxQhL6AV9nAIAo9VBfdQUZCQwtIXIV5sa97k8wu-8fg7G9MVpUtF1jNMrp6i*C6a5BAHqwTcZOUhTROt9229vrzerWWKyvZeiPFl17mIxm4d19Wmy9wtIRPT42bCrG84728bo6OzNlVt-9ww1W5rk-nxxeKkka-i2BeEASSQogUdxaBl380CBD7xIQI-41if1hcD-WVC"
//// 巫总 id
//#define kTestUserID @"37d13733-67f4-4906-afbd-3bb5972c1e94"

// 嘉林 token
#define kUserSig @"eJxlj8tOg0AUhvc8BWGLyFwYoCYuVBpFC9jQWnRDgBnI0HARhl40vrsVNZJ4tt-3n3P*d0mWZWW1CM*TLGuGWsTi2DJFvpAVoJz9wbblNE5EjDv6D7JDyzsWJ7lg3QghIQQBMHU4ZbXgOf81AMhMRIFmZ4Rphp0ALZ1BqFGTpDgnMIEIT9I93cbjC99h47TbsGzLmiq8GKE3X9*4S6fxxfz2vqFHnaab8O7JqIbsmvqLfeQEXv4MTb-G9quIQnLlFhHymhdcBqUDuakysFr2uhtkb5ut2hXBw*OhGlQ935e4XV9OTgpesZ**YGYigixjQnes63lTjwICkJwaga9RpA-pE3XbY9s_"
// 嘉林 id
#define kTestUserID @"100c62d0-8c5e-48a0-b911-d65b3f51a123"


//@interface CGChatListViewController : CTBaseViewController
@interface CGChatListViewController : ConversationListViewController
@property(nonatomic, strong)NSString *titleStr;

//点击tabitem事件
- (void)tabbarSelectedItemAction:(NSDictionary *)dict;

//获取token回调 state:YES-成功 NO-失败
- (void)tokenCheckComplete:(BOOL)state;

@end

