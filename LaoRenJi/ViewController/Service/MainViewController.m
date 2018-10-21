//
//  MainViewController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/17.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "MainViewController.h"
#import "LeftViewController.h"
#import "UIViewController+ChildController.h"
#import "DeviceLiveSelectController.h"

#import "XHAPI+API.h"
#import "XHUser.h"
#import "XHDevice.h"
#import "DBManager.h"

@interface MainViewController ()

@property (nonatomic, weak) UIButton *groupButton;
@property (nonatomic, weak) LeftViewController *leftViewController;
@property (nonatomic, strong) NSArray <UIButton *> *buttons;
@property (nonatomic, assign) NSTimeInterval lastUpdateTime;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor EC1];
    [self setupSubviews];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:XHDeviceDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshDataIfNeed];
}



- (void)setupSubviews {
    UIButton *groupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [groupButton setImage:[UIImage imageNamed:@"Group"] forState:UIControlStateNormal];
    [groupButton setTitle:@"31231（离线）" forState:UIControlStateNormal];
    groupButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    groupButton.titleEdgeInsets = UIEdgeInsetsMake(0, 12.f, 0, 0);
    [groupButton addTarget:self action:@selector(groupButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:groupButton];
    _groupButton = groupButton;
    
    NSArray *titles = @[@"呼叫", @"监控", @"轨迹", @"留言", @"设置", @"历史"];
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:titles.count];
    for (NSInteger i = 0; i < titles.count; i++) {
        NSString *text = titles[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        [button setTitleColor:[UIColor lightGrayColor] forState: UIControlStateNormal];
        [button setTitle:text forState:UIControlStateNormal];
        button.titleEdgeInsets = UIEdgeInsetsMake(75, 0, 0, 0);
        NSString *imageName = [NSString stringWithFormat:@"%@选中", text];
        [button setBackgroundImage:[UIImage imageNamed:text] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
        [self.view addSubview:button];
        [buttons addObject:button];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    _buttons = [buttons copy];
}

- (void)viewDidLayoutSubviews {
    if (_buttons.count == 0) {
        return;
    }
    
    CGSize size = [_buttons[0] sizeThatFits:CGSizeZero];
    CGFloat hPadding = (CGRectGetWidth(self.view.bounds) - size.width * 2) / 3;
    CGFloat vPadding = (CGRectGetHeight(self.view.bounds) - size.height * 3 - [UIView topSafeAreaHeight]) / 4;
    
    CGFloat leftOriginX = hPadding * 2 + size.width;
    
    CGRect rect = self.view.bounds;
    rect.origin.y = [UIView topSafeAreaHeight] + vPadding;
    rect.origin.x = hPadding;
    rect.size = size;
    _buttons[0].frame = rect;
    
    rect.origin.x = leftOriginX;
    _buttons[1].frame = rect;
    
    rect.origin.x = hPadding;
    rect.origin.y = CGRectGetMaxY(_buttons[0].frame) + vPadding;
    _buttons[2].frame = rect;
    
    rect.origin.x = leftOriginX;
    _buttons[3].frame = rect;
    
    rect.origin.x = hPadding;
    rect.origin.y = CGRectGetMaxY(_buttons[2].frame) + vPadding;
    _buttons[4].frame = rect;
    
    rect.origin.x = leftOriginX;
    _buttons[5].frame = rect;
    
    
    CGFloat width = CGRectGetWidth(self.view.bounds) - hPadding * 2;
    _groupButton.frame = CGRectMake(hPadding, [UIView statusBarHeight], width, [UIView navigationBarHeight]);
    
}

- (void)buttonClick: (UIButton *)button {

    NSArray *classes = @[@"DevicePhoneViewController",
                         @"DeviceLiveSelectController",
                         @"LocusViewController",
                         @"",
                         @"DeviceSettingViewController",
                         @""];
    
    UIViewController *controller = [[NSClassFromString(classes[button.tag]) alloc] init];
    if (button.tag == 1) {
        [self addController:controller];
    }else if (controller) {
        [self.navigationController pushViewController:controller animated:true];
    }
    
}

- (void)groupButtonClick: (UIButton *)button {

    if (!_leftViewController) {
        LeftViewController *controller = [[LeftViewController alloc] init];
        [self addController:controller];
        _leftViewController = controller;
    }
    [_leftViewController showAnimation];
}

- (void)refreshDataIfNeed {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (now - self.lastUpdateTime > 60) {
        [self refreshData];
    }
}

- (void)refreshData {
    NSString *token = [XHUser currentUser].token;
    if (token.length == 0) {
        return;
    }

    
    
    WEAKSELF;
    [XHAPI getCurrentDeviceStateByToken:token handler:^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        if (result.isSuccess) {
            [XHUser currentUser].currentDevice.online = JSON.boolValue;
            XHDevice *device = [XHUser currentUser].currentDevice;
            NSString *text = [NSString stringWithFormat:@"%@（%@）", device.name, device.online ? @"在线": @"离线"];
            [weakSelf.groupButton setTitle:text forState: UIControlStateNormal];
            self.lastUpdateTime = [[NSDate date] timeIntervalSince1970];
        }else {
            [weakSelf toast:result.message];
        }
    }];

   
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
