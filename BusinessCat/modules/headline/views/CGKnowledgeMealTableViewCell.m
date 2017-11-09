//
//  CGKnowledgeMealTableViewCell.m
//  CGKnowledge
//
//  Created by zhu on 2017/5/24.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGKnowledgeMealTableViewCell.h"
#import "CTButtonRightImg.h"

@interface CGKnowledgeMealTableViewCell()

@property (retain, nonatomic) IBOutlet UILabel *title;
@property (retain, nonatomic) IBOutlet CTButtonRightImg *dataNum;
@property (retain, nonatomic) IBOutlet UIImageView *cover;
@property (retain, nonatomic) IBOutlet UILabel *level;
@property (retain, nonatomic) IBOutlet UIButton *readNum;
@property (retain, nonatomic) IBOutlet UILabel *vipLabel;

@property(nonatomic,retain)KnowledgeHeaderEntity *mode;

@end

@implementation CGKnowledgeMealTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
      
        self.cover = [[UIImageView alloc]initWithFrame:CGRectMake(-0.5, 0, SCREEN_WIDTH+1, TOPIMAGEHEIGHT)];
        self.cover.layer.borderColor = CTCommonLineBg.CGColor;
        self.cover.layer.borderWidth = 0.5;
        self.cover.backgroundColor = [UIColor whiteColor];
        self.cover.clipsToBounds = YES;
        self.cover.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.cover];
        
//        self.dataNum = [[CTButtonRightImg alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, 0, 40, 50)];
//        [self.dataNum setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
//        [self.dataNum setTitleColor:[CTCommonUtil convert16BinaryColor:@"#959595"] forState:UIControlStateNormal];
//        self.dataNum.titleLabel.font = [UIFont systemFontOfSize:12];
//        [self.contentView addSubview:self.dataNum];
      
        self.readNum = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-90, CGRectGetMaxY(self.cover.frame)-30, 80, 20)];
        [self.readNum setImage:[UIImage imageNamed:@"attendance"] forState:UIControlStateNormal];
        self.readNum.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.readNum setTitleColor:[CTCommonUtil convert16BinaryColor:@"#959595"] forState:UIControlStateNormal];
        self.readNum.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.readNum];
        
        self.vipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.cover.frame)-40, 0, 40)];
        self.vipLabel.font = [UIFont systemFontOfSize:13];
        self.vipLabel.text = @"";
        self.vipLabel.textAlignment = NSTextAlignmentCenter;
        self.vipLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.vipLabel];
      self.vipLabel.layer.cornerRadius = 4;
      self.vipLabel.layer.masksToBounds = YES;
      self.vipLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
      self.title = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.cover.frame), SCREEN_WIDTH-60, 55)];
        self.title.textAlignment = NSTextAlignmentCenter;
      self.title.numberOfLines = 2;
      [self.contentView addSubview:self.title];
    }
    return self;
}


-(void)updateItem:(KnowledgeHeaderEntity *)mode header:(KnowledgeAlbumEntity *)header{
    long endOfToday = [CTDateUtils endOfDate:[NSDate date]].timeIntervalSince1970*1000;
    self.mode = mode;
    self.title.text = self.mode.packageTitle;
    if(mode.packageType == 26){
        self.dataNum.hidden = NO;
        [self.dataNum setTitle:[NSString stringWithFormat:@"%d",mode.infoNum] forState:UIControlStateNormal];
    }else{
        self.dataNum.hidden = YES;
    }
    [self.cover sd_setImageWithURL:[NSURL URLWithString:mode.packageCover]];
    [self.readNum setTitle:[NSString stringWithFormat:@" %d",mode.readNum] forState:UIControlStateNormal];
    if ([CTStringUtil stringNotBlank:mode.organizaName]){
        self.vipLabel.text = mode.organizaName;
      [self.vipLabel sizeToFit];
      self.vipLabel.frame = CGRectMake(10, CGRectGetMaxY(self.cover.frame)-40, self.vipLabel.frame.size.width+10, 30);
    }else if([CTStringUtil stringNotBlank:mode.packageTip]){
        self.vipLabel.text = mode.packageTip;
      [self.vipLabel sizeToFit];
      self.vipLabel.frame = CGRectMake(10, CGRectGetMaxY(self.cover.frame)-40, self.vipLabel.frame.size.width+10, 30);
    }
    
    if(header){
        NSDate *cud = [NSDate date];
        long cu = cud.timeIntervalSince1970;
        long st = header.groupTime/1000;
        if((header.isVip || (cu > st)) && header.groupTime < endOfToday){//可用
            self.title.textColor = [UIColor blackColor];
        }else{//不可用
            self.title.textColor = [UIColor grayColor];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
