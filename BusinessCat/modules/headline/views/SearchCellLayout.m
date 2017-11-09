//
//  SearchCellLayout.m
//  CGSays
//
//  Created by zhu on 2016/11/24.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "SearchCellLayout.h"
#import "LWTextParser.h"
#import "CGUserDao.h"
#import "CommentModel.h"
#import "Gallop.h"
#import "CGDiscoverLink.h"

@implementation SearchCellLayout

- (id)initWithStatusModel:(CGSearchSourceCircleEntity *)entity isUnfold:(BOOL)isUnfold dateFormatter:(NSDateFormatter *)dateFormatter {
  self = [super init];
  if (self) {
    self.entity = entity;
    //头像模型 avatarImageStorage
    LWImageStorage* avatarStorage = [[LWImageStorage alloc] initWithIdentifier:AVATAR_IDENTIFIER];
    if (entity.portrait.length>0) {
     avatarStorage.contents = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/80/interlace/1",entity.portrait]];
    }
    avatarStorage.placeholder = [UIImage imageNamed:@"user_icon"];
    avatarStorage.cornerBackgroundColor = [UIColor whiteColor];
    avatarStorage.backgroundColor = [UIColor whiteColor];
    avatarStorage.clipsToBounds = YES;
    avatarStorage.frame = CGRectMake(10, 20, 40.0f, 40.0f);
    avatarStorage.tag = 9;
    
    //名字模型 nameTextStorage
    LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
    nameTextStorage.text = entity.nickname;
    nameTextStorage.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0f];
    nameTextStorage.frame = CGRectMake(60.0f, 20.0f, SCREEN_WIDTH - 80.0f, CGFLOAT_MAX);
    [nameTextStorage lw_addLinkWithData:[NSString stringWithFormat:@"%@",entity.nickname]range:NSMakeRange(0,entity.nickname.length) linkColor:RGBA(70, 100, 142, 1)highLightColor:RGBA(0, 0, 0, 0.15)];
    
//    //等级模型 levelTextStorage
//    LWImageStorage* levelImageStorage = [[LWImageStorage alloc] init];
//    levelImageStorage.clipsToBounds = YES;
//    LWTextStorage* levelTextStorage = [[LWTextStorage alloc] init];
//    if (entity.scoopType == 4) {
//      levelTextStorage.text = @"话题";
//      levelTextStorage.textColor = [CTCommonUtil convert16BinaryColor:@"#919191"];
//      levelImageStorage.contents = [UIImage imageNamed:@"tuanduiquanhuati"];
//    }else if (entity.level == 1) {
//      levelTextStorage.text = @"一般";
//      levelTextStorage.textColor = [CTCommonUtil convert16BinaryColor:@"#919191"];
//      levelImageStorage.contents = [UIImage imageNamed:@"tuanduiquanliao_glay"];
//    }else if (entity.level == 2){
//      levelTextStorage.text = @"重要";
//      levelTextStorage.textColor = [CTCommonUtil convert16BinaryColor:@"#FB3A3F"];
//      levelImageStorage.contents = [UIImage imageNamed:@"tuanduiquanliao"];
//    }else if(entity.level == 3){
//      levelTextStorage.text = @"紧急";
//      levelTextStorage.textColor = [CTCommonUtil convert16BinaryColor:@"#FB3A3F"];
//      levelImageStorage.contents = [UIImage imageNamed:@"tuanduiquanliao"];
//    }
//    levelTextStorage.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
//    levelTextStorage.frame = CGRectMake(SCREEN_WIDTH - 48.0f, 23.0f, 35.0f, CGFLOAT_MAX);
//    levelImageStorage.frame = CGRectMake(SCREEN_WIDTH-50.0f-20.0f, 23.0f, 18.0f, 18.0f);
    
    //正文内容模型 contentTextStorage
    LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
    if (isUnfold == NO) {
      contentTextStorage.maxNumberOfLines = 5;//设置最大行数，超过则折叠
    }
    contentTextStorage.text = entity.content;
    contentTextStorage.font = [UIFont fontWithName:@"Helvetica" size:17.0f];
    contentTextStorage.textColor = RGBA(40, 40, 40, 1);
    contentTextStorage.frame = CGRectMake(nameTextStorage.left,nameTextStorage.bottom + 10.0f,SCREEN_WIDTH - 80.0f,CGFLOAT_MAX);
    CGFloat contentBottom;
    if (isUnfold) {
      //折叠文字
      LWTextStorage* closeStorage = [[LWTextStorage alloc] init];
      closeStorage.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
      closeStorage.textColor = RGBA(40, 40, 40, 1);
      closeStorage.frame = CGRectMake(nameTextStorage.left, contentTextStorage.bottom + 5.0f, 200.0f, 30.0f);
      closeStorage.text = @"收起全文";
      [closeStorage lw_addLinkWithData:@"close" range:NSMakeRange(0, 4) linkColor:RGBA(113, 129, 161, 1) highLightColor:RGBA(0, 0, 0, 0.15f)];
      [self addStorage:closeStorage];
      contentBottom = closeStorage.bottom + 10.0f;
    }else{
      contentBottom = contentTextStorage.bottom;
      //折叠的条件
      if (contentTextStorage.isTruncation) {
        contentTextStorage.frame = CGRectMake(nameTextStorage.left,nameTextStorage.bottom + 10.0f,SCREEN_WIDTH - 80.0f,CGFLOAT_MAX);
        LWTextStorage* openStorage = [[LWTextStorage alloc] init];
        openStorage.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        openStorage.textColor = RGBA(40, 40, 40, 1);
        openStorage.frame = CGRectMake(nameTextStorage.left,contentTextStorage.bottom + 5.0f,200.0f,30.0f);
        openStorage.text = @"展开全文";
        [openStorage lw_addLinkWithData:@"open" range:NSMakeRange(0, 4) linkColor:RGBA(113, 129, 161, 1) highLightColor:RGBA(0, 0, 0, 0.15f)];
        [self addStorage:openStorage];
        contentBottom = openStorage.bottom;
      }
    }
    //解析表情和主题
    [LWTextParser parseEmojiWithTextStorage:contentTextStorage];
    [LWTextParser parseTopicWithLWTextStorage:contentTextStorage linkColor:RGBA(113, 129, 161, 1) highlightColor:RGBA(0, 0, 0, 0.15)];
    
//    //发布的图片模型 imgsStorage
//    CGFloat imageWidth = (SCREEN_WIDTH - 110.0f)/3.0f;
//    NSInteger imageCount = [entity.imglist count];
//    NSMutableArray* imageStorageArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
//    NSMutableArray* imagePositionArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
//    
//    //图片类型
//    if (entity.scoopType == SearchImageTypeText||entity.scoopType == SearchImageTypeImageText) {
//      NSInteger row = 0;
//      NSInteger column = 0;
//      if (imageCount == 1) {
//        CGRect imageRect = CGRectMake(nameTextStorage.left,contentBottom + 5.0f + (row * (imageWidth + 5.0f)), imageWidth*1.7, imageWidth*1.7);
//        NSString* imagePositionString = NSStringFromCGRect(imageRect);
//        [imagePositionArray addObject:imagePositionString];
//        LWImageStorage* imageStorage = [[LWImageStorage alloc] initWithIdentifier:@"image"];
//        imageStorage.tag = 0;
//        imageStorage.clipsToBounds = YES;
//        imageStorage.frame = imageRect;
//        imageStorage.backgroundColor = RGBA(240, 240, 240, 1);
//        SearchSourceCircImgList *imageEntity = [entity.imglist objectAtIndex:0];
//        imageStorage.contents = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/200/interlace/1",imageEntity.thumbnail]];
//        imageStorage.placeholder = [UIImage imageNamed:@"morentuzhengfangxing"];
//        [imageStorageArray addObject:imageStorage];
//      } else {
//        for (NSInteger i = 0; i < imageCount; i ++) {
//          CGRect imageRect = CGRectMake(nameTextStorage.left + (column * (imageWidth + 5.0f)), contentBottom + 5.0f + (row * (imageWidth + 5.0f)), imageWidth, imageWidth);
//          
//          NSString* imagePositionString = NSStringFromCGRect(imageRect);
//          [imagePositionArray addObject:imagePositionString];
//          LWImageStorage* imageStorage = [[LWImageStorage alloc] initWithIdentifier:@"image"];
//          imageStorage.clipsToBounds = YES;
//          imageStorage.tag = i;
//          imageStorage.frame = imageRect;
//          imageStorage.backgroundColor = RGBA(240, 240, 240, 1);
//          SearchSourceCircImgList *imageEntity = [entity.imglist objectAtIndex:i];
//          imageStorage.contents = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/200/interlace/1",imageEntity.thumbnail]];
//          imageStorage.placeholder = [UIImage imageNamed:@"morentuzhengfangxing"];
//          [imageStorageArray addObject:imageStorage];
//          column = column + 1;
//          if (column > 2) {
//            column = 0;
//            row = row + 1;
//          }
//        }
//      }
//    }
    
    //网页链接类型
//    else
      if (entity.linkType>0&&[CTStringUtil stringNotBlank:entity.linkId]) {
      //这个CGRect用来绘制背景颜色
      self.websitePosition = CGRectMake(nameTextStorage.left, contentBottom + 5.0f, SCREEN_WIDTH - 80.0f, 60.0f);
        //左边的图片
        CGFloat x = 0;
        if ([CTStringUtil stringNotBlank:entity.linkIcon]) {
          LWImageStorage* imageStorage = [[LWImageStorage alloc] init];
          NSString* URLString = entity.linkIcon;
          imageStorage.placeholder = [UIImage imageNamed:@"morentuzhengfangxing"];
            if([URLString containsString:@"pic.jp580.com"]){
                imageStorage.contents = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/100/interlace/1",URLString]];
            }else{
                imageStorage.contents = [NSURL URLWithString:URLString];
            }
          
          imageStorage.clipsToBounds = YES;
          imageStorage.frame = CGRectMake(nameTextStorage.left + 5.0f, contentBottom + 10.0f, 50.0f, 50.0f);
//          [imageStorageArray addObject:imageStorage];
          x = imageStorage.right;
          [self addStorage:imageStorage];
        }else{
          x = nameTextStorage.left + 5.0f;
        }
        
        //右边的文字
        LWTextStorage* detailTextStorage = [[LWTextStorage alloc] init];
        detailTextStorage.text = entity.linkTitle;
        detailTextStorage.maxNumberOfLines = 2;
        detailTextStorage.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        detailTextStorage.textColor = RGBA(40, 40, 40, 1);
        detailTextStorage.frame = CGRectMake(x + 10.0f, contentBottom +10.0f, SCREEN_WIDTH - x-35, 60.0f);
        detailTextStorage.linespacing = 0.5f;
        CGFloat heith = (60 - detailTextStorage.height)/2;
        detailTextStorage.frame = CGRectMake(x + 10.0f, contentBottom + heith+5, SCREEN_WIDTH - x-35, 60.0f);
        CGDiscoverLink *link = [[CGDiscoverLink alloc]init];
        link.linkType = entity.linkType;
        link.linkTitle = entity.linkTitle;
        link.linkId = entity.linkId;
        link.linkIcon = entity.linkIcon;
        [detailTextStorage lw_addLinkForWholeTextStorageWithData:link linkColor:nil highLightColor:RGBA(0, 0, 0, 0.15)];
        [self addStorage:detailTextStorage];
    }
    
    //获取最后一张图片的模型
//    LWImageStorage* lastImageStorage = (LWImageStorage *)[imageStorageArray lastObject];
    //生成时间的模型 dateTextStorage
    LWTextStorage* dateTextStorage = [[LWTextStorage alloc] init];
    
    dateTextStorage.text = [CTDateUtils formatDateToMMDDHHmm:entity.createTime];
    dateTextStorage.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
    dateTextStorage.textColor = TEXT_GRAY_CLR;
    
    LWImageStorage* praiseStorage = [[LWImageStorage alloc] init];
    praiseStorage.placeholder = [UIImage imageNamed:@"topic_praise_righttop_normal"];
    LWTextStorage* praiseTextStorage = [[LWTextStorage alloc] init];
    praiseTextStorage.text = [NSString stringWithFormat:@"%ld",entity.praiseNum];
    praiseTextStorage.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
    praiseTextStorage.textColor = [UIColor lightGrayColor];
    
    LWImageStorage* replyStorage = [[LWImageStorage alloc] init];
    replyStorage.placeholder = [UIImage imageNamed:@"topic_commentNum_righttop"];
    LWTextStorage* replyTextStorage = [[LWTextStorage alloc] init];
    replyTextStorage.text = [NSString stringWithFormat:@"%ld",entity.replyNum];
    replyTextStorage.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
    replyTextStorage.textColor = [UIColor lightGrayColor];
//    //是否全公司可见图标
//    LWImageStorage* deleteImageStorage = [[LWImageStorage alloc] init];
//    deleteImageStorage.clipsToBounds = YES;
//    deleteImageStorage.placeholder = [UIImage imageNamed:@"tuanduiquanxianzhi"];
    
//    //删除按钮
//    LWTextStorage* deleteTextStorage = [[LWTextStorage alloc] init];
//    deleteTextStorage.text = @"删除";
//    deleteTextStorage.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
//    [deleteTextStorage lw_addLinkWithData:entity range:NSMakeRange(0,2) linkColor:RGBA(70, 100, 142, 1) highLightColor:RGBA(0, 0, 0, 0.15)];
    //菜单按钮
//    CGRect menuPosition = CGRectZero;
    if (entity.linkType>0&&[CTStringUtil stringNotBlank:entity.linkId]) {
//      menuPosition = CGRectMake(SCREEN_WIDTH - 54.0f, 10.0f + contentTextStorage.bottom - 14.5f, 50.0f, 50.0f);
      
      dateTextStorage.frame = CGRectMake(nameTextStorage.left, self.websitePosition.origin.y+self.websitePosition.size.height + 10.0f, SCREEN_WIDTH - 80.0f, CGFLOAT_MAX);
      praiseStorage.frame = CGRectMake(dateTextStorage.right, self.websitePosition.origin.y+self.websitePosition.size.height + 7.0f, 22, 22);
      praiseTextStorage.frame = CGRectMake(praiseStorage.right, self.websitePosition.origin.y+self.websitePosition.size.height + 10.0f, SCREEN_WIDTH - 80.0f, CGFLOAT_MAX);
      replyStorage.frame = CGRectMake(praiseStorage.right+10.0f, self.websitePosition.origin.y+self.websitePosition.size.height + 7.0f, 22, 22);
      replyTextStorage.frame = CGRectMake(replyStorage.right, self.websitePosition.origin.y+self.websitePosition.size.height + 10.0f, SCREEN_WIDTH - 80.0f, CGFLOAT_MAX);
      
    }else{
      dateTextStorage.frame = CGRectMake(nameTextStorage.left, contentTextStorage.bottom + 10.0f, SCREEN_WIDTH - 80.0f, CGFLOAT_MAX);
      praiseStorage.frame = CGRectMake(dateTextStorage.right, contentTextStorage.bottom + 7.0f, 22, 22);
      praiseTextStorage.frame = CGRectMake(praiseStorage.right, contentTextStorage.bottom + 10.0f, SCREEN_WIDTH - 80.0f, CGFLOAT_MAX);
      replyStorage.frame = CGRectMake(praiseStorage.right+10.0f, contentTextStorage.bottom + 7.0f, 22, 22);
      replyTextStorage.frame = CGRectMake(replyStorage.right, contentTextStorage.bottom + 10.0f, SCREEN_WIDTH - 80.0f, CGFLOAT_MAX);
    }
  
    [self addStorage:nameTextStorage];//将Storage添加到遵循LWLayoutProtocol协议的类
    [self addStorage:contentTextStorage];
    [self addStorage:dateTextStorage];
    [self addStorage:praiseStorage];
    [self addStorage:praiseTextStorage];
    [self addStorage:replyStorage];
    [self addStorage:replyTextStorage];
//    [self addStorage:levelImageStorage];
//    [self addStorage:levelTextStorage];
    [self addStorage:avatarStorage];
//    [self addStorages:imageStorageArray];//通过一个数组来添加storage，使用这个方法
    self.avatarPosition = CGRectMake(10, 20, 40, 40);//头像的位置
//    self.menuPosition = menuPosition;//右下角菜单按钮的位置
//    self.imagePostions = imagePositionArray;//保存图片位置的数组
    //如果是使用在UITableViewCell上面，可以通过以下方法快速的得到Cell的高度
    self.cellHeight = [self suggestHeightWithBottomMargin:15.0f];
  }
  return self;
}

