//
//  RegisterViewController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/14.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "RegisterViewController.h"
#import "UITextField+Landing.h"
#import "UIButton+Landing.h"
#import "NSString+Valid.h"
#import "XHAPI+API.h"
#import "XHKeyboardObserver.h"


@interface RegisterViewController ()<UITextFieldDelegate>
{
    __weak UIScrollView *_scrollView;
    XHKeyboardObserver *_observer;
    NSArray <UITextField *> *_textFields;
    __weak UIButton *_codeButton;
    dispatch_source_t _timer;
    NSInteger _count;
}
@end

@implementation RegisterViewController

- (NSArray<UITextField *> *)textFields {
    return _textFields;
}

- (BOOL)codeButtonHidden {
    return false;
}

- (void)actionButtonClick: (UIButton *)button {
    for (NSInteger i = 0; i < _textFields.count; i++) {
        if (_textFields[i].text.length == 0) {
            [self toast:@"请输入正确的格式"];
            return;
        }
    }
    if ([_textFields[1].text isEqualToString:_textFields[2].text]) {
        [self toast:@"两次密码不一致"];
        return;
    }
    WEAKSELF;
    XHAPIResultHandler handler = ^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        [weakSelf hideAllHUD];
        if (result.isSuccess) {
            [weakSelf toast:@"注册成功，返回登陆页面"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:true];
            });
        }else {
            [weakSelf toast:result.message];
        }
    };
    [self showLoadingHUD];
    [XHAPI registerWithAccount:_textFields[0].text
                      password:_textFields[1].text
                      nickname:_textFields[2].text
                          code:_textFields[4].text
                       handler:handler];
}

#pragma mark-
- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.title) {
        self.title = @"注册";
    }
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


- (void)dealloc
{
    [self stopTimer];
}

#pragma mark-
- (NSArray<NSString *> *)placeholders {
    return @[@"手机号码", @"昵称", @"密码", @"确认密码", @"短信验证码"];
}

- (BOOL)secureTextEntryAtIndex:(NSInteger)index {
    return index == 2 || index == 3;
}

#pragma mark-
- (void)setupSubviews {
    
    CGRect bounds = self.view.bounds;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame: bounds];
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    UIButton *actionButton = [UIButton landingButtonWithTitle:self.title target:self action:@selector(actionButtonClick:)];
    CGSize size = [actionButton sizeThatFits:CGSizeZero];
    size.width = MIN(size.width, CGRectGetWidth(self.view.bounds) - 24.f);
    [_scrollView addSubview:actionButton];
    
    UIButton *codeButton;
    if (![self codeButtonHidden]) {
        codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [codeButton setTitleColor:[UIColor EC1] forState:UIControlStateNormal];
        [codeButton setTitleColor:[UIColor C3] forState:UIControlStateDisabled];
        codeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    
    
    NSArray *placeholders = self.placeholders;
    NSMutableArray *textFields = [NSMutableArray arrayWithCapacity:self.placeholders.count];
    CGRect rect = self.view.bounds;
    rect.size = size;
    rect.origin.x = (CGRectGetWidth(bounds) - size.width) / 2.f;
    rect.origin.y = [UIView topSafeAreaHeight] + 20.f;
    for (NSInteger i = 0; i < placeholders.count; i++) {
        UITextField *textField = [self textFieldWithPlaceholder:placeholders[i]];
        textField.tag = i;
        textField.returnKeyType = UIReturnKeyDone;
        textField.secureTextEntry = [self secureTextEntryAtIndex:i];
        if (i > 0) {
            rect.origin.y = CGRectGetMaxY(rect) + 20.f;
        }
        textField.frame = rect;
        
        if (i == placeholders.count - 1 && codeButton) {
            CGSize size = [codeButton sizeThatFits:CGSizeZero];
            CGRect rect = textField.bounds;
            rect.origin.x = CGRectGetWidth(rect) - size.width - 8.f;
            rect.size.width = size.width;
            codeButton.frame = rect;
            [textField addSubview:codeButton];
            [codeButton addTarget:self action:@selector(codeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            _codeButton = codeButton;
        }
        textField.delegate = self;
        [textFields addObject:textField];
    }
    rect.origin.y = CGRectGetMaxY(rect) + 20.f;
    actionButton.frame = rect;
    _textFields = [textFields copy];
    
}

- (UITextField *)textFieldWithPlaceholder: (NSString *)placeholder {
    UITextField *textField = [UITextField landingTextFieldWithPlaceholder:placeholder];
    [_scrollView addSubview:textField];
    return textField;
}


- (void)codeButtonClick: (UIButton *)button {
    if (![_textFields[0].text isPhoneNumber]) {
        [self toast:@"请输入正确的手机号码"];
        return;
    }
    [self showLoadingHUD];
    WEAKSELF;
    [XHAPI getVerificationCodeByPhone:_textFields[0].text
                              handler:^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
                                  [weakSelf hideAllHUD];
                                  if (result.isSuccess) {
                                      [weakSelf startTimer];
                                  }else {
                                      [weakSelf toast:result.message];
                                  }
                              }];
}

- (void)startTimer {
    _count = 60;
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    WEAKSELF;
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf countDown];
        });
    });
    dispatch_resume(_timer);
    _codeButton.enabled = false;
}

- (void)stopTimer {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

- (void)countDown {
    _count -= 1;
    if (_count == 0) {
        _codeButton.enabled = true;
        [self stopTimer];
    }else {
        [_codeButton setTitle:[NSString stringWithFormat:@"%@s后重发", @(_count)] forState:UIControlStateDisabled];
    }
}


#pragma mark-
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _observer.editView = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _textFields.lastObject) {
        [textField resignFirstResponder];
    }else {
        [_textFields[textField.tag + 1] becomeFirstResponder];
    }
    return true;
}

#pragma mark-
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
