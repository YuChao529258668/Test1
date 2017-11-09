//
//  ZbarController.m
//  Coyoo
//
//  Created by Calon Mo on 16/5/9.
//  Copyright © 2016年 Coyoo. All rights reserved.
//

#import "ZbarController.h"
#import <AVFoundation/AVFoundation.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define TOPBAR_ALPHA 0.8
#define translucent_alpha 0.5
#define transparent_length SCREEN_WIDTH*2.3/5

@interface ZbarController ()<AVCaptureMetadataOutputObjectsDelegate>{
    AVCaptureDevice *device;
    AVCaptureDeviceInput *input;
    AVCaptureMetadataOutput *output;
    AVCaptureSession * session;
    AVCaptureVideoPreviewLayer *previewLayer;
    UIImageView *center;
    UIImageView *line;
    NSTimer *timer;
    
    UIImageView *close;
    UIImageView *light;
    
    BOOL torchIsOn;
}

@end

//焦距
static float kCameraScale=1.0;

@implementation ZbarController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideCustomNavi];
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"扫一扫";
    
    //获取摄像设备
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    NSError *error;
    input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if(error){
        NSString *alertMsg = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-相机”选项中，允许%@访问你的相机",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:alertMsg delegate:self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
        [alert show];
        
    }else{
        //创建输出流
        output = [[AVCaptureMetadataOutput alloc]init];
        //设置代理 在主线程里刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //初始化链接对象
        session = [[AVCaptureSession alloc]init];
        //高质量采集率
        [session setSessionPreset:AVCaptureSessionPresetHigh];
        [session addInput:input];
        [session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode];
        
        previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
        previewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
        previewLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.view.layer insertSublayer:previewLayer atIndex:0];
        [session startRunning];

    }
    
    
    center = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-transparent_length)/2, (SCREEN_HEIGHT-transparent_length)/2, transparent_length, transparent_length)];
    center.backgroundColor = [UIColor clearColor];
    center.image = [UIImage imageNamed:@"Scan_Success"];
    [previewLayer addSublayer:center.layer];
    
    line = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12,transparent_length-20, 5)];
    line.image=[UIImage imageNamed:@"scanline"];
    [center addSubview:line];
    
    close = [[UIImageView alloc]initWithFrame:CGRectMake(center.frame.origin.x, CGRectGetMaxY(center.frame)+50, 50, 50)];
    close.userInteractionEnabled = YES;
    close.tag = 0;
    [close setImage:[UIImage imageNamed:@"CloseButtonNormal"]];
    [self.view addSubview:close];
    
    
    light = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(center.frame)-50, CGRectGetMaxY(center.frame)+50, 50, 50)];
    light.userInteractionEnabled = YES;
    light.tag = 1;
    [light setImage:[UIImage imageNamed:@"FlashLightCloseNormal"]];
    [self.view addSubview:light];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topAction:)];
    [close addGestureRecognizer:tap];
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topAction:)];
    [light addGestureRecognizer:tap];
    
    
    kCameraScale =1.5;
    AVCaptureConnection *connect=[output connectionWithMediaType:AVMediaTypeVideo];
    [previewLayer setAffineTransform:CGAffineTransformMakeScale(kCameraScale, kCameraScale)];
    connect.videoScaleAndCropFactor=kCameraScale;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)topAction:(UITapGestureRecognizer *)recognizer{
    int tag = (int)recognizer.view.tag;
    if(tag == 0){
        [self dismissViewControllerAnimated:YES completion:^{
            if(cancelBlock){
                cancelBlock();
            }
        }];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (tag == 1){
        [self turnTorchOn:!torchIsOn];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self scanTimer];
    [self startScanLine];
    
    [self.view bringSubviewToFront:close];
    [self.view bringSubviewToFront:light];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    if(cancelBlock){
        cancelBlock();
    }
    [self turnTorchOn:NO];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        [session stopRunning];
        [self playSound];
        [timer invalidate];
        if(scanBlock){
            [self dismissViewControllerAnimated:YES completion:^{
                scanBlock(metadataObject.stringValue);
            }];
        }
    }
}

static SystemSoundID shake_sound_male_id = 0;

-(void) playSound{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"kakalib_scan" ofType:@"wav"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:path]),&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
    }
}

-(id)initWithBlock:(ZbarControllerBlock)block cancel:(ZbarControllerCancelBlock)cancel{
    self = [super init];
    if(self){
        scanBlock = block;
        cancelBlock = cancel;
    }
    return self;
}


-(void)startScanLine{
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(scanTimer) userInfo:nil repeats:YES];
}

-(void)scanTimer{
    [UIView animateWithDuration:2 animations:^{
        if(line.frame.origin.y == transparent_length-20){
            line.frame=CGRectMake(10, 12, line.frame.size.width, line.frame.size.height);
        }else{
            line.frame=CGRectMake(10, transparent_length-20, line.frame.size.width,line.frame.size.height);
        }
    }completion:^(BOOL finshed){
        
    }];
}

- (void)turnTorchOn:(BOOL)on{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                torchIsOn = YES;
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                torchIsOn = NO;
            }
            [device unlockForConfiguration];
        }
    }
}

//禁止屏幕旋转
- (BOOL)shouldAutorotate{
    return NO;
}




-(void)dealloc{
    if(cancelBlock){
        cancelBlock();
    }
    [self turnTorchOn:NO];
    [timer invalidate];
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
