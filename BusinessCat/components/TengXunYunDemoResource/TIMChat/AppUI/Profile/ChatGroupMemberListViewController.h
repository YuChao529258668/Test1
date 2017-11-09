//
//  ChatGroupMemberListViewController.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/4.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TableRefreshViewController.h"

#import "IMAContactManager+Group.h"

@interface ChatGroupMemberListViewController : TableRefreshViewController
{
@protected
    IMAGroup    *_group;
    
    NSMutableDictionary *_memberDic;
    
}

@property(nonatomic, strong)NSString *titleStr;
@property(nonatomic,strong)UIView *navi;
@property(nonatomic,strong)UILabel *titleView;

- (instancetype)initWith:(IMAGroup *)group;

- (void)loadMember;
@end
