//
//  CGSelectContactsViewController.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/4.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGSelectContactsViewController.h"
#import "CGUserCompanyContactsEntity.h"

@interface CGSelectContactsViewController ()<UITableViewDelegate>
//@interface CGSelectContactsViewController ()
// 可能包含重复的，因为一个朋友可以加入多个公司。用于判断是否显示勾勾
@property (nonatomic,strong) NSMutableArray<CGUserCompanyContactsEntity *> *contactsMayDuplicate;
// 没有重复的。用于创建群聊
@property (nonatomic,strong) NSMutableArray<CGUserCompanyContactsEntity *> *contactsNoDuplicate;
// 没有重复。用于判断是否要添加到 contactsNoDuplicate
@property (nonatomic,strong) NSMutableArray<NSString *> *selectedContactIDs;

@end

@implementation CGSelectContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupCompleteBtn];
    [self configTableView];
    self.titleView.text = self.titleForBar;
    
    self.contactsMayDuplicate = [NSMutableArray new];
    self.contactsNoDuplicate = [NSMutableArray new];
    self.selectedContactIDs = [NSMutableArray new];

}

- (void)configTableView {
    self.tableview.editing = YES;
    self.tableview.allowsMultipleSelectionDuringEditing = YES;
    //    self.tableview.allowsSelection = YES;
    //    self.tableview.allowsMultipleSelection = YES;
    self.tableview.delegate = self; // 如果不写这句，重写了方法，依然调用父类的方法吗？不写也会调用子类实现的方法。

    [self.searchBar removeFromSuperview];
    self.tableview.tableHeaderView = nil;
}

- (void)setupCompleteBtn {
    UIButton *btn = [[UIButton alloc] initWithFrame:self.rightBtn.frame];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightBtn removeFromSuperview];
    [self.navi addSubview:btn];
}

- (void)completeBtnClick {
    BOOL shouldDismiss = YES;
    
    if (self.completeBtnClickBlock) {
        shouldDismiss = self.completeBtnClickBlock(self.contactsNoDuplicate);
    }
    if (shouldDismiss) {
        [self dismissViewController];
    }
}

- (void)dismissViewController {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//- (void)fetchSelectedContacts {
//    NSArray *indexPaths = [self.tableview indexPathsForSelectedRows];
//    self.contacts = [NSMutableArray arrayWithCapacity:indexPaths.count];
//    CGUserCompanyContactsEntity *contact;
//
////    NSLog(@"____________________________-");
//    for (NSIndexPath *indexPath in indexPaths) {
//        contact = [self contactAtIndexPath:indexPath];
//        [self.contacts addObject: contact];
////        NSLog(@"user name = %@", contact.userName);
//    }
//}

#pragma mark - 重写

// 重写父类方法，用于多选
- (UITableViewCellSelectionStyle)tableViewCellSelectionStyle {
    return UITableViewCellSelectionStyleDefault;
}

#pragma mark - UITableViewDelegate

// 不重写点击会跳到聊天界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CGUserCompanyContactsEntity *contact;
    contact = [self contactAtIndexPath:indexPath];
    [self.contactsMayDuplicate addObject:contact];
    
    if (![self.selectedContactIDs containsObject:contact.userId]) {
//        NSLog(@"未包含 %@", contact.userName);
        [self.selectedContactIDs addObject:contact.userId];
        [self.contactsNoDuplicate addObject: contact];
    } else {
//        NSLog(@"已包含 %@", contact.userName);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    CGUserCompanyContactsEntity *contact;
    contact = [self contactAtIndexPath:indexPath];
    [self.contactsMayDuplicate removeObject:contact];
    [self.contactsNoDuplicate removeObject:contact];
    [self.selectedContactIDs removeObject:contact.userId];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CGUserCompanyContactsEntity *contact;
    contact = [self contactAtIndexPath:indexPath];
    
    if ([self.contactsMayDuplicate containsObject:contact]) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
