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

// 可能包含重复的，因为一个朋友可以加入多个公司。用于判断是否显示勾勾
@property (nonatomic,strong) NSMutableArray<CGUserCompanyContactsEntity *> *contactsMayDuplicate;
// 没有重复的。用于创建群聊
@property (nonatomic,strong) NSMutableArray<CGUserCompanyContactsEntity *> *contactsNoDuplicate;
// 没有重复。用于判断是否要添加到 contactsNoDuplicate
@property (nonatomic,strong) NSMutableArray<NSString *> *selectedContactIDs;

@property (nonatomic,strong) UIButton *cancleBtn; // 取消
@property (nonatomic,strong) UIButton *completeBtn; // 完成选择

@end


@implementation CGSelectContactsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxSelectCount = NSUIntegerMax;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupCompleteBtn];
    [self setupCancleBtn];
    [self configTableView];
    self.titleView.text = self.titleForBar;
    
    if (self.contacts) {
        self.contactsMayDuplicate = [NSMutableArray arrayWithArray:self.contacts];
        self.contactsNoDuplicate = [NSMutableArray arrayWithArray:self.contacts];
        self.selectedContactIDs = [NSMutableArray new];
        for (CGUserCompanyContactsEntity *contact in self.contacts) {
            [self.selectedContactIDs addObject:contact.userId];
        }
    } else {
        self.contactsMayDuplicate = [NSMutableArray new];
        self.contactsNoDuplicate = [NSMutableArray new];
        self.selectedContactIDs = [NSMutableArray new];
    }
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

- (void)configRightBtn {
    if (self.selectedContactIDs.count > 0) {
        self.cancleBtn.hidden = YES;
        self.completeBtn.hidden = NO;
    } else {
        self.cancleBtn.hidden = NO;
        self.completeBtn.hidden = YES;
    }
}


#pragma mark - Setup

- (void)setupCompleteBtn {
    UIButton *btn = [[UIButton alloc] initWithFrame:self.rightBtn.frame];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.hidden = YES;
    self.completeBtn = btn;
    [self.rightBtn removeFromSuperview];
    [self.navi addSubview:btn];
}

- (void)setupCancleBtn {
    UIButton *btn = [[UIButton alloc] initWithFrame:self.rightBtn.frame];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.cancleBtn = btn;
    [self.rightBtn removeFromSuperview];
    [self.navi addSubview:btn];
}


#pragma mark - Actions

- (void)cancleBtnClick {
    [self dismissViewController];
}

- (void)completeBtnClick {
    if (self.completeBtnClickBlock) {
        self.completeBtnClickBlock(self.contactsNoDuplicate);
    }
    [self dismissViewController];
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
    if (self.selectedContactIDs.count > self.maxSelectCount) {
        [CTToast showWithText:[NSString stringWithFormat: @"选择人数不能大于 %ld", self.maxSelectCount]];
        return;
    }
    
    CGUserCompanyContactsEntity *contact = [self contactAtIndexPath:indexPath];
    if (!contact.userId) {
        return;
    }
    
    [self.contactsMayDuplicate addObject:contact];
    
    if (![self.selectedContactIDs containsObject:contact.userId]) {
//        NSLog(@"未包含 %@", contact.userName);
        [self.selectedContactIDs addObject:contact.userId];
        [self.contactsNoDuplicate addObject: contact];
    } else {
//        NSLog(@"已包含 %@", contact.userName);
    }
    [self configRightBtn];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    CGUserCompanyContactsEntity *contact = [self contactAtIndexPath:indexPath];
    
    [self removeContactWithID:contact.userId];
    [self configRightBtn];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CGUserCompanyContactsEntity *contact = [self contactAtIndexPath:indexPath];
    
    if ([self isContactsMayDuplicateContainsContact:contact]) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


#pragma mark - 判断是否包含某个联系人

- (BOOL)isContactsMayDuplicateContainsContact:(CGUserCompanyContactsEntity *)contact {
    BOOL contains = NO;
    
    for (CGUserCompanyContactsEntity *entity in self.contactsMayDuplicate) {
        if ([entity.userId isEqualToString:contact.userId]) {
            contains = YES;
            break;
        }
    }
    return contains;
}


#pragma mark - 删除某个联系人

- (void)removeContactWithID:(NSString *)userID {
    for (CGUserCompanyContactsEntity *contact in self.contactsMayDuplicate) {
        if ([contact.userId isEqualToString:userID]) {
            [self.contactsMayDuplicate removeObject:contact];
            break;
        }
    }
    
    for (CGUserCompanyContactsEntity *contact in self.contactsNoDuplicate) {
        if ([contact.userId isEqualToString:userID]) {
            [self.contactsNoDuplicate removeObject:contact];
            break;
        }
    }

    [self.selectedContactIDs removeObject:userID];
}

@end
