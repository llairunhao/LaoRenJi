//
//  ChatViewController.m
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/10/22.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import "ChatViewController.h"

#import "XHAPI+API.h"
#import "XHUser.h"
#import "AudioMananger.h"

@interface ChatViewController ()<AudioManangerDelegate>

@property (nonatomic, strong) AudioMananger *manager;

@property (nonatomic, strong) NSString *playUrlString;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    UIButton *button = [UIButton buttonWithType: UIButtonTypeSystem];
    [button setTitle:@"录音" forState: UIControlStateNormal];
    [button setTitleColor:[UIColor C1] forState:UIControlStateNormal];
    CGSize size = [button sizeThatFits:CGSizeZero];
    CGRect rect = self.view.frame;
    rect.origin.x = (CGRectGetWidth(rect) - size.width ) / 2;
    rect.origin.y = 150;
    rect.size = size;
    button.frame = rect;
    [button addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType: UIButtonTypeSystem];
    [button setTitle:@"停止" forState: UIControlStateNormal];
    [button setTitleColor:[UIColor C1] forState:UIControlStateNormal];
    rect.origin.y = CGRectGetMaxY(rect) + 24.f;
    button.frame = rect;
    [button addTarget:self action:@selector(stopRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType: UIButtonTypeSystem];
    [button setTitle:@"播放" forState: UIControlStateNormal];
    [button setTitleColor:[UIColor C1] forState:UIControlStateNormal];
    rect.origin.y = CGRectGetMaxY(rect) + 24.f;
    button.frame = rect;
    [button addTarget:self action:@selector(playRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    self.manager = [[AudioMananger alloc] init];
    self.manager.delegate = self;
    
    [XHAPI listOfAudiosByToken:[XHUser currentUser].token handler:^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        
    }];
}

- (void)startRecord {
    [self.manager startRecord];
}

- (void)stopRecord {
    [self.manager stopRecord];
}


- (void)playRecord {
    [self.manager playAudioFromUrlString:self.playUrlString];
    
}

#pragma mark- AudioManangerDelegate
- (void)recordingDidFinish:(NSString *)amrPath {
    NSData *data = [NSData dataWithContentsOfFile:amrPath];
    WEAKSELF;
    XHAPIResultHandler handler = ^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        if (result.isSuccess) {
            weakSelf.playUrlString = JSON.stringValue;
        }else {
            [weakSelf toast:result.message];
        }
    };
    [XHAPI uploadAudioData:data suffix:@".amr" token:[XHUser currentUser].token handler:handler];
}


- (void)downloadRecordFileFromUrlString:(NSString *)urlString toFilePath:(NSString *)filePath {
    WEAKSELF;
    [XHAPI downloadFileFromUrlString:urlString toFilePath:filePath handler:^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        if (result.isSuccess) {
            [weakSelf.manager playAudioFromUrlString:urlString];
        }else {
            [weakSelf toast:result.message];
        }
    }];
}

- (void)failedToPlayFileUrlString:(NSString *)urlString error:(NSError *)error {
    [self toast:error.localizedDescription];
}

@end
