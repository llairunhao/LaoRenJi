//
//  XHLiveViewController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/13.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHLiveViewController.h"
#import "pgDybLiveMulti/pgLibLive.h"
#import "XHLiveEvent.h"
#import "XHAPI+API.h"
#import "XHUser.h"
#import "XHDevice.h"
#import "UIViewController+HUD.h"

@interface XHLiveViewController ()<XHLiveEventDelegate>

@property (nonatomic, strong) pgLibLiveMultiRender *live;
@property (nonatomic, strong) XHLiveEvent *liveEvent;
@property (nonatomic, strong) UIView *liveView;
@property (nonatomic, assign) XHCameraType camera;
@property (nonatomic, assign) BOOL running;

@end

@implementation XHLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.type == XHLiveTypeAudio ?  @"音频监控" : @"视频监控";
    self.view.backgroundColor = [UIColor whiteColor];
    self.camera = XHCameraTypeRear;
    [self refreshData];
    self.navigationBar.backButton.hidden = true;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"live_close"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    CGRect rect = self.view.bounds;
    CGSize size = CGSizeMake(100, 100);
    rect.origin.y = CGRectGetHeight(self.view.bounds) - size.height - [UIView bottomSafeAreaHeight] - 24.f;
    rect.origin.x = (CGRectGetWidth(self.view.bounds) - size.width)  / 2;
    rect.size = size;
    button.frame = rect;
    
    if (self.type == XHLiveTypeAudio) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"live_audio"];
        [self.view addSubview:imageView];
        
        rect = self.view.bounds;
        size = CGSizeMake(240, 240);
        rect.origin.y = [UIView topSafeAreaHeight] + 48.f;
        rect.origin.x = (CGRectGetWidth(self.view.bounds) - size.width)  / 2;
        rect.size = size;
        imageView.frame = rect;
    }else {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"切换摄像头" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:button];
        [self.navigationBar addRigthItem:button];
        [button addTarget:self action:@selector(cameraBttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvMonitorReadyNoti:) name:XHDeviceDidReadyMonitorNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)closeButtonClick: (UIButton *) button{
    [self stopLive];
   // [XHAPI stopLiveByToken:[XHUser currentUser].token handler:nil];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)cameraBttonClick: (UIButton *)button {
    if (self.camera == XHCameraTypeRear) {
        self.camera = XHCameraTypeFront;
    }else {
        self.camera = XHCameraTypeRear;
    }
    [self refreshData];
}

- (void)refreshData {
    self.navigationBar.userInteractionEnabled = false;
    [self showLoadingHUD: @"发起监控请求..."];
    WEAKSELF;
    XHAPIResultHandler handler = ^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        if (result.isSuccess) {
            [weakSelf showLoadingHUD:@"等待设备响应..."];
        }else {
            weakSelf.navigationBar.userInteractionEnabled = true;
            [weakSelf hideAllHUD];
            [weakSelf toast:result.message];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:true];
            });
        }
    };

    [XHAPI startLiveByToken:[XHUser currentUser].token
                   liveType:self.type
                 cameraType:self.camera
                    handler:handler];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (XHLiveEvent *)liveEvent {
    if (!_liveEvent) {
        _liveEvent = [[XHLiveEvent alloc] init];
        _liveEvent.delegate = self;
    }
    return _liveEvent;
}

- (pgLibLiveMultiRender *)live {
    if (!_live) {
        _live = [[pgLibLiveMultiRender alloc] init:self.liveEvent];
    }
    return _live;
}

- (UIView *)liveView {
    if (!_liveView) {
        _liveView = [pgLibLiveMultiView Get:@"View0"];
        CGRect rect = self.view.bounds;
        rect.origin.y = [UIView topSafeAreaHeight];
        rect.size.height = 240.f / 320.f * CGRectGetWidth(rect);
        _liveView.frame = rect;
        _liveView.backgroundColor = [UIColor blackColor];
    }
    return _liveView;
}


