//
//  TeamCircleHeadView.m
//  CGKnowledge
//
//  Created by mochenyang on 2017/6/28.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "TeamCircleHeadView.h"
#import "TeamCircleLastStateEntity.h"

@interface TeamCircleHeadView()

@property(nonatomic,retain)UIImageView *image;

@property(nonatomic,retain)UIButton *alertView;

@property(nonatomic,retain)UIImageView *userIcon;
@property(nonatomic,retain)UILabel *userName;

@property(nonatomic,retain)NSString *cover;

@property(nonatomic,copy)TeamCircleHeadViewBlock block;

@property(nonatomic,retain)TeamCircleCompanyState *entity;

@end

@implementation TeamCircleHeadView

-(instancetype)initWithFrame:(CGRect)frame block:(TeamCircleHeadViewBlock)block{
    self = [super initWithFrame:frame];
    if(self){
        self.clipsToBounds = YES;
        self.block = block;
        self.backgroundColor = [UIColor whiteColor];
        self.image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width,TOPIMAGEHEIGHT)];
      self.image.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.image];
        
        self.alertView = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-SCREEN_WIDTH/4, CGRectGetMaxY(self.image.frame)+10, SCREEN_WIDTH/2, 40)];
        self.alertView.layer.cornerRadius = 5;
        self.alertView.layer.masksToBounds = YES;
        self.alertView.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:self.alertView];
        [self.alertView addTarget:self action:@selector(clickHeadMessageAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.userIcon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, self.alertView.frame.size.height-10, self.alertView.frame.size.height-10)];
        self.userIcon.layer.cornerRadius = 3;
        self.userIcon.layer.masksToBounds = YES;
        [self.alertView addSubview:self.userIcon];
        
        self.userName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(self.userIcon.frame)+5, 0, self.alertView.frame.size.width-CGRectGetMaxY(self.userIcon.frame)-10, self.alertView.frame.size.height)];
        self.userName.textColor = [UIColor whiteColor];
        self.userName.textAlignment = NSTextAlignmentCenter;
        self.userName.font = [UIFont systemFontOfSize:14];
        [self.alertView addSubview:self.userName];
        
    }
    return self;
}

-(void)clickHeadMessageAction{
    TeamCircleLastStateEntity *state = [TeamCircleLastStateEntity getFromLocal];
    TeamCircleCompanyState *com = [state getCompanyStateById:self.entity.companyId companyType:self.entity.companyType];
    state.count -= com.count;
    com.count = 0;
    self.entity = com;
    [TeamCircleLastStateEntity saveToLocal:state];
    if(self.block){
        self.block(self.entity);
    }
    [self updateHeadView:self.entity cover:self.cover];
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationDiscoverHasLastData object:[TeamCircleLastStateEntity getFromLocal]];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_DISCOVER_MAINPAGE_RELOAD object:nil];
    
}

-(void)updateHeadView:(TeamCircleCompanyState *)entity cover:(NSString *)cover{
    self.entity = entity;
    self.cover = cover;
  if ([CTStringUtil stringNotBlank:cover]) {
   [self.image sd_setImageWithURL:[NSURL URLWithString:self.cover]];
  }else{
    self.image.image = [UIImage imageNamed:@"tuanduiquan_adspictures"];
  }
    if(entity.count > 0){
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH,TOPIMAGEHEIGHT+50);
        self.alertView.hidden = NO;
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:entity.portrait]];
        self.userName.text = [NSString stringWithFormat:@"%d条新消息",entity.count];
    }else{
        self.alertView.hidden = YES;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH,TOPIMAGEHEIGHT+10);
    }
}

@end
