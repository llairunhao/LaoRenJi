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

@interface XHLiveViewController ()<XHLiveEventDelegate>

@property (nonatomic, strong) pgLibLive *live;
@property (nonatomic, strong) XHLiveEvent *liveEvent;
@property (nonatomic, strong) UIView *liveView;
@property (nonatomic, assign) XHCameraType camera;
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
}

- (void)closeButtonClick: (UIButton *) button{
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
    [self showLoadingHUD];
    WEAKSELF;
    XHAPIResultHandler handler = ^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        [weakSelf hideAllHUD];
        if (result.isSuccess) {
            
            if (weakSelf.type == XHLiveTypeAudio) {
                [weakSelf startAudioLive];
            }else{
                [weakSelf.view addSubview:weakSelf.liveView];
                [weakSelf startVideoLive];
            }
        }else {
            [weakSelf toast:result.message];
        }
    };
    
    [XHAPI startLiveByToken:[XHUser currentUser].token
                   liveType:self.type
                 cameraType:self.camera
                    handler:handler];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopLive];
}

- (XHLiveEvent *)liveEvent {
    if (!_liveEvent) {
        _liveEvent = [[XHLiveEvent alloc] init];
    }
    return _liveEvent;
}

- (pgLibLive *)live {
    if (!_live) {
        _live = [[pgLibLive alloc] init:self.liveEvent];
        NSString *serverAddress = @"connect.peergine.com:7781";
        BOOL result = [self.live InitializeEx:pgLibLiveModeRender
                                         user:@"xhkj071201"
                                         pass:@""
                                      svrAddr:serverAddress
                                    relayAddr:@""
                                   p2pTryTime:2
                                    initParam:@""
                                   videoParam:@"(MaxStream){0}"
                                   audioParam:@""];
        if (!result) {
            NSLog(@"Initialize failed! Please check the details from the log info.");
        }
    }
    return _live;
}

- (UIView *)liveView {
    if (!_liveView) {
        _liveView = [self.live WndCreate:0
                                       y:[UIView topSafeAreaHeight]
                                       w:CGRectGetWidth(self.view.bounds)
                                       h:280];
        _liveView.backgroundColor = [UIColor blackColor];
    }
    return _liveView;
}


- (void)startAudioLive {
    [self.live Start:[XHUser currentUser].currentDevice.simMark];
    [self.live AudioStart];
    [self.live AudioSyncDelay];
}

- (void)startVideoLive {
    [self startAudioLive];
    [self.live VideoStart];
}


- (void)stopLive {
    [_live AudioStop];
    [_live VideoStop];
    [_live Stop];
}

- (void)OnEvent:(NSString *)sAction data:(NSString *)sData render:(NSString *)sRender {
      NSLog(@"Action:%@, Data:%@, sRender:%@", sAction, sData, sRender);
    if ([sAction isEqualToString:@"Login"]) {
        // Login reply
        if ([sData isEqualToString:@"0"]) {
            NSString* sInfo = @"Login success";
            [self toast:sInfo];
        }
        else {
            NSString* sInfo = [NSString stringWithFormat:@"Login failed, error=%@", sData];
              [self toast:sInfo];
        }
    }if ([sAction isEqualToString:@"Logout"] ) {
        NSString* sInfo = @"Logout";
        [self toast:sInfo];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
