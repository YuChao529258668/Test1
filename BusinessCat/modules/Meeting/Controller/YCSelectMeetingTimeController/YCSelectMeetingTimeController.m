//
//  YCSelectMeetingTimeController.m
//  BusinessCat
//
//  Created by 余超 on 2017/11/22.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "YCSelectMeetingTimeController.h"

#import "YCMeetingBiz.h"

#define kYCDateButtonWidth 36
#define kYCDateLabelHeight 12

@interface YCSelectMeetingTimeController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UIButton *selectedBtn;
@property (nonatomic,strong) NSMutableArray<UIButton *> *btns;
@property (nonatomic,strong) NSMutableArray<UILabel *> *labels;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriteLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//@property (nonatomic,strong) NSArray *displayModels;
//@property (nonatomic,strong) NSArray<NSArray *> *allArray;
//@property (nonatomic,strong) NSMutableArray *dateArray;// 7天的日期
@property (nonatomic,strong) NSArray<YCAvailableMeetingTimeList *> *timeListArray;
//@property (nonatomic,strong) NSMutableArray *labelTexts; // 星期几

@end


@implementation YCSelectMeetingTimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.contentView.layer.cornerRadius = 8;
    self.descriteLabel.textColor = [UIColor blueColor];
    
//    [self setupTapGesture];
    [self setupLabels];
    [self setupButtons];
    [self getAvaliableTime];
    
    self.selectedBtn = self.btns.firstObject;
    [self.selectedBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Meeting" bundle:nil];
        self = [sb instantiateViewControllerWithIdentifier:@"YCSelectMeetingTimeController"];
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}


#pragma mark - Setup

- (void)setupButtons {
    self.btns = [NSMutableArray arrayWithCapacity:7];
    for (int i = 0; i < 7; i ++) {
        UIButton *btn = [UIButton new];
        btn.layer.cornerRadius = kYCDateButtonWidth / 2;
        btn.clipsToBounds = YES;
        [btn addTarget:self action:@selector(dateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        [self.btns addObject:btn];
    }
//    self.btns.firstObject.titleLabel.textColor = [UIColor darkGrayColor];
//    self.btns.lastObject.titleLabel.textColor = [UIColor darkGrayColor];
}

- (void)setupLabels {
    self.labels = [NSMutableArray arrayWithCapacity:7];
    NSArray *titles = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    for (int i = 0; i < 7; i ++) {
        UILabel *label = [UILabel new];
        label.text = titles[i];
        label.textAlignment = NSTextAlignmentCenter;
        [label setFont:[UIFont systemFontOfSize:10]];
        [self.contentView addSubview:label];
        [self.labels addObject:label];
    }
//    self.labels.firstObject.textColor = [UIColor darkGrayColor];
//    self.labels.lastObject.textColor = [UIColor darkGrayColor];
}

//- (void)setupDateArray {
//    self.dateArray = [NSMutableArray arrayWithCapacity:self.timeListArray.count];
//    NSDate *now = [NSDate date];
//    [self.dateArray addObject:now];
//    for (int i = 1; i < 7; i ++) {
//        NSDate *date = [NSDate dateWithTimeInterval:i * 24 * 60 * 60 sinceDate:now];
//        [self.dateArray addObject:date];
//    }
//}

- (void)setupTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - Action

- (void)dateButtonClick:(UIButton *)btn {
    self.selectedBtn.backgroundColor = [UIColor clearColor];
//    if (self.selectedBtn == self.btns.firstObject || self.selectedBtn == self.btns.lastObject) {
//        [self.selectedBtn.titleLabel setTextColor:[UIColor darkGrayColor]];
//    }
    
    btn.backgroundColor = CTThemeMainColor;
    [btn.titleLabel setTextColor:[UIColor blackColor]];

    NSUInteger index = [self.btns indexOfObject:btn];
    [self.collectionView reloadData];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: self.timeListArray[index].date.doubleValue/1000];
    [self updateDateLabel:date];
    
    self.selectedBtn = btn;
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    // self.view 添加tap手势后，cell 的 textField.enable = no 的时候， 点击 cell 不会触发代理 didselect 方法，好奇怪
    // self.view 添加tap手势后，点击子视图(一个 UIVIew 对象)，也会触发手势，好奇怪
    CGPoint location = [tap locationInView:self.contentView];
    if (CGRectContainsPoint(self.contentView.bounds, location)) {
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Data

- (void)getAvaliableTime {
    __weak typeof(self) weakself = self;
    [[YCMeetingBiz new] getMeetingRoomTimeWithRoomID:self.room.roomid success:^(NSArray *times) {
        weakself.timeListArray = times;
        [weakself.collectionView reloadData];
        
        [weakself updateDateLabel:nil];
        [weakself updateLabelTexts];
        [weakself updateButtonsTitle];
    } fail:^(NSError *error) {
        [CTToast showWithText:@"获取可用时间失败"];
    }];
}


#pragma mark - Update

// 传 nil 默认第一个
- (void)updateDateLabel:(NSDate *)date {
    if (!date) {
        date = [NSDate dateWithTimeIntervalSince1970:self.timeListArray.firstObject.date.doubleValue/1000];
    }
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"yyyy年MM月dd日";
    self.dateLabel.text = [f stringFromDate:date];
}

- (void)updateLabelTexts {
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"EE"; // 周五
    
    for (YCAvailableMeetingTimeList *list in self.timeListArray) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:list.date.doubleValue/1000];
        NSString *week = [f stringFromDate:date];
        week = [week substringFromIndex:week.length-1];
        
        NSUInteger i = [self.timeListArray indexOfObject:list];
        self.labels[i].text = week;
    }
}

- (void)updateButtonsTitle {
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"dd";
    
    for (int i = 0; i < self.timeListArray.count; i ++) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970: self.timeListArray[i].date.doubleValue/1000];
        UIButton *btn = self.btns[i];
        [btn setTitle:[f stringFromDate:date] forState:UIControlStateNormal];
    }
}


