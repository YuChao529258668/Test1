//
//  ConversationListViewController.m
//  TIMChat
//
//  Created by wilderliao on 16/2/16.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ConversationListViewController.h"

#import "ConversationListTableViewCell.h"
#import "SwipeDeleteTableView.h"

@interface ConversationListViewController ()<UISearchBarDelegate>
{
    
}
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, strong) NSMutableArray<id<IMAConversationShowAble>> *searchResult;

@end

@implementation ConversationListViewController

- (void)dealloc
{
    [self.KVOController unobserveAll];
}

- (void)addHeaderView
{
    
}
- (void)addFooterView
{
    
}

- (BOOL)hasData
{
    BOOL has = _conversationList.count != 0;
    return has;
}

- (void)addRefreshScrollView
{
    _tableView = [[SwipeDeleteTableView alloc] init];
    _tableView.frame = self.view.bounds;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = kClearColor;
    _tableView.scrollsToTop = YES;
    [self.view addSubview:_tableView];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView setTableFooterView:v];
    
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.refreshScrollView = _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"会话";
//    [self pinHeaderView];
    
//    [self setupSearchBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[IMAPlatform sharedInstance].conversationMgr releaseChattingConversation];
}

- (void)addSearchController
{
}

- (void)configOwnViews
{
    IMAConversationManager *mgr = [IMAPlatform sharedInstance].conversationMgr;
    _conversationList = [mgr conversationList];
    
    
    __weak ConversationListViewController *ws = self;
    mgr.conversationChangedCompletion = ^(IMAConversationChangedNotifyItem *item) {
        [ws onConversationChanged:item];
    };
    
    //    [[IMAPlatform sharedInstance].conversationMgr addConversationChangedObserver:self handler:@selector(onConversationChanged:) forEvent:EIMAConversation_AllEvents];
    
    
    
    self.KVOController = [FBKVOController controllerWithObserver:self];
    [self.KVOController observe:[IMAPlatform sharedInstance].conversationMgr keyPath:@"unReadMessageCount" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [ws onUnReadMessag];
    }];
    [ws onUnReadMessag];
}

- (void)onUnReadMessag
{
    NSInteger unRead = [IMAPlatform sharedInstance].conversationMgr.unReadMessageCount;
    
//    NSString *badge = nil;
//    if (unRead > 0 && unRead <= 99)
//    {
//        badge = [NSString stringWithFormat:@"%d", (int)unRead];
//    }
//    else if (unRead > 99)
//    {
//        badge = @"99+";
//    }
    
//    self.navigationController.tabBarItem.badgeValue = badge;
    [self setTabViewRedHot:unRead];
}

// 小红点
- (void)setTabViewRedHot:(NSInteger)count {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CTRootViewController *vc = delegate.rootController;
    [vc setConversationListTabViewRedPoint:count];
}

