//
//  QRScanningViewController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/26.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "QRScanningViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "DeviceCodeInputViewController.h"
#import "NSString+Valid.h"
#import "XHAPI+API.h"
#import "XHUser.h"
#import "AlarmTextEditController.h"
#import "UIViewController+ChildController.h"

@interface QRScanningViewController ()<AVCaptureMetadataOutputObjectsDelegate, DeviceBindingDelegate>

@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;//设备输入
@property (nonatomic, strong) AVCaptureMetadataOutput *dataOutput;//数据输出
@property (nonatomic, strong) AVCaptureSession *session;//捕获会话任务
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;//相机图像层
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) UIImageView *scanLine;
@property (nonatomic, strong) UIImageView *scanView;
@end

@implementation QRScanningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"设备绑定";
    CGRect rect = self.view.bounds;
    rect.origin.y = [UIView topSafeAreaHeight];
    rect.size.height -= [UIView safeAreaHeight];
    self.maskView.frame = rect;
    [self.view addSubview:self.maskView];
    self.previewLayer.frame = rect;
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:@"手动输入" forState:UIControlStateNormal];
    [self.navigationBar addRigthItem:button];
    [button addTarget:self action:@selector(navigationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self startScan];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanSquare"]];
    CGRect c = [self.maskView convertRect:[self scanRect] toView:self.view];
    imageView.frame = c;
    [self.view addSubview:imageView];
    _scanView = imageView;
    
    UIImageView *scanLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanLine"]];
    CGSize size = [scanLine sizeThatFits:CGSizeZero];
    rect.size = size;
    rect.origin.x = (CGRectGetWidth(self.maskView.frame) - size.width ) / 2;
    rect.origin.y = CGRectGetMinY(imageView.frame);
    scanLine.frame = rect;
    [self.view addSubview:scanLine];
    _scanLine = scanLine;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startScan];
}

- (void)dealloc
{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

- (void)navigationButtonClick: (UIButton *)button {
    DeviceCodeInputViewController *controller = [[DeviceCodeInputViewController alloc] init];
    controller.delegate = self;
    [self stopScan];
    [self.navigationController pushViewController:controller animated:true];
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

- (CGRect)scanRectOfInterest{
    
    CGRect scanRect = [self scanRect];
    scanRect = CGRectMake(scanRect.origin.y/CGRectGetHeight(self.view.bounds), scanRect.origin.x/CGRectGetWidth(self.view.bounds), scanRect.size.height/CGRectGetHeight(self.view.bounds),scanRect.size.width/CGRectGetWidth(self.view.bounds));
    return scanRect;
}

- (CGRect)scanRect{
 
    CGSize scanSize = [UIImage imageNamed:@"scanSquare"].size;
    scanSize.width -= 2;
    scanSize.height -= 2;
    CGRect scanRect = CGRectMake((CGRectGetWidth(self.view.bounds) - scanSize.width)/2, (CGRectGetHeight(self.view.bounds) - scanSize.height)/2 - [UIView navigationBarHeight], scanSize.width, scanSize.height);
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
  //  [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    if (!self.session.isRunning) {
         [self.session startRunning];
        if (!_timer) {
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
            dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, NSEC_PER_SEC / 60, 0 * NSEC_PER_SEC);
            WEAKSELF;
            dispatch_source_set_event_handler(_timer, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf moveScanLine];
                });
            });
            dispatch_resume(_timer);
        }
    }
}

- (void)stopScan {
    if (self.session.isRunning) {
        [self.session stopRunning];
        if (_timer) {
            dispatch_source_cancel(_timer);
            _timer = nil;
        }
    }
}

- (void)moveScanLine {
    CGRect rect = _scanLine.frame;
    rect.origin.y += 1;
    if (CGRectGetMaxY(rect) > CGRectGetMaxY(_scanView.frame)) {
        rect.origin.y = CGRectGetMinY(_scanView.frame);
    }
    _scanLine.frame = rect;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray<AVMetadataMachineReadableCodeObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count == 0) {
        return;
    }

    [self stopScan];
    NSString *result = [metadataObjects.firstObject stringValue];
    if (![self bindDeviceCode:result controller:self]) {
        [self startScan];
    }
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


- (BOOL)bindDeviceCode:(NSString *)code controller:(UIViewController *)controller {
    if (code.length == 0 || ![code isNumberOnly]) {
        [self toast:@"请输入正确设备编号"];
        return false;
    }
    AlarmTextEditController *editController = [[AlarmTextEditController alloc] init];
    editController.placeholder = @"请输入设备昵称";
    editController.title = @"设备昵称";
    UNSAFESELF;
    editController.textHandler = ^(NSString *text) {
        [unsafeSelf bindDeviceCode:code deviceName:text controller:controller];
    };
    [controller addController:editController];
    return true;
    
}

- (void)bindDeviceCode:(NSString *)code deviceName: (NSString *)deviceName controller:(UIViewController *)controller {
    [controller showLoadingHUD];
    __weak typeof(controller) weakController = controller;
    XHAPIResultHandler handler = ^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        [weakController hideAllHUD];
        if (result.isSuccess) {
            [[NSNotificationCenter  defaultCenter] postNotificationName:XHDevicesDidChangeNotification object:nil];
            [weakController toast:@"绑定成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakController.navigationController popToRootViewControllerAnimated:true];
            });
        }else {
            [weakController toast:result.message];
        }
    };
    [XHAPI bindDeviceByToken:[XHUser currentUser].token
                     simMark:code
                  deviceName:deviceName
                     handler:handler];
}
@end
