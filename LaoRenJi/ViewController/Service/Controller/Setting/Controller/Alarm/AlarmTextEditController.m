//
//  AlarmTextEditController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/21.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "AlarmTextEditController.h"
#import "XHKeyboardObserver.h"
#import "UIButton+Landing.h"
#import "UIViewController+ChildController.h"

@interface AlarmTextEditController ()<UITextFieldDelegate>

@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) XHKeyboardObserver *observer;
@end

@implementation AlarmTextEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    
    self.observer = [[XHKeyboardObserver alloc] init];
    _observer.mainView = self.view;
    _observer.scrollView = self.scrollView;
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
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    UIView *bgView  = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [bgView addGestureRecognizer:tapGestureRecognizer];
    [scrollView addSubview:bgView];
    _bgView = bgView;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.layer.cornerRadius = 4.f;
    contentView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:contentView];
    _contentView = contentView;
    
    CGRect rect = self.view.bounds;
    rect.origin.y = 12.f;
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:20];
    label.text = self.title;
    label.textAlignment = NSTextAlignmentCenter;
    CGSize size = [label sizeThatFits:CGSizeZero];
    rect.size.width -= 24.f;
    rect.size.height = size.height;
    label.frame = rect;
    
    [contentView addSubview:label];
    
    rect.origin.y = CGRectGetMaxY(rect) + 12.f;
    rect.size.height = 44.f;
    rect.size.width -= 24.f;
    rect.origin.x += 12.f;
    UITextField *textField = [[UITextField alloc] initWithFrame:rect];
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:16];
    textField.placeholder = self.placeholder;
    [contentView addSubview:textField];
    textField.text = self.text;
    _textField = textField;
    
    rect.origin.y = CGRectGetMaxY(rect) + 12.f;
    CGFloat buttonW = (CGRectGetWidth(self.view.bounds) - 24.f - 24.f - 12.f) / 2;
    UIButton *button = [UIButton landingButtonWithTitle:@"确定" target:self action:@selector(buttonClick:)];
    [contentView addSubview:button];
    rect.origin.x = 12.f;
    rect.size.width = buttonW;
    rect.size.height = 44.f;
    button.frame = rect;
    
    button = [UIButton landingButtonWithTitle:@"取消" target:self action:@selector(hideSelf)];
    [contentView addSubview:button];
    rect.origin.x = CGRectGetMaxX(rect) + 12.f;
    button.frame = rect;
    
    rect = self.view.frame;
    rect.size.height = CGRectGetMaxY(button.frame) + 12.f;
    rect.size.width = CGRectGetWidth(self.view.bounds) - 24.f;
    rect.origin.x = 12.f;
    rect.origin.y = (CGRectGetHeight(self.view.bounds) - CGRectGetHeight(rect)) / 2;
    contentView.frame = rect;
    contentView.backgroundColor = [UIColor C7];
}


- (void)tapView: (UITapGestureRecognizer *)ges {
    if (_textField.isEditing ) {
        [_textField resignFirstResponder];
    }else {
        [self hideSelf];
    }
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


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _observer.editView = _contentView;
    return true;
}

- (void)buttonClick: (UIButton *)button {
    if (_textField.text.length > 0) {
        if (self.textHandler) {
            self.textHandler(_textField.text);
        }
    }
    [self hideSelf];
}



@end
