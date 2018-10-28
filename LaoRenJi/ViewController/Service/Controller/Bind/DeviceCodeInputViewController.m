//
//  DeviceCodeInputViewController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/26.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "DeviceCodeInputViewController.h"
#import "ServiceTextFieldContainer.h"
#import "UIButton+Landing.h"


@interface DeviceCodeInputViewController ()
{
    __weak UITextField *_codeTF;
}
@end

@implementation DeviceCodeInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设备绑定";
    [self setupSubviews];
}

- (void)setupSubviews {
    CGRect rect = self.view.bounds;
    rect.origin.y = [UIView topSafeAreaHeight];
    rect.size.height = 60;
    ServiceTextFieldContainer *containter = [[ServiceTextFieldContainer alloc] initWithFrame:rect];
    containter.textLabel.text = @"设备编码：";
    CGSize size = [containter.textLabel sizeThatFits:CGSizeZero];
    CGFloat labelWidth = size.width + 8;
    containter.labelWidth = labelWidth;
    containter.textField.placeholder = @"请输入设备编码";
    _codeTF = containter.textField;
    [self.view addSubview:containter];
    
    
    UIButton *button = [UIButton landingButtonWithTitle:@"保存" target:self action:@selector(buttonClick:)];
    size = [button sizeThatFits:CGSizeZero];
    size.width = MIN(size.width, CGRectGetWidth(self.view.bounds) - 24.f);
    rect.origin.x = (CGRectGetWidth(self.view.bounds) - size.width ) / 2;
    rect.origin.y = CGRectGetMaxY(containter.frame) + 24.f;
    rect.size = size;
    button.frame = rect;
    [self.view addSubview:button];

}



- (void)buttonClick: (UIButton *)button {
    [self.delegate bindDeviceCode:_codeTF.text controller:self];
}

@end
