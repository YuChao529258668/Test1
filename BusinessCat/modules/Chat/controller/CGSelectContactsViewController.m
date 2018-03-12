//
//  CGSelectContactsViewController.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/4.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGSelectContactsViewController.h"
#import "CGUserCompanyContactsEntity.h"

@interface CGSelectContactsViewController ()<UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

// 可能包含重复的，因为一个朋友可以加入多个公司。用于判断是否显示勾勾
@property (nonatomic,strong) NSMutableArray<CGUserCompanyContactsEntity *> *contactsMayDuplicate;
// 没有重复的。用于创建群聊
@property (nonatomic,strong) NSMutableArray<CGUserCompanyContactsEntity *> *contactsNoDuplicate;
// 没有重复。用于判断是否要添加到 contactsNoDuplicate
@property (nonatomic,strong) NSMutableArray<NSString *> *selectedContactIDs;

@property (nonatomic,strong) UIButton *cancleBtn; // 取消
@property (nonatomic,strong) UIButton *completeBtn; // 完成选择

@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *sureBtnOnBottomBar; // 底部栏的确定按钮

@end


@implementation CGSelectContactsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxSelectCount = 99;
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
    
    self.tableViewBottomConstraint.constant = 43;
    [self setupBottomBar];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self layoutBottomBar];
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
        
        NSString *title = [NSString stringWithFormat:@"确定(%ld/%ld)",self.contactsNoDuplicate.count , self.maxSelectCount];
        [self.sureBtnOnBottomBar setTitle:title forState:UIControlStateNormal];
        self.sureBtnOnBottomBar.backgroundColor = CTThemeMainColor;
        self.sureBtnOnBottomBar.userInteractionEnabled = YES;
    } else {
        self.cancleBtn.hidden = NO;
        self.completeBtn.hidden = YES;
        
        NSString *title = [NSString stringWithFormat:@"确定(%ld/%ld)",self.contactsNoDuplicate.count , self.maxSelectCount];
        [self.sureBtnOnBottomBar setTitle:title forState:UIControlStateNormal];
        self.sureBtnOnBottomBar.backgroundColor = [UIColor lightGrayColor];
        self.sureBtnOnBottomBar.userInteractionEnabled = NO;
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

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(31, 31);
    layout.minimumInteritemSpacing = 12;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 0);
    
    UICollectionView *cv = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView = cv;
    [cv registerClass:NSClassFromString(@"CGSelectContactsViewControllerCell") forCellWithReuseIdentifier:@"CGSelectContactsViewControllerCell"];
    cv.dataSource = self;
    cv.alwaysBounceHorizontal = YES;
    cv.backgroundColor = [UIColor clearColor];
}

- (void)setupBottomBar {
    self.bottomBar = [UIView new];
    [self.view addSubview:self.bottomBar];
    self.bottomBar.backgroundColor = [YCTool colorWithRed:245 green:245 blue:245 alpha:1];
    
    [self setupCollectionView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sureBtnOnBottomBar = btn;
    btn.layer.cornerRadius = 4;
    btn.backgroundColor = CTThemeMainColor;
    NSString *title = [NSString stringWithFormat:@"确定(0/%ld)", self.maxSelectCount];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    btn.userInteractionEnabled = NO;
    
    [self.bottomBar addSubview:self.collectionView];
    [self.bottomBar addSubview:self.sureBtnOnBottomBar];
}

- (void)layoutBottomBar {
    float barHeight = 43;
    float barY = self.view.frame.size.height - barHeight;

    float sureBtnWidth = 90;
    float sureBtnHeight = 35;
    float cvWidth = [UIScreen mainScreen].bounds.size.width - 15 *2 - sureBtnWidth;
    
    float sureBtnX = cvWidth + 15;
    float sureBtnY = barHeight / 2 - sureBtnHeight / 2;

    
    self.bottomBar.frame = CGRectMake(0, barY, [UIScreen mainScreen].bounds.size.width, barHeight);
    self.collectionView.frame = CGRectMake(0, 0, cvWidth, barHeight);
    self.sureBtnOnBottomBar.frame = CGRectMake(sureBtnX, sureBtnY, sureBtnWidth, sureBtnHeight);
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

// 不许高亮，就不能点击了
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedContactIDs.count >= self.maxSelectCount) {
        NSArray *ids = [tableView indexPathsForSelectedRows];
        if ([ids containsObject:indexPath]) {
            return YES;
        }
        
        [CTToast showWithText:[NSString stringWithFormat: @"选择人数不能大于 %ld", self.maxSelectCount]];
        return NO;
    } else {
        return YES;
    }
}

//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.selectedContactIDs.count >= self.maxSelectCount) {
//        [CTToast showWithText:[NSString stringWithFormat: @"选择人数不能大于 %ld", self.maxSelectCount]];
//        return nil;
//    } else {
//        return indexPath;
//    }
//}

// 不重写点击会跳到聊天界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
    [self.collectionView reloadData];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    CGUserCompanyContactsEntity *contact = [self contactAtIndexPath:indexPath];
    
    [self removeContactWithID:contact.userId];
    [self configRightBtn];
    [self.collectionView reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CGUserCompanyContactsEntity *contact = [self contactAtIndexPath:indexPath];
    
    if ([self isContactsMayDuplicateContainsContact:contact]) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.contactsNoDuplicate.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGUserCompanyContactsEntity *contact = self.contactsNoDuplicate[indexPath.item];

    CGSelectContactsViewControllerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CGSelectContactsViewControllerCell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor redColor];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:contact.userIcon] placeholderImage:[UIImage imageNamed:@"user_icon"]];
    return cell;
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


#pragma mark - CGSelectContactsViewControllerCell

@implementation CGSelectContactsViewControllerCell

- (void)config {
    UIImageView *iv = [[UIImageView alloc]initWithFrame:self.bounds];
    self.imageView = iv;
    [self.contentView addSubview:iv];
    
    iv.layer.cornerRadius = self.frame.size.width/2;
    iv.clipsToBounds = YES;
    iv.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self config];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}

@end
