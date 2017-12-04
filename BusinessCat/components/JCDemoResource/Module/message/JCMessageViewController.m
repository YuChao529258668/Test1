//
//  MessageViewController.m
//  UltimateEdu
//
//  Created by young on 2017/5/18.
//  Copyright © 2017年 young. All rights reserved.
//

#import "JCMessageViewController.h"
#import "JCMessageCell.h"
#import <JCApi/JCApi.h>
#import "UITableView+FDTemplateLayoutCell.h"

NSString * const kDataTypeMessage = @"DATA_TYPE_MESSAGE";
static NSString *messageCellId = @"MessageCellId";

@interface JCMessageViewController () <UITableViewDataSource, UITableViewDelegate, JCEngineDelegate>
{
    NSMutableArray *_dataSource;
    BOOL _scroolToBottom;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *bottomButton;

@property (nonatomic, strong) UILabel *tempLabel;

@end

@implementation JCMessageViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"MessageCell" bundle:nil] forCellReuseIdentifier:messageCellId];
    }
    return _tableView;
}

- (UIButton *)bottomButton
{
    if (!_bottomButton) {
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect rect = self.view.bounds;
        _bottomButton.frame = CGRectMake((CGRectGetWidth(rect) - 20) / 2, CGRectGetHeight(rect) - 20 -5, 60, 20);
        _bottomButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        _bottomButton.titleLabel.font = [UIFont systemFontOfSize:8];
        _bottomButton.backgroundColor = [UIColor whiteColor];
        [_bottomButton setTitle:@"底部有新消息" forState:UIControlStateNormal];
        [_bottomButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_bottomButton addTarget:self action:@selector(scrollToBottom) forControlEvents:UIControlEventTouchUpInside];
        _bottomButton.hidden = YES;
    }
    
    return _bottomButton;
}

- (UILabel *)tempLabel
{
    if (!_tempLabel) {
        _tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 10, 20)];
        _tempLabel.numberOfLines = 0;
    }
    return _tempLabel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _nameColor = [UIColor colorWithRed:3.0f/255.0f green:141.0f/255.0f blue:210.0f/255.0f alpha:1.0f];
        _contentColor = [UIColor blackColor];
        _scroolToBottom = YES;
        _dataSource = [NSMutableArray array];
        [[JCEngineManager sharedManager] setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];

    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JCEngineDelegate
- (void)onDataReceive:(NSString *)key content:(NSString *)content fromSender:(NSString *)userId
{
    if (![key isEqualToString:kDataTypeMessage]) {
        return;
    }
    
    [self updateMessage:content fromSender:userId send:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JCMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:messageCellId forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(JCMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = _dataSource[indexPath.row];
    NSMutableAttributedString *name = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: ", array[0]] attributes:@{NSForegroundColorAttributeName: _nameColor}];
    NSAttributedString *message = [[NSAttributedString alloc] initWithString:array[1] attributes:@{NSForegroundColorAttributeName: _contentColor}];
    [name appendAttributedString:message];
    cell.messageLabel.attributedText = name;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:messageCellId configuration:^(JCMessageCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;
    if (bottomOffset <= height) {
        //在底部
        _scroolToBottom = YES;
        _bottomButton.hidden = YES;
    } else {
        _scroolToBottom = NO;
    }
}

- (void)sendMessage:(NSString *)message
{
    [[JCEngineManager sharedManager] sendData:kDataTypeMessage content:message toReceiver:nil];
    
    NSString *ownUserId = [[JCEngineManager sharedManager] getOwnUserId];
    if (!ownUserId) {
        ownUserId = [ObjectShareTool currentUserID];
    }
    [self updateMessage:message fromSender:ownUserId send:YES];
}

- (void)updateMessage:(NSString *)message fromSender:(NSString *)userId send:(BOOL)send
{
    if (message && userId) {
        NSString *name = [[JCEngineManager sharedManager] getParticipantWithUserId:userId].displayName;
        NSArray *array = @[name, message];
        [_dataSource addObject:array];
    }
    
    if (![self isViewLoaded]) {
        return;
    }
    
    [_tableView reloadData];
    
    if (send) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    } else {
        if (_scroolToBottom) {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        } else {
            //提示有新消息
            _bottomButton.hidden = NO;
        }
    }
}

- (void)scrollToBottom
{
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}
@end
