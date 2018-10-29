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

@interface XHLiveViewController ()<XHLiveEventDelegate>

@property (nonatomic, strong) pgLibLive *live;
@property (nonatomic, strong) XHLiveEvent *liveEvent;
@property (nonatomic, strong) UIView *liveView;

@end

@implementation XHLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"监控";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self showLoadingHUD];
    WEAKSELF;
    
    XHAPIResultHandler handler = ^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        [weakSelf hideAllHUD];
        if (result.isSuccess) {
            [weakSelf.view addSubview:weakSelf.liveView];
            if (weakSelf.type == XHLiveTypeAudio) {
                [weakSelf startAudioLive];
            }else{
                [weakSelf startVideoLive];
            }
        }else {
            [weakSelf toast:result.message];
        }
    };
    
    [XHAPI startLiveByToken:[XHUser currentUser].token
                   liveType:self.type
                 cameraType:XHCameraTypeRear
                    handler:handler];
    
    self.navigationBar.backHandler = ^{
        [weakSelf stopLive];
        [weakSelf dismissViewControllerAnimated:true completion:nil];
    };

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
                                         user:@"ios_test"
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
                                       h:240];
    }
    return _liveView;
}


- (void)startAudioLive {
    [_live Start:@"xhkj071201"];
    [_live AudioStart];
    [_live AudioSyncDelay];
}

- (void)startVideoLive {
    [self startAudioLive];
    [_live VideoStart];
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