- (void)onConversationChanged:(IMAConversationChangedNotifyItem *)item
{
    if (self.isSearch) {
        return;
    }

    switch (item.type)
    {
        case EIMAConversation_SyncLocalConversation:
        {
            [self reloadData];
        }
            
            break;
        case EIMAConversation_BecomeActiveTop:
        {
            [self.tableView beginUpdates];
            [self.tableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:item.index inSection:0] toIndexPath:[NSIndexPath indexPathForRow:item.toIndex inSection:0]];
            [self.tableView endUpdates];
        }
            break;
        case EIMAConversation_NewConversation:
        {
            
            [self.tableView beginUpdates];
            NSIndexPath *index = [NSIndexPath indexPathForRow:item.index inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableView endUpdates];
        }
            break;
        case EIMAConversation_DeleteConversation:
        {
            [self.tableView beginUpdates];
            NSIndexPath *index = [NSIndexPath indexPathForRow:item.index inSection:0];
            [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
            break;
        case EIMAConversation_Connected:
        {
            [self.tableView beginUpdates];
            NSIndexPath *index = [NSIndexPath indexPathForRow:item.index inSection:0];
            [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
            break;
        case EIMAConversation_DisConnected:
        {
            [self.tableView beginUpdates];
            NSIndexPath *index = [NSIndexPath indexPathForRow:item.index inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
            break;
        case EIMAConversation_ConversationChanged:
        {
            [self.tableView beginUpdates];
            NSIndexPath *index = [NSIndexPath indexPathForRow:item.index inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableView endUpdates];
        }
            break;
        default:
            
            break;
    }
    
}
- (void)onRefresh
{
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self reloadData];
    //    });
}

#pragma mark -


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<IMAConversationShowAble> conv = [_conversationList objectAtIndex:indexPath.row];
    return [conv showHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSearch) {
        return self.searchResult.count;
    }
    
    [self callInNumberOfRowsInSection];
    NSArray *a = _conversationList.safeArray;
    return [_conversationList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 可能是 IMAConversation
    id<IMAConversationShowAble> conv;
    id<IMAConversationShowAble> tempCon;
    
    if (self.isSearch) {
        conv = self.searchResult[indexPath.row];
        tempCon = conv;
    } else {
        conv = [_conversationList objectAtIndex:indexPath.row];
//        tempCon = [[[IMAPlatform sharedInstance].conversationMgr conversationList] objectAtIndex:indexPath.row];
        tempCon = conv;
    }
    
    NSString *reuseidentifier = [conv showReuseIndentifier];//IMAConnectConversation_ReuseIndentifier

    ConversationListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseidentifier];
    if (!cell)
    {
        cell = [[[conv showCellClass] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseidentifier];
    }
    
    IMAConversation *con = (IMAConversation *)conv;
    if (con.isCustom) {
        [cell configCellWithTimeStr:con.customTimeStr lastMsg:con.customLastMsg badge:con.customBadge];
    } else {
        [conv attributedDraft];
        [tempCon attributedDraft];
        [cell configCellWith:conv];
    }
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return YES;
    IMAConversation *conv = [_conversationList objectAtIndex:indexPath.row];
    if (conv.isCustom) {
        return NO;
    }
    return !self.isSearch;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMAConversation *conv = [_conversationList objectAtIndex:indexPath.row];
    [[IMAPlatform sharedInstance].conversationMgr deleteConversation:conv needUIRefresh:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![ObjectShareTool currentUserID]) {
        [CTToast showWithText:@"尚未登录"];
        return;
    }
    
    id<IMAConversationShowAble> convable;
    if (self.isSearch) {
        convable = self.searchResult[indexPath.row];
    } else {
        convable = [_conversationList objectAtIndex:indexPath.row];
    }
    IMAConversation *con = (IMAConversation *)convable;
    if (con.isCustom) {
        [self clickAppMessage];
        return;
    }
    
    ConversationListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    IMAConversation *conv = (IMAConversation *)convable;
    switch ([convable conversationType])
    {
        case IMA_C2C:
        case IMA_Group:
        {
            IMAUser *user = [[IMAPlatform sharedInstance] getReceiverOf:conv];
            
            if (user)
            {   
                [[AppDelegate sharedAppDelegate] pushToChatViewControllerWith:user];
//                [self pushToChatViewControllerWith:user];
                
                [conv setReadAllMsg];
                
                [cell refreshCell];
            }
            else
            {
                if ([conv type] == TIM_C2C)
                {
                    // 与陌生人聊天
                    [[IMAPlatform sharedInstance] asyncGetStrangerInfo:[conv receiver] succ:^(IMAUser *auser) {
                        
                            [[AppDelegate sharedAppDelegate] pushToChatViewControllerWith:auser];
                            
                            [conv setReadAllMsg];
                            ConversationListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                            [cell refreshCell];
                        
                    } fail:^(int code, NSString *msg) {
                            DebugLog(@"Fail:--> code=%d,msg=%@,fun=%s", code, msg,__func__);
                            [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, msg)];
                            [[IMAPlatform sharedInstance].conversationMgr deleteConversation:conv needUIRefresh:YES];
                    }];
                }
                else if ([conv type] == TIM_GROUP)
                {
                    // 有可能是因为退群本地信息信息未同步
                    [[IMAPlatform sharedInstance].conversationMgr deleteConversation:conv needUIRefresh:YES];
                }
                
            }
        }
            break;
            
        case IMA_Sys_NewFriend:
        {
            [conv setReadAllMsg];
            [cell refreshCell];
            [IMAPlatform sharedInstance].contactMgr.hasNewDependency = NO;
            
            FutureFriendsViewController *vc = [[FutureFriendsViewController alloc] init:YES];
            [[AppDelegate sharedAppDelegate] pushViewController:vc];
        }
            break;
            
        case IMA_Sys_GroupTip:
        {
            [conv setReadAllMsg];
            [cell refreshCell];
            [IMAPlatform sharedInstance].contactMgr.hasNewDependency = NO;
            GroupSystemMsgViewController *vc = [[GroupSystemMsgViewController alloc] init];
            [[AppDelegate sharedAppDelegate] pushViewController:vc];
        }
            break;
            
        case IMA_Connect:
        default:
            break;
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - 搜索栏

- (void)setupSearchBar {
    UISearchBar *sb = [[UISearchBar alloc]initWithFrame:CGRectMake(0, TOPBARHEIGHT, SCREEN_WIDTH, 56)];
    self.searchBar = sb;
    [self.view addSubview:sb];
    
    sb.placeholder = @"请输入关键字";
    sb.delegate = self;
    sb.searchBarStyle = UISearchBarStyleMinimal;
    sb.returnKeyType = UIReturnKeyDone;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // 点击键盘的回车键有反应
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchWithText:searchText];
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
    self.isSearch = YES;
    [self.tableView reloadData];
    
//    ((SwipeDeleteTableView *)self.tableView).shouldBeginLeftSwipe = NO;
}

//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
//    // 点取消按钮会调用。点键盘没反应
//    return YES;
//}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = nil;
    [self.searchBar resignFirstResponder];
    
    self.isSearch = NO;
    [self.tableView reloadData];
    
//    ((SwipeDeleteTableView *)self.tableView).shouldBeginLeftSwipe = YES;
}

- (void)searchWithText:(NSString *)text {
//     CLSafeMutableArray
//    _conversationList
//    id<IMAConversationShowAble> conv = [_conversationList objectAtIndex:indexPath.row];
    
    self.searchResult = [NSMutableArray arrayWithCapacity:0];
    
    [_conversationList.safeArray enumerateObjectsUsingBlock:^(id<IMAConversationShowAble> conv, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[conv showTitle] containsString:text]) {
            [self.searchResult addObject:conv];
        }
    }];
}


#pragma mark - 子类重写

- (void)clickAppMessage {
    
}

- (void)callInNumberOfRowsInSection {
    
}

@end
