//
//  CGEnterpriseMemberTableViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/8.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGEnterpriseMemberTableViewCell.h"
#import "CGCorporateMemberEntity.h"

#define ScrollViewWidth 100

@interface CGEnterpriseMemberTableViewCell()

@property(nonatomic,retain)NSMutableArray *titleArray;
@property(nonatomic,retain)NSMutableArray *listArray;
@property(nonatomic,copy)CGEnterpriseMemberTableViewCellBlock block;
@property(nonatomic,copy)CGEnterpriseMemberTableViewCellClaimBlock claimBlock;

@end

@implementation CGEnterpriseMemberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)updateTitleArray:(NSMutableArray *)titleArray listArray:(NSMutableArray *)listArray block:(CGEnterpriseMemberTableViewCellBlock)block claimBlock:(CGEnterpriseMemberTableViewCellClaimBlock)claimBlock{
    self.sv.frame = CGRectMake(0, 0, SCREEN_WIDTH, (listArray.count+1)*50);
    
    self.titleArray = titleArray;
    self.listArray = listArray;
    self.block = block;
    self.claimBlock = claimBlock;
    CGFloat width = ScrollViewWidth;
    for (UIView *view in self.sv.subviews) {
        [view removeFromSuperview];
    }
    if (titleArray.count<=0) {
        return;
    }
    if (SCREEN_WIDTH>titleArray.count*ScrollViewWidth) {
        width = SCREEN_WIDTH/titleArray.count;
    }
    
    for (int i = 0; i<titleArray.count; i++) {
        CGPrivilegeTitle *memberEntity = titleArray[i];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(width*i, 0, width, 50)];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [self.sv addSubview:label];
        label.backgroundColor = CTCommonViewControllerBg;
        label.text = memberEntity.title;
        label.textColor = [CTCommonUtil convert16BinaryColor:memberEntity.color];
    }
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, width*titleArray.count, 0.5)];
    [self.sv addSubview:line];
    line.backgroundColor = CTCommonLineBg;
    
    for (int i = 0; i<listArray.count; i++) {
        CGPrivilegeList *memberEntity = listArray[i];
        for (int j=0; j<memberEntity.list.count+1; j++) {
            UIButton *label = [[UIButton alloc]initWithFrame:CGRectMake(width*j, 50+i*50, width, 50)];
            label.tag = j;
            label.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.sv addSubview:label];
            if (j == 0) {
                [label setTitle:memberEntity.title forState:UIControlStateNormal];
                [label setTitleColor:[CTCommonUtil convert16BinaryColor:memberEntity.color] forState:UIControlStateNormal];
            }else{
                CGListEntity *entity = memberEntity.list[j-1];
                [label setTitle:entity.info forState:UIControlStateNormal];
                if(entity.isButtom == 1){//可点击的按钮，加背景色
                    [label addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
                    CGRect rect = CGRectMake(width*j+15, 50+i*50+10, width-30, 30);
                    label.frame = rect;
                    label.layer.cornerRadius = 3;
                    label.layer.masksToBounds = YES;
                    [label setBackgroundImage:[CTCommonUtil generateImageWithColor:[CTCommonUtil convert16BinaryColor:entity.color] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
                    [label setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }else{
                    [label setTitleColor:[CTCommonUtil convert16BinaryColor:entity.color] forState:UIControlStateNormal];
                }
            }
        }
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50+i*50, width*titleArray.count, 0.5)];
        [self.sv addSubview:line];
        line.backgroundColor = CTCommonLineBg;
    }
    [self.sv setContentSize:CGSizeMake(width*titleArray.count, 0)];
}

-(void)clickItem:(UIButton *)button{
    if([button.titleLabel.text isEqualToString:@"认领"]){
        if(self.claimBlock){
            self.claimBlock();
        }
    }else{
        int tag = (int)button.tag;
        CGPrivilegeList *memberEntity = self.listArray[0];
        CGListEntity *entity = memberEntity.list[tag-1];
        CGPrivilegeTitle *titleEntity = self.titleArray[tag];
        if(self.block){
            self.block(entity.gradesId, [NSString stringWithFormat:@"%@%@",entity.info,titleEntity.title]);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