#pragma mark - Layout

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    int leftSpace = 6;
    int labelY = 56;
    int btnY = 70;
    
    float bigWidth = self.contentView.frame.size.width;
    float labelWidth = (bigWidth - leftSpace *2) / 7;
    CGRect frame = CGRectMake(0, labelY, labelWidth, kYCDateLabelHeight);
    
    for (int i =0; i < 7; i ++) {
        frame.origin.x = i *labelWidth +leftSpace;
        self.labels[i].frame = frame;
    }
    
    CGRect rect = CGRectMake(0, btnY, kYCDateButtonWidth, kYCDateButtonWidth);
    for (int i = 0; i < 7; i ++) {
        self.btns[i].frame = rect;
        CGPoint center = self.btns[i].center;
        center.x = self.labels[i].center.x;
        self.btns[i].center = center;
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger index = [self.btns indexOfObject:self.selectedBtn];
    return self.timeListArray[index].result.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = [self.btns indexOfObject:self.selectedBtn];
    YCAvailableMeetingTimeList *list = self.timeListArray[index];
    YCAvailableMeetingTime *time = list.result[indexPath.item];

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UITextField *tf = [cell viewWithTag:2];
    tf.text = time.info;
//    tf.text = @"23:59-23:59";
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectTime) {
        NSUInteger index = [self.btns indexOfObject:self.selectedBtn];
        YCAvailableMeetingTimeList *list = self.timeListArray[index];
        YCAvailableMeetingTime *time = list.result[indexPath.item];

        self.didSelectTime(time);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    UITextField *tf = [cell viewWithTag:2];
//    tf.allow
    tf.adjustsFontSizeToFitWidth = YES;
    tf.textColor = [UIColor blueColor];
}

@end
