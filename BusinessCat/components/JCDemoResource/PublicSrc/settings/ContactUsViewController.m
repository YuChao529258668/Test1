//
//  ContactUsViewController.m
//  UltimateShow
//
//  Created by young on 16/12/20.
//  Copyright © 2016年 young. All rights reserved.
//

#import "ContactUsViewController.h"
#import "Toast.h"

@interface ContactUsViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ContactUsViewController

- (instancetype)init
{
    self = [super initWithNibName:@"ContactUsViewController" bundle:[NSBundle mainBundle]];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"contact us", nil);
    self.automaticallyAdjustsScrollViewInsets = NO;
    _backView.layer.borderColor = [UIColor colorWithRed:200.0f/255.0f green:199.0f/255.0f blue:204.0f/255.0f alpha:1.0f].CGColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"send", nil) style:UIBarButtonItemStylePlain target:self action:@selector(send)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_textView becomeFirstResponder];
}

- (void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)send
{
    NSString *content = _textView.text;
    if (content.length == 0) {
        [Toast showWithText:NSLocalizedString(@"describe the issue you encountered", nil) topOffset:230 duration:1];
        return;
    }
    
    [[JCEngineManager sharedManager] commitLogWithMemo:content];
    
    [Toast showWithText:NSLocalizedString(@"thank you for your report", nil) topOffset:230 duration:1];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger len = textView.text.length;
    _label.hidden = len;
}

@end
