//
//  LoginViewController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/14.
//  Copyright © 2018年 西汉科技. All rights reserved.
//


#import "LoginViewController.h"
#import "UITextField+Landing.h"
#import "UIButton+Landing.h"

#import "XHKeyboardObserver.h"

#import "RegisterViewController.h"
#import "ResetPassworViewController.h"

#import "XHAPI+API.h"
#import "XHUser.h"
#import "XHDevice.h"


@interface LoginViewController ()<UITextFieldDelegate>
{
    __weak UIScrollView *_scrollView;
    __weak UITextField *_accountTF;
    __weak UITextField *_passwordTF;
    XHKeyboardObserver *_observer;
}
@end

@implementation LoginViewController

- (void)loginWithAccount: (NSString *)account password: (NSString *)password {
   
    [XHUser currentUser].account = account;
    [XHUser currentUser].password = password;
    [self showLoadingHUD: @"登录中..."];
    WEAKSELF;
    [XHAPI loginWithAccount:account password:password xgToken:[XHUser currentUser].xgToken handler:^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        if (result.isSuccess) {
            [[XHUser currentUser] setupWithJSON:JSON];
            [XHUser currentUser].account = account;
            [XHUser currentUser].password = password;
            [weakSelf listOfDevices];
        }else {
            [weakSelf hideAllHUD];
            [weakSelf toast:result.message];
        }
    }];
}

- (void)listOfDevices {
    [self showLoadingHUD: @"获取设备列表..."];
    WEAKSELF;
    [XHAPI listOfDevicesByToken:[XHUser currentUser].token handler:^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        [weakSelf hideAllHUD];
        if (result.isSuccess) {
            NSArray *array1 = JSON.JSONArrayValue;
            NSMutableArray *array2 = [NSMutableArray arrayWithCapacity:array1.count];
            for (XHJSON *json in array1) {
                XHDevice *device = [[XHDevice alloc] initWithJSON:json];
                [array2 addObject:device];
            }
            [XHUser currentUser].devices = [array2 copy];
            [[NSNotificationCenter defaultCenter] postNotificationName:XHUserDidLoginNotification object:nil];
            [weakSelf dismissViewControllerAnimated:true completion:nil];
        }else {
            [weakSelf toast:result.message];
        }
    }];
}


#pragma mark-
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupSubviews];
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _observer = [[XHKeyboardObserver alloc] init];
    _observer.mainView = self.view;
    _observer.scrollView = _scrollView;
    
}

#pragma mark-
- (void)setupSubviews {
    
    CGRect bounds = self.view.bounds;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame: bounds];
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:bounds];
    bgView.image = [UIImage imageNamed:@"sidebar"];
    [scrollView addSubview:bgView];
    
    CGRect rect = bounds;
    rect.origin.y = 698.f / 1920.f * CGRectGetHeight(bounds) + 12.f;
    UILabel *label = [[UILabel alloc] init];
    label.text = @"登陆";
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:label];
    CGSize size = [label sizeThatFits:CGSizeZero];
    rect.size.height = size.height;
    label.frame = rect;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rectangle1"]];
    size = [imageView sizeThatFits:CGSizeZero];
    rect.size = size;
    rect.origin.x = (CGRectGetWidth(bounds) - size.width ) / 2;
    rect.origin.y = CGRectGetMaxY(label.frame) + 12.f;
    imageView.frame = rect;
    [scrollView addSubview:imageView];
    
//    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LOGO"]];
//    size = [imageView sizeThatFits:CGSizeZero];
//    rect.size = size;
//    rect.origin.x = (CGRectGetWidth(bounds) - size.width ) / 2;
//    rect.origin.y = 223.f / 1920.f * CGRectGetHeight(bounds);
//    imageView.frame = rect;
//    [self.view addSubview:imageView];
    
    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:14.f],
                           NSForegroundColorAttributeName: RGBA(75, 174, 174, 1),
                           NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                           NSUnderlineColorAttributeName: RGBA(75, 174, 174, 0.7)};
    
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:@"忘记密码？" attributes:dict];
    forgetButton.tag = 2;
    [forgetButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [forgetButton setAttributedTitle:att forState:UIControlStateNormal];
    [scrollView addSubview:forgetButton];
    
    UIButton *button = [self buttonWithTitle:@"登陆"];
    
    CGSize size1 = [forgetButton sizeThatFits:CGSizeZero];
    CGSize size2 = [button sizeThatFits:CGSizeZero];
    size2.width = MIN(size2.width, CGRectGetWidth(self.view.bounds) - 24.f);
    CGFloat originY = 904.f / 1920.f * CGRectGetHeight(bounds) + 24.f;
    CGFloat remainHeight = CGRectGetHeight(bounds) - originY - [UIView bottomSafeAreaHeight];
    CGFloat padding = (remainHeight - (size2.height) * 4 - size1.height) / 5.f;

    rect.origin.x = (CGRectGetWidth(bounds) - size2.width ) / 2;
    rect.size = size2;
    
 
 
    UITextField *textField = [self textFieldWithPlaceholder:@"请输入账号"];
    textField.text = [XHUser currentUser].account;// @"17665368506";
    _accountTF = textField;
    rect.origin.y = originY;
    textField.frame = rect;
    
    textField = [self textFieldWithPlaceholder:@"请输入密码"];
    textField.secureTextEntry = true;
    textField.text = [XHUser currentUser].password;
    _passwordTF = textField;
    rect.origin.y = CGRectGetMaxY(rect) + padding;
    textField.frame = rect;
    
    rect.origin.y = CGRectGetMaxY(rect) + padding;
    rect.size = size1;
    rect.origin.x = CGRectGetMaxX(textField.frame) - size1.width;
    forgetButton.frame = rect;
    
    rect.origin.y = CGRectGetMaxY(rect) + padding;
    rect.origin.x = (CGRectGetWidth(bounds) - size2.width ) / 2;
    rect.size = size2;
    button.frame = rect;

    rect.origin.y = CGRectGetMaxY(rect) + padding;
    button = [self buttonWithTitle:@"注册"];
    button.tag = 1;
    button.frame = rect;
}


- (UIButton *)buttonWithTitle: (NSString *)title {
    UIButton *button = [UIButton landingButtonWithTitle:title target:self action:@selector(buttonClick:)];
    [_scrollView addSubview:button];
    return button;
}

- (UITextField *)textFieldWithPlaceholder: (NSString *)placeholder {
    UITextField *textField = [UITextField landingTextFieldWithPlaceholder:placeholder];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    [_scrollView addSubview:textField];
    return textField;
}


#pragma mark-
- (void)buttonClick: (UIButton *)button {
    if (button.tag == 1) {
        RegisterViewController *controller = [[RegisterViewController alloc] init];
        [self.navigationController pushViewController:controller animated:true];
    }else if (button.tag == 2) {
        ResetPassworViewController *controller = [[ResetPassworViewController alloc] init];
        [self.navigationController pushViewController:controller animated:true];
    }else {
        [self loginWithAccount:_accountTF.text password:_passwordTF.text];
    }
}

#pragma mark-
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _observer.editView = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _accountTF) {
        [_passwordTF becomeFirstResponder];
    }else {
        [textField resignFirstResponder];
    }
    return true;
}

#pragma mark-
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
