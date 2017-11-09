//
//  VideoDisplayView.h
//  UltimateShow
//
//  Created by Nathan Zheng on 2017/1/13.
//  Copyright © 2017年 young. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VideoOffImageSize) {
    VideoOffImageSize24 = 0,    // 24x24
    VideoOffImageSize40,        // 40x40
    VideoOffImageSize50         // 50x50
};

@interface JCVideoDisplayView : UIView

@property (nonatomic, readonly, strong) UIView *renderView;  //渲染视频的view，不能add subview

- (void)showVideoOffViewOfSize:(VideoOffImageSize)size;

- (void)hideVideoOffView;

@end
