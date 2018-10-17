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

#import "XHKeyboardObserver.h"


@interface RegisterViewController ()<UITextFieldDelegate>
{
    __weak UIScrollView *_scrollView;
    XHKeyboardObserver *_observer;
    NSArray <UITextField *> *_textFields;
}
@end

@implementation RegisterViewController

- (void)actionButtonClick: (UIButton *)button {
    
}

#pragma mark-
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
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
    [_scrollView addSubview:actionButton];
    
    UIButton *validButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [validButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [validButton setTitleColor:[UIColor EC1] forState:UIControlStateNormal];
    validButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    NSArray *placeholders = self.placeholders;
    NSMutableArray *textFields = [NSMutableArray arrayWithCapacity:5];
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
        if (i == placeholders.count - 1) {
            CGSize size = [validButton sizeThatFits:CGSizeZero];
            CGRect rect = textField.bounds;
            rect.origin.x = CGRectGetWidth(rect) - size.width - 8.f;
            rect.size.width = size.width;
            validButton.frame = rect;
            [textField addSubview:validButton];
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
