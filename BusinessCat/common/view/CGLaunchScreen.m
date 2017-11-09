//
//  CGLaunchScreen.m
//  CGSays
//
//  Created by mochenyang on 2017/3/2.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGLaunchScreen.h"
#import "CGUrlView.h"
#import "CGUserOrganizaJoinEntity.h"
#import "AppDelegate.h"

@interface CGLaunchScreen()
@property (nonatomic, strong) CGUrlView *urlView;
@end

@implementation CGLaunchScreen

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = 999;
        self.contentMode = UIViewContentModeScaleAspectFill;
        NSString *viewOrientation = @"Portrait";    //横屏请设置成 @"Landscape"
        NSString *launchImage = nil;
        NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
        for (NSDictionary* dict in imagesDict){
            CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
            if (CGSizeEqualToSize(imageSize, frame.size) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]){
                launchImage = dict[@"UILaunchImageName"];
            }
        }
        self.image = [UIImage imageNamed:launchImage];
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(close) userInfo:nil repeats:NO];
    }
    return self;
}

-(void)close{
  
  [ObjectShareTool sharedInstance].isLaunchScreen = YES;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         weakSelf.alpha = 0.0f;
                         weakSelf.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.2, 1.2, 1);
                     }completion:^(BOOL finished) {
                         //启动时隐藏状态栏，启动后这里显示
                         [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//                       if ([[UIPasteboard generalPasteboard].string hasPrefix:@"http"]) {
//                         NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//                         NSString *currChangeCount = [user objectForKey:@"changeCount"];
//                         if ([UIPasteboard generalPasteboard].changeCount > currChangeCount.integerValue) {
//                           weakSelf.urlView = [[CGUrlView alloc]initWithUrl:[UIPasteboard generalPasteboard].string block:^(NSString *title, NSString *icon) {
//                             CGDiscoverReleaseSourceViewController *vc = [[CGDiscoverReleaseSourceViewController alloc]initWithBlock:^(BOOL isCurrent, NSInteger reloadIndex, BOOL isOutside) {
//                               
//                             }];
//                             if([ObjectShareTool sharedInstance].currentUser.companyList && [ObjectShareTool sharedInstance].currentUser.companyList.count > 0){
//                               CGUserOrganizaJoinEntity *companyEntity = [ObjectShareTool sharedInstance].currentUser.companyList[0];
//                               CGHorrolEntity *entity;
//                               if (companyEntity.companyType == 2) {
//                                 entity = [[CGHorrolEntity alloc]initWithRolId:companyEntity.classId rolName:companyEntity.companyName sort:0];
//                               }else{
//                                 entity = [[CGHorrolEntity alloc]initWithRolId:companyEntity.companyId rolName:companyEntity.companyName sort:0];
//                               }
//                               entity.rolType = [NSString stringWithFormat:@"%d",companyEntity.companyType];
//                               vc.currentEntity = entity;
//                               vc.releaseType = DiscoverReleaseTypeCompany;
//                             }else{
//                               vc.releaseType = DiscoverReleaseTypeNoCompany;
//                             }
//                             
//                             CGDiscoverLink *link = [[CGDiscoverLink alloc]init];
//                             link.linkIcon = icon;
//                             link.linkId = [UIPasteboard generalPasteboard].string;
//                             link.linkTitle = title;
//                             link.linkType = 1;
//                             vc.link = link;
//                             if ([ObjectShareTool sharedInstance].currentUser.companyList.count > 0) {
//                               vc.releaseType = HeadlineReleaseTypeCompany;
//                             }else{
//                               vc.releaseType = HeadlineReleaseTypeNoCompany;
//                             }
//                             AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                             [appDelegate.navi pushViewController:vc animated:YES];
//                           }];
//                           [weakSelf.window addSubview:weakSelf.urlView];
//                         }
//                         NSString *changeCount = [NSString stringWithFormat:@"%ld",[UIPasteboard generalPasteboard].changeCount];
//                         [user setObject:changeCount forKey:@"changeCount"];
//                       }
                       [weakSelf removeFromSuperview];
                     }];
}

-(void)dealloc{
    
}

@end