//- (id)initContentOpendLayoutWithStatusModel:(CGSearchSourceCircleEntity *)entity dateFormatter:(NSDateFormatter *)dateFormatter {
//  
//  self = [super init];
//  if (self) {
//    self.entity = entity;
//    //头像模型 avatarImageStorage
//    LWImageStorage* avatarStorage = [[LWImageStorage alloc] initWithIdentifier:AVATAR_IDENTIFIER];
//    avatarStorage.contents = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/80/interlace/1",entity.portrait]];
//    avatarStorage.placeholder = [UIImage imageNamed:@"user_icon"];
//    //        avatarStorage.cornerRadius = 4.0f;
//    avatarStorage.cornerBackgroundColor = [UIColor whiteColor];
//    avatarStorage.backgroundColor = [UIColor whiteColor];
//    avatarStorage.frame = CGRectMake(10, 20, 40.0f, 40.0f);
//    avatarStorage.clipsToBounds = YES;
//    avatarStorage.tag = 9;
//    
//    //名字模型 nameTextStorage
//    LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
//    nameTextStorage.text = entity.nickname;
//    nameTextStorage.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0f];
//    nameTextStorage.frame = CGRectMake(60.0f, 20.0f, SCREEN_WIDTH - 80.0f, CGFLOAT_MAX);
//    [nameTextStorage lw_addLinkWithData:[NSString stringWithFormat:@"%@",entity.nickname] range:NSMakeRange(0,entity.nickname.length) linkColor:RGBA(70, 100, 142, 1) highLightColor:RGBA(0, 0, 0, 0.15)];
//    
//    //等级模型 levelTextStorage
//    LWImageStorage* levelImageStorage = [[LWImageStorage alloc] init];
//    levelImageStorage.clipsToBounds = YES;
//    
//    LWTextStorage* levelTextStorage = [[LWTextStorage alloc] init];
//    if (entity.type == 4) {
//      levelTextStorage.text = @"话题";
//      levelTextStorage.textColor = [CTCommonUtil convert16BinaryColor:@"#919191"];
//      levelImageStorage.contents = [UIImage imageNamed:@"tuanduiquanhuati"];
//    }else if (entity.level == 1) {
//      levelTextStorage.text = @"一般";
//      levelTextStorage.textColor = [CTCommonUtil convert16BinaryColor:@"#919191"];
//      levelImageStorage.contents = [UIImage imageNamed:@"tuanduiquanliao_glay"];
//    }else if (entity.level == 2){
//      levelTextStorage.text = @"重要";
//      levelTextStorage.textColor = [CTCommonUtil convert16BinaryColor:@"#FB3A3F"];
//      levelImageStorage.contents = [UIImage imageNamed:@"tuanduiquanliao"];
//    }else if (entity.level == 3){
//      levelTextStorage.text = @"紧急";
//      levelTextStorage.textColor = [CTCommonUtil convert16BinaryColor:@"#FB3A3F"];
//      levelImageStorage.contents = [UIImage imageNamed:@"tuanduiquanliao"];
//    }
//    levelTextStorage.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
//    levelTextStorage.frame = CGRectMake(SCREEN_WIDTH - 48.0f, 23.0f, 35.0f, CGFLOAT_MAX);
//    levelImageStorage.frame = CGRectMake(SCREEN_WIDTH-50.0f-20.0f, 23.0f, 18.0f, 18.0f);
//    
//    //正文内容模型 contentTextStorage
//    LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
//    contentTextStorage.text = entity.title;
//    contentTextStorage.font = [UIFont fontWithName:@"Helvetica" size:17.0f];
//    contentTextStorage.textColor = RGBA(40, 40, 40, 1);
//    contentTextStorage.frame = CGRectMake(nameTextStorage.left, nameTextStorage.bottom + 10.0f, SCREEN_WIDTH - 80.0f, CGFLOAT_MAX);
//    
//    //折叠文字
//    LWTextStorage* closeStorage = [[LWTextStorage alloc] init];
//    closeStorage.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
//    closeStorage.textColor = RGBA(40, 40, 40, 1);
//    closeStorage.frame = CGRectMake(nameTextStorage.left, contentTextStorage.bottom + 5.0f, 200.0f, 30.0f);
//    closeStorage.text = @"收起全文";
//    [closeStorage lw_addLinkWithData:@"close" range:NSMakeRange(0, 4) linkColor:RGBA(113, 129, 161, 1) highLightColor:RGBA(0, 0, 0, 0.15f)];
//    [self addStorage:closeStorage];
//    CGFloat contentBottom = closeStorage.bottom + 10.0f;
//    
//    //解析表情和主题
//    [LWTextParser parseEmojiWithTextStorage:contentTextStorage];
//    [LWTextParser parseTopicWithLWTextStorage:contentTextStorage linkColor:RGBA(113, 129, 161, 1) highlightColor:RGBA(0, 0, 0, 0.15)];
//    
//    //发布的图片模型 imgsStorage
//    CGFloat imageWidth = (SCREEN_WIDTH - 110.0f)/3.0f;
//    NSInteger imageCount = [entity.imglist count];
//    NSMutableArray* imageStorageArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
//    NSMutableArray* imagePositionArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
//    
//    //图片类型
//    if (entity.type == SearchImageTypeText||entity.type == SearchImageTypeImageText) {
//      NSInteger row = 0;
//      NSInteger column = 0;
//      if (imageCount == 1) {
//        CGRect imageRect = CGRectMake(nameTextStorage.left, contentBottom + 5.0f + (row * (imageWidth + 5.0f)), imageWidth*1.7, imageWidth*1.7);
//        NSString* imagePositionString = NSStringFromCGRect(imageRect);
//        [imagePositionArray addObject:imagePositionString];
//        LWImageStorage* imageStorage = [[LWImageStorage alloc] initWithIdentifier:@"image"];
//        imageStorage.tag = 0;
//        imageStorage.clipsToBounds = YES;
//        imageStorage.frame = imageRect;
//        imageStorage.backgroundColor = RGBA(240, 240, 240, 1);
//        SearchSourceCircImgList *imageEntity = entity.imglist[0];
//        NSString* URLString = imageEntity.thumbnail;
//        imageStorage.contents = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/200/interlace/1",URLString]];
//        imageStorage.placeholder = [UIImage imageNamed:@"morentuzhengfangxing"];
//        [imageStorageArray addObject:imageStorage];
//      } else {
//        for (NSInteger i = 0; i < imageCount; i ++) {
//          CGRect imageRect = CGRectMake(nameTextStorage.left + (column * (imageWidth + 5.0f)), contentBottom + 5.0f + (row * (imageWidth + 5.0f)), imageWidth, imageWidth);
//          
//          NSString* imagePositionString = NSStringFromCGRect(imageRect);
//          [imagePositionArray addObject:imagePositionString];
//          LWImageStorage* imageStorage = [[LWImageStorage alloc] initWithIdentifier:@"image"];
//          imageStorage.clipsToBounds = YES;
//          imageStorage.tag = i;
//          imageStorage.frame = imageRect;
//          imageStorage.backgroundColor = RGBA(240, 240, 240, 1);
//          SearchSourceCircImgList *imageEntity = entity.imglist[i];
//          NSString* URLString = imageEntity.thumbnail;
//          imageStorage.contents = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/200/interlace/1",URLString]];
//          imageStorage.placeholder = [UIImage imageNamed:@"morentuzhengfangxing"];
//          [imageStorageArray addObject:imageStorage];
//          column = column + 1;
//          if (column > 2) {
//            column = 0;
//            row = row + 1;
//          }
//        }
//      }
//    }
//    
//    //网页链接类型
//    else if (entity.type == SearchImageTypeLink || entity.type == SearchImageTypeTopic) {
//      //这个CGRect用来绘制背景颜色
//      self.websitePosition = CGRectMake(nameTextStorage.left, contentBottom + 5.0f, SCREEN_WIDTH - 80.0f, 60.0f);
//      
//      //左边的图片
//      LWImageStorage* imageStorage = [[LWImageStorage alloc] init];
//      NSString* URLString = entity.linkIcon;
//      imageStorage.contents = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/100/interlace/1",URLString]];;
//      imageStorage.placeholder = [UIImage imageNamed:@"morentuzhengfangxing"];
//      imageStorage.clipsToBounds = YES;
//      imageStorage.frame = CGRectMake(nameTextStorage.left + 5.0f, contentBottom + 10.0f, 50.0f, 50.0f);
//      [imageStorageArray addObject:imageStorage];
//      
//      //右边的文字
//      LWTextStorage* detailTextStorage = [[LWTextStorage alloc] init];
//      detailTextStorage.text = entity.linkTitle;
//      detailTextStorage.maxNumberOfLines = 2;
//      detailTextStorage.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
//      detailTextStorage.textColor = RGBA(40, 40, 40, 1);
//      detailTextStorage.frame = CGRectMake(imageStorage.right + 10.0f, contentBottom + 10.0f, SCREEN_WIDTH - 150.0f, 60.0f);
//      
//      detailTextStorage.linespacing = 0.5f;
//      CGDiscoverLink *link = [[CGDiscoverLink alloc]init];
//      link.linkType = entity.linkType;
//      link.linkTitle = entity.linkTitle;
//      link.linkId = entity.linkId;
//      link.linkIcon = entity.linkIcon;
//      [detailTextStorage lw_addLinkForWholeTextStorageWithData:link linkColor:nil highLightColor:RGBA(0, 0, 0, 0.15)];
//      [self addStorage:detailTextStorage];
//    }
//    
//    //TODO
//    //获取最后一张图片的模型
//    LWImageStorage* lastImageStorage = (LWImageStorage *)[imageStorageArray lastObject];
//    //生成时间的模型 dateTextStorage
//    LWTextStorage* dateTextStorage = [[LWTextStorage alloc] init];
//    dateTextStorage.text = [CTDateUtils getTimeFormatFromDateLong:entity.createtime];
//    dateTextStorage.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
//    dateTextStorage.textColor = [UIColor grayColor];
//    
//    //是否全公司可见
//    LWImageStorage* deleteImageStorage = [[LWImageStorage alloc] init];
//    deleteImageStorage.clipsToBounds = YES;
//    deleteImageStorage.placeholder = [UIImage imageNamed:@"tuanduiquanxianzhi"];
//    
//    //删除按钮
//    LWTextStorage* deleteTextStorage = [[LWTextStorage alloc] init];
//    deleteTextStorage.text = @"删除";
//    deleteTextStorage.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
//    [deleteTextStorage lw_addLinkWithData:entity range:NSMakeRange(0,2) linkColor:RGBA(70, 100, 142, 1) highLightColor:RGBA(0, 0, 0, 0.15)];
//    
//    //菜单按钮
//    CGRect menuPosition = CGRectZero;
//    if (entity.type == SearchImageTypeImageText||entity.type == SearchImageTypeLink || entity.type == SearchImageTypeTopic) {
//      menuPosition = CGRectMake(SCREEN_WIDTH - 54.0f, 10.0f + contentTextStorage.bottom - 14.5f, 50.0f, 50.0f);
//      
//      dateTextStorage.frame = CGRectMake(nameTextStorage.left, contentTextStorage.bottom + 10.0f, SCREEN_WIDTH - 80.0f, CGFLOAT_MAX);
//      
//      deleteImageStorage.frame = CGRectMake(dateTextStorage.right+5, contentTextStorage.bottom + 10.0f, 18.f, 18.f);
//      
//      if (entity.visibility == 1) {
//        deleteTextStorage.frame = CGRectMake(dateTextStorage.right+5, contentTextStorage.bottom + 10.0f, 35.f, CGFLOAT_MAX);
//      }else{
//        deleteTextStorage.frame = CGRectMake(deleteImageStorage.right+10, contentTextStorage.bottom + 10.0f, 35.f, CGFLOAT_MAX);
//      }
//      if (lastImageStorage) {
//        menuPosition = CGRectMake(SCREEN_WIDTH - 54.0f, 10.0f + lastImageStorage.bottom - 14.5f, 50.0f, 50.0f);
//        
//        dateTextStorage.frame = CGRectMake(nameTextStorage.left, lastImageStorage.bottom + 10.0f, SCREEN_WIDTH - 80.0f, CGFLOAT_MAX);
//        
//        deleteImageStorage.frame = CGRectMake(dateTextStorage.right+5, lastImageStorage.bottom + 10.0f, 18.f, 18.f);
//        
//        if (entity.visibility == 1) {
//          deleteTextStorage.frame = CGRectMake(dateTextStorage.right+5, lastImageStorage.bottom + 10.0f, 35.f, CGFLOAT_MAX);
//        }else{
//          deleteTextStorage.frame = CGRectMake(deleteImageStorage.right+10, lastImageStorage.bottom + 10.0f, 35.f, CGFLOAT_MAX);
//        }
//      }
//    }else if (entity.type == SearchImageTypeText){
//      menuPosition = CGRectMake(SCREEN_WIDTH - 54.0f, 10.0f + closeStorage.bottom - 14.5f, 50.0f, 50.0f);
//      
//      dateTextStorage.frame = CGRectMake(nameTextStorage.left, closeStorage.bottom + 10.0f, SCREEN_WIDTH - 80.0f, CGFLOAT_MAX);
//      
//      deleteImageStorage.frame = CGRectMake(dateTextStorage.right+5, closeStorage.bottom + 10.0f, 18.f, 18.f);
//      
//      if (entity.visibility == 1) {
//        deleteTextStorage.frame = CGRectMake(dateTextStorage.right+5, closeStorage.bottom + 10.0f, 35.f, CGFLOAT_MAX);
//      }else{
//        deleteTextStorage.frame = CGRectMake(deleteImageStorage.right+10, closeStorage.bottom+ 10.0f, 35.f, CGFLOAT_MAX);
//      }
//    }
//    
//    [self addStorage:nameTextStorage];//将Storage添加到遵循LWLayoutProtocol协议的类
//    [self addStorage:contentTextStorage];
//    [self addStorage:dateTextStorage];
//    [self addStorage:levelImageStorage];
//    [self addStorage:levelTextStorage];
//    [self addStorage:avatarStorage];
//    [self addStorages:imageStorageArray];//通过一个数组来添加storage，使用这个方法
//    self.avatarPosition = CGRectMake(10, 20, 40, 40);//头像的位置
//    self.menuPosition = menuPosition;//右下角菜单按钮的位置
//    self.imagePostions = imagePositionArray;//保存图片位置的数组
//    //如果是使用在UITableViewCell上面，可以通过以下方法快速的得到Cell的高度
//    self.cellHeight = [self suggestHeightWithBottomMargin:15.0f];
//  }
//  return self;
//  
//}

@end
