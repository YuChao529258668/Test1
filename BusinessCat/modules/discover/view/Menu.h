




/********************* 有任何问题欢迎反馈给我 liuweiself@126.com ****************************************/
/***************  https://github.com/waynezxcv/Gallop 持续更新 ***************************/
/******************** 正在不断完善中，谢谢~  Enjoy ******************************************************/









#import <UIKit/UIKit.h>
#import "LikeButton.h"
#import "CGSourceCircleEntity.h"


@interface Menu : UIView

@property (nonatomic,strong) LikeButton* likeButton;
@property (nonatomic,strong) LikeButton* awardButton;
@property (nonatomic,strong) UIButton* commentButton;
@property (nonatomic,strong) CGSourceCircleEntity* entity;

- (void)clickedMenu;
- (void)menuShow:(NSInteger)type;//0自己 1别人
- (void)menuHide;

@end
