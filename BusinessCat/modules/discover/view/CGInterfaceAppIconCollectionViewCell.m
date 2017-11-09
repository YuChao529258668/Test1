//
//  CGInterfaceAppIconCollectionViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/7/25.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGInterfaceAppIconCollectionViewCell.h"
#import "HeadlineBiz.h"
#import "DiscoverDao.h"

@implementation CGInterfaceAppIconCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  self.icon.layer.cornerRadius = 4;
  self.icon.layer.masksToBounds = YES;
    // Initialization code
}

-(void)setInterface:(CGProductInterfaceEntity *)interface{
  _interface = interface;
  [self.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/jpg/quality/100/thumbnail/!50p",interface.cover]]];
  self.collect.selected = interface.isFollow;
  self.title.text = interface.name;
}

- (IBAction)collectClick:(UIButton *)sender {
    if (_interface.isFollow == 0) {
      //收藏
      HeadlineBiz *biz = [[HeadlineBiz alloc]init];
      _interface.isFollow = YES;
      sender.selected = YES;
      [biz collectWithId:_interface.interfaceID type:15 collect:1 success:^{
        [DiscoverDao updateInterfaceListFromDBWithID:_interface.interfaceID isFollow:YES];
      } fail:^(NSError *error) {
        _interface.isFollow = NO;
        sender.selected = NO;
      }];
    }else{
      //取消收藏
      HeadlineBiz *biz = [[HeadlineBiz alloc]init];
      _interface.isFollow = NO;
      sender.selected = NO;
      [biz collectWithId:_interface.interfaceID type:15 collect:0 success:^{
        [DiscoverDao updateInterfaceListFromDBWithID:_interface.interfaceID isFollow:NO];
      } fail:^(NSError *error) {
        _interface.isFollow = YES;
        sender.selected = YES;
      }];
    }
}

@end
