//
//  CGUerHeaderView.m
//  CGSays
//
//  Created by zhu on 16/10/17.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserHeaderView.h"
#import "CGUserHeaderCollectionViewCell.h"
#import <UIButton+WebCache.h>
@interface CGUserHeaderView()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) CGUserEntity *userInfo;

@end

@implementation CGUserHeaderView

- (instancetype)init
{
  self = [super init];
  if (self) {
    self.collectionView.delegate  = self;
    self.collectionView.dataSource = self;
  }
  return self;
}
+ (instancetype)userHeaderView {
  return [[[NSBundle mainBundle] loadNibNamed:@"CGUserHeaderView"
                                        owner:nil
                                      options:nil] lastObject];
}


+ (float)height{
  return 300;
}
- (void)addAchievementView{
  for (int i = 0 ; i < 6; i++) {
    UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 20, 17)];
    number.font = [UIFont systemFontOfSize:15];
    number.textColor = [CTCommonUtil convert16BinaryColor:@"#1191E3"];
    
  }
}

- (void)info:(CGUserEntity *)userInfo{
  self.userInfo = userInfo;
  if (userInfo.isLogin) {
    self.userName.text = userInfo.username.length>0?userInfo.username:userInfo.nickname;
    self.loginBtn.hidden = YES;
    self.userName.hidden = NO;
    self.privilegeView.hidden = NO;
    self.levelLabel.hidden = NO;
    self.levelTextLabel.hidden = NO;
    if (userInfo.gradeName.length<=0) {
      self.levelLabel.hidden = YES;
      self.levelBtn.hidden = YES;
      self.levelTextLabel.hidden = YES;
    }
    self.levelLabel.text = userInfo.gradeName;
    [self.levelBtn setBackgroundImage:[UIImage imageNamed:@"dengji"] forState:UIControlStateNormal];
    self.levelTextLabel.text = userInfo.grade;
    self.userIcon.hidden = NO;
    [self.userIcon sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/120/interlace/1",userInfo.portrait]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user_icon"]];
  }else{
    self.userIcon.hidden = YES;
    self.loginBtn.hidden = NO;
    self.userName.hidden = YES;
    self.privilegeView.hidden = YES;
    self.levelView.hidden = NO;
    self.levelLabel.hidden = YES;
    self.levelTextLabel.hidden = YES;
    self.levelBtn.hidden = NO;
    [self.levelBtn setBackgroundImage:[UIImage imageNamed:@"user_icon"] forState:UIControlStateNormal];
  }
 
}

#pragma mark UICollectionViewDelegate&UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return 1;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 9;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  
  //重用cell
  [collectionView registerNib:[UINib nibWithNibName:@"CGUserHeaderCollectionViewCell"
                                             bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:@"Cell"];
  CGUserHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
  switch (indexPath.section) {
    case 0:
      cell.textlabel.text = @"收藏数";
      [cell updateData:@"0个"];
      break;
    case 1:
      cell.textlabel.text = @"我的知识币";
      [cell updateData:[NSString stringWithFormat:@"%d枚",self.userInfo.statistics.integralNum]];
      break;
    case 2:
      cell.textlabel.text = @"关注数";
      [cell updateData:[NSString stringWithFormat:@"0个"]];
      break;
    case 3:
      cell.textlabel.text = @"我的主题数";
      [cell updateData:[NSString stringWithFormat:@"%d份",self.userInfo.statistics.subjectNum]];
      break;
    case 4:
      cell.textlabel.text = @"话题数";
      [cell updateData:@"0个"];
      break;
    case 5:
      cell.textlabel.text = @"体验数";
     [cell updateData:[NSString stringWithFormat:@"%d次",self.userInfo.statistics.expNum]];
      break;
    case 6:
      cell.textlabel.text = @"爆料数";
      [cell updateData:[NSString stringWithFormat:@"%d份",self.userInfo.statistics.advicesNum]];
      break;
    case 7:
      cell.textlabel.text = @"分享数";
      [cell updateData:[NSString stringWithFormat:@"%d次",self.userInfo.statistics.shareNum]];
      break;
    case 8:
      cell.textlabel.text = @"我的足迹";
      [cell updateData:[NSString stringWithFormat:@"%d次",self.userInfo.statistics.browseNum]];
      break;
    default:
      break;
  }
  
  return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return CGSizeMake(80, 60);
}

@end
