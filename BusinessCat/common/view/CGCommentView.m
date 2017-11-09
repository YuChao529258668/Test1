//
//  CGCommentView.m
//  CGSays
//
//  Created by mochenyang on 2016/10/8.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGCommentView.h"

typedef void (^CGCommentFinishInputBlock)(NSString *data);
typedef void (^CGCommentCancelBlock)(NSString *data);

@interface CGCommentView(){
    UIView *grayView;
    UIView *whiteView;
    UITextView *textview;
    UIButton *cancelBtn;
    UIButton *okBtn;
    
    CGCommentFinishInputBlock finishBlock;
    CGCommentCancelBlock cancelBlock;
    
    UILabel *placeLabel;
    NSString *placeStr;
    UILabel *countLabel;
}

@end

@implementation CGCommentView

-(instancetype)initWithContent:(NSString *)content placeholder:(NSString *)placeholder finish:(CGCommentFinishInputBlock)finish cancel:(CGCommentCancelBlock)cancel{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self){
        placeStr = placeholder;
        self.backgroundColor = [UIColor clearColor];
        finishBlock = finish;
        cancelBlock = cancel;
        grayView = [[UIView alloc]initWithFrame:self.bounds];
        grayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        grayView.alpha = 0;
        grayView.userInteractionEnabled = YES;
        [self addSubview:grayView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeMySelf)];
        [grayView addGestureRecognizer:tap];
        
        whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 150)];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.alpha = 0;
        [self addSubview:whiteView];
        
        cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:cancelBtn];
        
        okBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 0, 60, 40)];
        okBtn.enabled = NO;
        [okBtn setTitle:@"发送" forState:UIControlStateNormal];
        okBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [okBtn setTitleColor:CTThemeMainColor forState:UIControlStateNormal];
        [okBtn setTitleColor:[CTCommonUtil convert16BinaryColor:@"#E0E0E0"] forState:UIControlStateDisabled];
        [okBtn addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:okBtn];
      
//      if ([CTStringUtil stringNotBlank:placeStr]) {
//        countLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-120 , 0, 60, 40)];
//        [whiteView addSubview:countLabel];
//        countLabel.text = @"(0/10)";
//        countLabel.textColor = [CTCommonUtil convert16BinaryColor:@"#E0E0E0"];
//        countLabel.font = [UIFont systemFontOfSize:17];
//        
//      }
      
        //弹出键盘通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        //收起键盘通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        textview = [[UITextView alloc]initWithFrame:CGRectMake(15, 40, SCREEN_WIDTH - 30, 100)];
        textview.text = content;
        textview.delegate = self;
        textview.font = [UIFont systemFontOfSize:17];
        [whiteView addSubview:textview];
        [textview becomeFirstResponder];
        
        placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 7, SCREEN_WIDTH - 30, 28)];
        placeLabel.textColor = [UIColor colorWithWhite:0.7 alpha:0.5];
        placeLabel.userInteractionEnabled = NO;
        placeLabel.numberOfLines = 0;
        placeLabel.font = [UIFont systemFontOfSize:17];
        placeLabel.hidden = [CTStringUtil stringNotBlank:content]?YES:NO;
        [textview addSubview:placeLabel];
        if([CTStringUtil stringNotBlank:placeStr]){
            placeLabel.text = placeStr;
            [placeLabel sizeToFit];
        }
        
//        if([CTStringUtil stringNotBlank:placeStr]){
//            if([CTStringUtil stringNotBlank:content] && content.length >= 10){
//                okBtn.enabled = YES;
//            }
//        }else{
            if([CTStringUtil stringNotBlank:content]){
                okBtn.enabled = YES;
            }else{
                okBtn.enabled = NO;
            }
//        }
    }
    
    return self;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *temp = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    if([CTStringUtil stringNotBlank:placeStr]){
//        if([CTStringUtil stringNotBlank:temp] && temp.length >= 10){
//            okBtn.enabled = YES;
//          countLabel.hidden = YES;
//        }else{
//            okBtn.enabled = NO;
//          countLabel.hidden = NO;
//          countLabel.text = [NSString stringWithFormat:@"(%ld/10)",temp.length];
//        }
//    }else{
        if([CTStringUtil stringNotBlank:temp]){
            okBtn.enabled = YES;
        }else{
            okBtn.enabled = NO;
        }
//    }
    
    if (temp.length>0) {
        placeLabel.hidden = YES;
    }else{
        placeLabel.hidden = NO;
    }
}

-(void)showInView:(UIView *)view{
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        grayView.alpha = 1;
        whiteView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)closeMySelf{
  NSString *temp = [textview.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  if(cancelBlock){
    cancelBlock(temp);
  }
    __weak typeof(self) weakSelf = self;
    [textview resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        grayView.alpha = 0;
        whiteView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
    }];
}

-(void)okAction{
    NSString *temp = [textview.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(temp.length > 0){
        if(finishBlock){
            finishBlock(temp);
        }
        [self closeMySelf];
    }
}

-(void)cancelAction{
  NSString *temp = [textview.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(cancelBlock){
        cancelBlock(temp);
    }
    [self closeMySelf];
}

- (void)keyboardWillShow:(NSNotification *)note {
    
    //取出键盘最终的frame
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //取出键盘弹出需要花费的时间
    double duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect whiteRect = whiteView.frame;
    whiteRect.origin.y = SCREEN_HEIGHT-rect.size.height-whiteView.frame.size.height;
    [UIView animateWithDuration:duration animations:^{
        whiteView.frame = whiteRect;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillHide:(NSNotification *)note {
    //取出键盘弹出需要花费的时间
    double duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect whiteRect = whiteView.frame;
    whiteRect.origin.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:duration animations:^{
        whiteView.frame = whiteRect;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