- (void)recvMonitorReadyNoti: (NSNotification *)noti {
    NSInteger status = [noti.object integerValue];
    if (status == XHMonitorStatusReady) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLoadingHUD:@"准备开始监控..."];
        });
        [self stopLive];
        [self startLive];
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideAllHUD];
            [self toast:[NSString stringWithFormat:@"终端返回异常:%@", @(status)]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:true];
            });
        });
    }
}

- (BOOL)connect {
    NSString *serverAddress = @"connect.peergine.com:7781";
    NSString* sInitParam = @"(Debug){1}";
    
    int iErr = [self.live Initialize:@"ios_test"
                            pass:@""
                         svrAddr:serverAddress
                       relayAddr:@""
                      p2pTryTime:1
                       initParam:sInitParam];
    if (iErr != 0) {
        NSLog(@"pgLibLiveMulti: initialize failed! iErr=%d", iErr);
        NSString* sInfo = [NSString stringWithFormat:@"Initialize failed! iErr=%d", iErr];
        [self toast:sInfo];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:true];
        });
        return false;
    }
    return true;
}

- (void)startLive {
    if (!_running) {
        if ([self connect]) {
            if (self.type == XHLiveTypeAudio) {
                [self startAudioLive];
            }else{
                [self.view addSubview:self.liveView];
                [self startVideoLive];
            }
        }
        _running = true;
    }
}

- (void)startAudioLive {
    [self.live Connect:@"xhkj071203"];
    [self.live AudioStart:@"xhkj071203" audioID:0 param:@""];
    [self.live AudioSyncDelay:@"xhkj071203" audioID:0 videoID:0];
}

- (void)startVideoLive {
  //  [self startAudioLive];
    [self.live Connect:@"xhkj071203"];
    [self.live VideoStart:@"xhkj071203" videoID:0 param:@"" nodeView:self.liveView];
    [self.live AudioStart:@"xhkj071203" audioID:0 param:@""];
    [self.live AudioSyncDelay:@"xhkj071203" audioID:0 videoID:0];
  
}

- (void)disconnect {
    
    [_live AudioStop:@"xhkj071203" audioID:0];
    if (self.type == XHLiveTypeVideo) {
        [_live VideoStop:@"xhkj071203" videoID:0];
    }
    [_live Disconnect:@"xhkj071203"];
}


- (void)stopLive {
    [self disconnect];
    if (_liveView) {
        [_liveView removeFromSuperview];
        [pgLibLiveMultiView Release:_liveView];
        _liveView = nil;
    }
    [_live Clean];
    _running = false;
}

-(void)OnEvent:(NSString *)sAction data:(NSString *)sData capid:(NSString *)sCapID; {
    NSLog(@"-------》Action:%@, Data:%@, sCapID:%@", sAction, sData, sCapID);
   
    if ([sAction isEqualToString:@"VideoStatus"]) {
        // Video status report
    }
    else if ([sAction isEqualToString:@"Login"]) {
        // Login reply
        if ([sData isEqualToString:@"0"]) {
            NSString* sInfo = @"Login success";
            [self toast:sInfo];
        }
        else {
            NSString* sInfo = [NSString stringWithFormat:@"Login failed, error=%@", sData];
            [self toast:sInfo];
        }
    }
    else if ([sAction isEqualToString:@"Logout"] ) {
        // Logout
        NSString* sInfo = @"Logout";
        [self toast:sInfo];
    }
    else if ([sAction isEqualToString:@"Connect"] ) {
        // Connect to capture
//        NSString* sInfo = @"Connect to capture";
//        [self toast:sInfo];
        [self hideAllHUD];
    }
    else if ([sAction isEqualToString:@"Disconnect"] ) {
        // Disconnect from capture
//        NSString* sInfo = @"Disconnect from capture";
//        [self toast:sInfo];
    }
    else if ([sAction isEqualToString:@"Offline"]) {
        // The capture is offline.
        NSString* sInfo = @"The capture is offline";
        [self toast:sInfo];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
