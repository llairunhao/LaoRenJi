//
//  QRSacnnerViewController.m
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/10/24.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import "QRSacnnerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface QRSacnnerViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;//设备输入
@property (nonatomic, strong) AVCaptureMetadataOutput *dataOutput;//数据输出
@property (nonatomic, strong) AVCaptureSession *session;//捕获会话任务
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;//相机图像层
@property (nonatomic, strong) UIView *maskView;


@end

@implementation QRSacnnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.maskView];
   
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    [button setTitle:@"手动输入" forState: UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startScan];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.session.isRunning) {
        [self.session stopRunning];
    }
}

- (AVCaptureDeviceInput *)deviceInput{
    if (!_deviceInput) {
        NSError *error;
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        _deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
    }
    return _deviceInput;
}

- (AVCaptureMetadataOutput *)dataOutput{
    if (!_dataOutput) {
        _dataOutput = [[AVCaptureMetadataOutput alloc]init];
        [_dataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        _dataOutput.rectOfInterest = [self scanRectOfInterest];
    }
    return _dataOutput;
}

- (CGRect)scanRect{

    CGSize scanSize = CGSizeMake(CGRectGetWidth(self.view.bounds) * 3/4, CGRectGetWidth(self.view.bounds) * 3/4);
    CGRect scanRect = CGRectMake((CGRectGetWidth(self.view.bounds) - scanSize.width)/2, (CGRectGetHeight(self.view.bounds) - scanSize.height)/2, scanSize.width, scanSize.height);
    return scanRect;
}


- (CGRect)scanRectOfInterest{
    CGRect scanRect = [self scanRect];
    scanRect = CGRectMake(scanRect.origin.y/CGRectGetHeight(self.view.bounds), scanRect.origin.x/CGRectGetWidth(self.view.bounds), scanRect.size.height/CGRectGetHeight(self.view.bounds),scanRect.size.width/CGRectGetWidth(self.view.bounds));
    return scanRect;
}

- (AVCaptureSession *)session{
    if (!_session) {
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:(CGRectGetHeight(self.view.bounds) < 500) ? AVCaptureSessionPreset640x480:AVCaptureSessionPreset1920x1080];
        if ([_session canAddInput:self.deviceInput]) {
            [_session addInput:self.deviceInput];
        }
        
        if ([_session canAddOutput:self.dataOutput]){
            [_session addOutput:self.dataOutput];
            self.dataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        }
    }
    return _session;
}
- (AVCaptureVideoPreviewLayer *)previewLayer{
    if (!_previewLayer) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _previewLayer.frame = [UIScreen mainScreen].bounds;
    }
    return _previewLayer;
}

- (void)startScan{
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    [self.session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray<AVMetadataMachineReadableCodeObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count == 0) {
        return;
    }
    [self.session stopRunning];
    NSString *result = [metadataObjects.firstObject stringValue];
    NSLog(@"%@",result);
    //信息处理
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:self.view.bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.8;
        UIBezierPath *bpath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) ];
        [bpath appendPath:[[UIBezierPath bezierPathWithRect:[self scanRect]] bezierPathByReversingPath]];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = bpath.CGPath;
        _maskView.layer.mask = shapeLayer;
    }
    return _maskView;
}


@end
