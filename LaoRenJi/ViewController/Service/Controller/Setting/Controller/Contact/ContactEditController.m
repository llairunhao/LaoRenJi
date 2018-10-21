//
//  ContactEditController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/20.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "ContactEditController.h"
#import "ServiceTextFieldContainer.h"
#import "XHKeyboardObserver.h"
#import "UIViewController+ChildController.h"
#import "UIButton+Landing.h"
#import "NSString+Valid.h"
#import "XHAPI+API.h"
#import "XHUser.h"
#import "XHContact.h"

@interface ContactEditController ()<UITextFieldDelegate>

@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UITextField *nameTF;
@property (nonatomic, weak) UITextField *phoneTF;
@property (nonatomic, weak) UIButton *autoButton;
@property (nonatomic, weak) UIButton *emergencyButton;


@property (nonatomic, strong) XHKeyboardObserver *observer;
@end

@implementation ContactEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    
    self.observer = [[XHKeyboardObserver alloc] init];
    _observer.mainView = self.view;
    _observer.scrollView = self.scrollView;
}

- (XHContact *)contact {
    if (!_contact) {
        _contact = [[XHContact alloc] init];
        _contact.isUrgent = true;
        _contact.isAutoAnswer = true;
    }
    return _contact;
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
    
    UIFont *font = [UIFont systemFontOfSize:16];
    
    CGRect rect = self.view.bounds;
    rect.origin.y = 12.f;
    rect.size.width -= 24.f;
    rect.size.height = 44.f;
    ServiceTextFieldContainer *container = [[ServiceTextFieldContainer alloc] initWithFrame:rect];
    _nameTF = container.textField;
    container.textField.delegate = self;
    container.textField.text = self.contact.name;
    container.textField.placeholder = @"请输入姓名";
    container.font = font;
    container.lineHidden = true;
    container.textLabel.text = @"姓名：";
    [contentView addSubview:container];
    
    rect.origin.y = CGRectGetMaxY(rect);
    container = [[ServiceTextFieldContainer alloc] initWithFrame:rect];
    container.font = font;
    container.lineHidden = true;
    _phoneTF = container.textField;
    container.textField.delegate = self;
    container.textField.text = self.contact.phone;
    container.textLabel.text = @"电话：";
    container.textField.placeholder = @"请输入号码";
    [contentView addSubview:container];
    
    rect.origin.y = CGRectGetMaxY(rect);
    rect.origin.x = 12.f;
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = @"权限：自动接听";
    label.font = font;
    label.textColor = [UIColor C1];
    [contentView addSubview:label];

    rect = self.view.bounds;
    rect.origin.x = CGRectGetWidth(rect) / 2;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
     [contentView addSubview:button];
    [button setImage:[UIImage imageNamed:@"SWITCH"] forState:UIControlStateNormal];
     [button setImage:[UIImage imageNamed:@"SWITCHON"] forState:UIControlStateSelected];
    [contentView addSubview:button];
    CGSize size = [button sizeThatFits:CGSizeZero];
    rect.size = size;
    rect.origin.y = (CGRectGetHeight(label.frame) - size.height ) / 2 + CGRectGetMinY(label.frame);
    button.frame = rect;
    [button addTarget:self action:@selector(switchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.selected = self.contact.isAutoAnswer;
    _autoButton = button;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView addSubview:button];
    button.titleLabel.font = font;
    [button setTitle:@"紧急呼叫号码" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"icon_tickbox_nor"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"icon_tickbox_sel"] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor C1] forState:UIControlStateNormal];
    rect.origin.y = CGRectGetMaxY(label.frame);
    rect.origin.x = 12.f;
    size = [button sizeThatFits:CGSizeZero];
    size.height = CGRectGetHeight(container.frame);
    rect.size = size;
    button.frame = rect;
    [button addTarget:self action:@selector(switchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.selected = self.contact.isUrgent;
    _emergencyButton = button;
    
    rect.origin.y = CGRectGetMaxY(rect);
    CGFloat buttonW = (CGRectGetWidth(self.view.bounds) - 24.f - 24.f - 12.f) / 2;
    button = [UIButton landingButtonWithTitle:@"确定" target:self action:@selector(buttonClick:)];
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
}


- (void)tapView: (UITapGestureRecognizer *)ges {
    if (_nameTF.isEditing || _phoneTF.isEditing) {
        [_nameTF resignFirstResponder];
        [_phoneTF resignFirstResponder];
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

- (void)switchButtonClick: (UIButton *)button {
    button.selected = !button.selected;
    
}



- (void)buttonClick: (UIButton *)button {
    if (_nameTF.text.length == 0) {
        [self toast:@"请输入联系人姓名"];
        return;
    }
    if (![_phoneTF.text isNumberOnly] || _phoneTF.text.length == 0) {
        [self toast:@"请输入正确的电话"];
        return;
    }
    [_nameTF resignFirstResponder];
    [_phoneTF resignFirstResponder];
    
    WEAKSELF;
    XHAPIResultHandler handler = ^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        [weakSelf hideAllHUD];
        if (result.isSuccess) {
            weakSelf.contact.name = weakSelf.nameTF.text;
            weakSelf.contact.phone = weakSelf.phoneTF.text;
            weakSelf.contact.isUrgent = weakSelf.emergencyButton.selected;
            weakSelf.contact.isAutoAnswer = weakSelf.autoButton.selected;
            if (weakSelf.contact.contactId == 0) {
                weakSelf.contact.contactId = [JSON unsignedIntegerValue];
                weakSelf.contactHandler(weakSelf.contact);
            }else {
                weakSelf.reloadHandler();
            }
            [weakSelf hideSelf];
        }else {
            [weakSelf toast:result.message];
        }
    };
    [self showLoadingHUD];
    [XHAPI saveContactByToken:[XHUser currentUser].token
                         name:_nameTF.text
                        phone:_phoneTF.text
                     isUrgent:_emergencyButton.selected
                  urgentLevel:1
                 isAutoAnswer:_autoButton.selected
                      handler:handler];
}

@end
