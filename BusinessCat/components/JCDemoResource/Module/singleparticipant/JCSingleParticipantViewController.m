//
//  SingleViewController.m
//  UltimateShow
//
//  Created by 沈世达 on 17/4/19.
//  Copyright © 2017年 young. All rights reserved.
//

#import "JCSingleParticipantViewController.h"
#import "JCSingleParticipantReformer.h"
#import "JCVideoDisplayView.h"

@interface JCSingleParticipantViewController ()

@property (nonatomic, strong) JCVideoDisplayView *preview;
@property (nonatomic, strong) JCSingleParticipantReformer *participantReformer;

@end

@implementation JCSingleParticipantViewController

- (JCVideoDisplayView *)preview
{
    if (!_preview) {
        _preview = [[JCVideoDisplayView alloc] initWithFrame:self.view.bounds];
        _preview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _preview;
}

- (JCSingleParticipantReformer *)participantReformer
{
    if (!_participantReformer) {
        _participantReformer = [[JCSingleParticipantReformer alloc] init];
    }
    return _participantReformer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.preview];
    [self.participantReformer bindRenderView:self.preview];
    
    UITapGestureRecognizer *doubleTapGesure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
    [_preview addGestureRecognizer:doubleTapGesure];
}

- (void)singleTapGesture:(UIGestureRecognizer *)tapGesture
{
    if (_delegate) {
        [_delegate didSelectView];
    }
}

- (void)reloadSingleParticpantWithUserId:(NSString *)userId
{
    if (_participantReformer) {
        [_participantReformer reloadWithUserId:userId];
    }
}

- (void)stopSingleParticpant
{
    if (_participantReformer) {
        [_participantReformer stop];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
