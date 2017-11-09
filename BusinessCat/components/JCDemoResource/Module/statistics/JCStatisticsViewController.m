//
//  StatisticsViewController.m
//  UltimateShow
//
//  Created by young on 17/3/22.
//  Copyright © 2017年 young. All rights reserved.
//

#import "JCStatisticsViewController.h"
#import <JCApi/JCApi.h>

@interface JCStatisticsViewController ()

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGR;

@end

@implementation JCStatisticsViewController

- (UISegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Participants", @"Config", @"Network", @"Transport"]];
        for (NSUInteger i = 0; i < _segmentedControl.numberOfSegments; i++) {
            [_segmentedControl setWidth:80 forSegmentAtIndex:i];
        }
        
        [_segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        _segmentedControl.selectedSegmentIndex = 0;
        CGRect frame = _segmentedControl.frame;
        frame.origin.y = 20;
        frame.origin.x = (self.view.frame.size.width - frame.size.width) / 2;
        _segmentedControl.frame = frame;
    }
    return _segmentedControl;
}

- (UITextView *)textView
{
    if (!_textView) {
        CGRect frame = self.view.frame;
        frame.origin.x = _segmentedControl.frame.origin.x;
        frame.size.width = _segmentedControl.frame.size.width;
        frame.origin.y = _segmentedControl.frame.origin.y + _segmentedControl.frame.size.height;
        frame.size.height -= frame.origin.y;
        _textView = [[UITextView alloc] initWithFrame:frame];
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _textView.editable = NO;
        _textView.font = [UIFont fontWithName:@"Courier" size:10];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.editable = NO;
    }
    return _textView;
}

- (UITapGestureRecognizer *)tapGR
{
    if (!_tapGR) {
        _tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        _tapGR.cancelsTouchesInView = NO;
    }
    return _tapGR;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"StatisticsViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.textView];
    
    [self.view addGestureRecognizer:self.tapGR];
    
    [self refreshStatistics];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tap:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.view];
    if (CGRectContainsPoint(self.segmentedControl.frame, point)) {
        return;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshStatistics) object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)segmentedControlValueChanged:(id)sender
{
    NSString *stat;
    switch ([sender selectedSegmentIndex]) {
        case 0:
            stat = [[JCEngineManager sharedManager] getStsParticipant];
            break;
        case 1:
            stat = [[JCEngineManager sharedManager] getStsConfig];
            break;
        case 2:
            stat = [[JCEngineManager sharedManager] getStsNet];
            break;
        case 3:
            stat = [[JCEngineManager sharedManager] getStsTransport];
            break;
    }
    
    if (stat && stat.length) {
        self.textView.text = stat;
    } else {
        self.textView.text = @"No Data";
    }
}

- (void)refreshStatistics
{
    [self segmentedControlValueChanged:self.segmentedControl];
    [self performSelector:@selector(refreshStatistics) withObject:nil afterDelay:1];
}

@end
