//
//  DeviceLiveSelectController.m
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/10/19.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import "DeviceLiveSelectController.h"
#import "DeviceLiveSelectButton.h"
#import "UIViewController+ChildController.h"


@interface DeviceLiveSelectController ()
{
    __weak UIView *_bgView;
    __weak DeviceLiveSelectButton *_videoButton;
    __weak DeviceLiveSelectButton *_audioButton;
    __weak UIView *_line;
    __weak UIButton *_closeButton;
}

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIView *bgView;
@end

@implementation DeviceLiveSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);

    
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1, 1);
        self.contentView.alpha = 1;
        self.bgView.alpha = 0.4;
    }];
}

- (void)setupSubviews {
    UIView *bgView  = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSelf)];
    [bgView addGestureRecognizer:tapGestureRecognizer];
    [self.view addSubview:bgView];
    _bgView = bgView;
    

    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 4.f;
    [self.view addSubview:contentView];
    _contentView = contentView;
    
    DeviceLiveSelectButton *button = [DeviceLiveSelectButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"video_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"video_selected"] forState:UIControlStateHighlighted];
    [button setTitle:@"视频监控" forState:UIControlStateNormal];
    [contentView addSubview:button];
    _videoButton = button;
    
    button = [DeviceLiveSelectButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"audio_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"audio_selected"] forState:UIControlStateHighlighted];
    [button setTitle:@"语音监控" forState:UIControlStateNormal];
    [contentView addSubview:button];
    _audioButton = button;
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [contentView addSubview:button1];
    [button1 addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
    _closeButton = button1;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    [contentView addSubview:line];
    
    CGSize size3 = [_closeButton sizeThatFits:CGSizeZero];
    CGSize size2 = [_audioButton sizeThatFits:CGSizeZero];
    CGSize size1 = [_videoButton sizeThatFits:CGSizeZero];
    
    CGFloat buttonH = MAX(size2.height, size1.height);
    CGFloat buttonW = MAX(size2.width, size1.width);
    CGSize buttonSize = CGSizeMake(buttonW, buttonH);
    
    CGRect rect = self.view.bounds;
    rect.origin.x = 24.f;
    rect.size.width = CGRectGetWidth(self.view.bounds) - 48.f;
    rect.size.height = buttonH + 24.f + 12.f + size3.height + 12.f;
    rect.origin.y = (CGRectGetHeight(self.view.bounds) - CGRectGetHeight(rect)) / 2;
    _contentView.frame = rect;
    
    CGFloat padding = (CGRectGetWidth(rect) - buttonW * 2) / 4;
    rect.origin.x = padding;
    rect.origin.y = (CGRectGetHeight(_contentView.frame) - buttonH ) / 2;
    rect.size = buttonSize;
    _videoButton.frame = rect;
    
    rect.origin.x = CGRectGetMaxX(_videoButton.frame) + padding * 2;
    rect.origin.y = (CGRectGetHeight(_contentView.frame) - buttonH) / 2;
    rect.size = buttonSize;
    _audioButton.frame = rect;
  
    rect.origin.x = CGRectGetWidth(_contentView.frame) - size3.width - 24.f;
    rect.origin.y = 12.f;
    rect.size = size3;
    _closeButton.frame = rect;
    
    rect.origin.x = CGRectGetMaxX(_videoButton.frame) + padding;
    rect.origin.y = CGRectGetMinY(_videoButton.frame);
    rect.size.height = buttonH;
    rect.size.width = [UIView onePixel];
    line.frame = rect;
    
    contentView.alpha = 0;
    
}


- (void)hideSelf {
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.contentView.alpha = 0;
        self.bgView.alpha = 0;
    }completion:^(BOOL finished) {
        if (finished) {
            [self removeSelf];
        }
    }];
}

@end
