//
//  YCVideoController.h
//  BusinessCat
//
//  Created by 余超 on 2018/1/12.
//  Copyright © 2018年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import <TXRTMPSDK/TXLivePlayer.h>

// 播放在线视频，参考 TCVideoPreviewViewController，封装 TXLivePlayer

@interface YCVideoController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIView *toolBar;


@property (nonatomic,strong) NSString *videoPath;
@property (nonatomic,strong) NSMutableArray<NSString *> *videoUrls; // 视频文件

@end
