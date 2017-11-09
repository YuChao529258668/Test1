




/********************* 有任何问题欢迎反馈给我 liuweiself@126.com ****************************************/
/***************  https://github.com/waynezxcv/Gallop 持续更新 ***************************/
/******************** 正在不断完善中，谢谢~  Enjoy ******************************************************/








#import "LWLayout.h"
#import "CGSourceCircleEntity.h"


#define MESSAGE_TYPE_IMAGE @"image"
#define MESSAGE_TYPE_WEBSITE @"website"
#define MESSAGE_TYPE_VIDEO @"video"
#define AVATAR_IDENTIFIER @"avatar"

typedef NS_ENUM(NSInteger, ImageType) {
  ImageTypeText       = 1,
  ImageTypeImageText  = 2,
  ImageTypeLink       = 3,
  ImageTypeTopic      = 4
};


@interface CellLayout : LWLayout

@property (nonatomic,strong) CGSourceCircleEntity* entity;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,assign) CGRect lineRect;
@property (nonatomic,assign) CGRect menuPosition;
@property (nonatomic,assign) CGRect commentBgPosition;
@property (nonatomic,assign) CGRect avatarPosition;
@property (nonatomic,assign) CGRect websitePosition;
@property (nonatomic,copy) NSArray* imagePostions;

//文字过长时，折叠状态的布局模型
- (id)initWithStatusModel:(CGSourceCircleEntity *)entity isUnfold:(BOOL)isUnfold dateFormatter:(NSDateFormatter *)dateFormatter;


////文字过长时，打开状态的布局模型
//- (id)initContentOpendLayoutWithStatusModel:(CGSourceCircleEntity *)entity dateFormatter:(NSDateFormatter *)dateFormatter;





@end
