//
//  CGSearchVoiceView.m
//  CGSays
//
//  Created by zhu on 2017/4/14.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGSearchVoiceView.h"
//带界面的语音识别控件
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import <iflyMSC/iflyMSC.h>

@interface CGSearchVoiceView ()<IFlyRecognizerViewDelegate>
@property (nonatomic, copy) CGSearchVoiceBlock voiceBlock;
@property (nonatomic, copy) CGSearchTextFieldChangeBlock changeText;
@property(nonatomic,retain)IFlyRecognizerView *iflyRecognizerView;
@property (nonatomic, copy) NSString *placeholder;
@property(nonatomic,retain)NSMutableString *speekWord;//语音识别的词
@end

@implementation CGSearchVoiceView

-(NSMutableString *)speekWord{
  if(!_speekWord){
    _speekWord = [NSMutableString string];
  }
  return _speekWord;
}

-(instancetype)initWithPlaceholder:(NSString *)placeholder voiceBlock:(CGSearchVoiceBlock)voiceBlock changeText:(CGSearchTextFieldChangeBlock)changeText{
  self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
  if(self){
    self.voiceBlock = voiceBlock;
    self.changeText = changeText;
    self.placeholder = placeholder;
    self.backgroundColor = CTCommonViewControllerBg;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 30)];
    view.layer.cornerRadius = 4;
    view.layer.masksToBounds = YES;
    view.layer.borderColor = CTCommonLineBg.CGColor;
    view.layer.borderWidth = 1;
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    [view addSubview:self.textField];
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(view.frame.size.width-30, 0, 30, 30)];
    [searchBtn addTarget:self action:@selector(voiceSearch) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setImage:[UIImage imageNamed:@"searchVoiceinput"] forState:UIControlStateNormal];
    [view addSubview:searchBtn];
  }
  return self;
}

-(UITextField *)textField{
  if (!_textField) {
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30-30, 30)];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 22)];
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(8, 0, 22, 22)];
    [view addSubview:iv];
    iv.image = [UIImage imageNamed:@"tuanduiquansousuo"];
    _textField.leftView = view;
    _textField.rightViewMode = UITextFieldViewModeAlways;
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.placeholder = self.placeholder;
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.enablesReturnKeyAutomatically = YES;
    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _textField.clearButtonMode = UITextFieldViewModeAlways;
  }
  return _textField;
}

- (void)textFieldDidChange:(UITextField *)textField
{
  self.changeText(textField.text);
}

-(void)voiceSearch{
  [self.textField resignFirstResponder];
  //初始化语音识别控件
  self.iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
  self.iflyRecognizerView.delegate = self;
  [self.iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
  //asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
  [self.iflyRecognizerView setParameter:nil forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
  //启动识别服务
  [self.iflyRecognizerView start];
}

/*科大讯飞语音识别回调
 @param resultArray 识别结果
 @ param isLast 表示是否最后一次结果
 */
- (void)onResult: (NSArray *)resultArray isLast:(BOOL) isLast{
  for(NSString *key in [resultArray[0] allKeys]){
    NSData *wordData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *allWordDict = [NSJSONSerialization JSONObjectWithData:wordData options:kNilOptions error:nil];
    NSArray *wordArray = [allWordDict objectForKey:@"ws"];
    for(NSDictionary *wordDict in wordArray){
      for(NSDictionary *itemWord in [wordDict objectForKey:@"cw"]){
        NSString *end = [itemWord objectForKey:@"w"];
        if(![end containsString:@"。"] && ![end containsString:@"，"]&& ![end containsString:@"！"]){
          [self.speekWord appendString:end];
        }
      }
    }
  }
  if(isLast){//最后一次
    NSString *word = self.speekWord;
    self.textField.text = word;
    [self.textField becomeFirstResponder];
    if([CTStringUtil stringNotBlank:word]){//word为语音识别结果
      self.voiceBlock(word);
    }
    self.speekWord = nil;
    self.iflyRecognizerView = nil;
  }
}
/*识别会话错误返回代理
 @ param  error 错误码
 */
- (void)onError: (IFlySpeechError *) error{
  
}

@end
