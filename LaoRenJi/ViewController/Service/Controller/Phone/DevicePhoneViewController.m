//
//  DevicePhoneViewController.m
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/10/19.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import "DevicePhoneViewController.h"
#import "ServiceTextFieldContainer.h"
#import "UIButton+Landing.h"
#import "NSString+Valid.h"
#import "DBManager.h"

@interface DevicePhoneViewController ()
{
    __weak UITextField *_textField;
}
@end

@implementation DevicePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"终端号码";
    [self setupSubviews];
}

- (void)setupSubviews {
    CGRect rect = self.view.bounds;
    rect.origin.y = [UIView topSafeAreaHeight];
    rect.size.height = 60;
    ServiceTextFieldContainer *containter = [[ServiceTextFieldContainer alloc] initWithFrame:rect];
    containter.textLabel.text = @"终端电话号码：";
    _textField = containter.textField;
    containter.textField.text = [[DBManager sharedInstance] getCurrentDevicePhone];
    containter.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:containter];
    
    UIButton *button = [UIButton landingButtonWithTitle:@"保存" target:self action:@selector(buttonClick:)];
    CGSize size = [button sizeThatFits:CGSizeZero];
     size.width = MIN(size.width, CGRectGetWidth(self.view.bounds) - 24.f);
    rect.origin.x = (CGRectGetWidth(self.view.bounds) - size.width ) / 2;
    rect.origin.y = CGRectGetMaxY(containter.frame) + 24.f;
    rect.size = size;
    button.frame = rect;
    [self.view addSubview:button];
    
//    button = [UIButton landingButtonWithTitle:@"呼叫" target:self action:@selector(buttonClick:)];
//    button.tag = 1;
//    rect.origin.y = CGRectGetMaxY(rect) + 12.f;
//    button.frame = rect;
//    [self.view addSubview:button];
}

- (void)buttonClick: (UIButton *)button {
    
    if (![_textField.text isNumberOnly] || _textField.text.length == 0) {
        [self toast:@"请输入正确的手机号码"];
    }else {
        if (button.tag == 0) {
            [[DBManager sharedInstance] setCurrentDevicePhone:_textField.text];
            [self.navigationController popViewControllerAnimated:true];
        }else {
            NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"tel:%@", _textField.text]];
            [[UIApplication sharedApplication] openURL:url];
        }

    }
}

@end
