//
//  XHNavigationSearchBar.m
//  FHTower
//
//  Created by 菲凡数据科技-iOS开发 on 2018/1/2.
//  Copyright © 2018年 菲凡数据科技. All rights reserved.
//

#import "XHNavigationSearchBar.h"
#import "XHSearchTextField.h"


@interface XHNavigationSearchBar () <UITextFieldDelegate>
{
    __weak UIButton *_cancelButton;
}
@property (nonatomic, weak) XHSearchTextField *searchTextField;
@property (nonatomic, assign) BOOL animating;

@end

@implementation XHNavigationSearchBar


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backButtonHidden = true;
        
        XHSearchTextField *searchTextField = [[XHSearchTextField alloc] init];
        [self addSubview:searchTextField];
        self.searchTextField = searchTextField;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addRigthItem:button];
        _cancelButton = button;
        searchTextField.textField.delegate = self;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditingNoti:) name:UITextFieldTextDidBeginEditingNotification object:searchTextField.textField];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = 30.f;
    CGFloat x = self.backButtonHidden ? 12.f : CGRectGetMaxX(self.backButton.frame);
    CGFloat y = (CGRectGetHeight(self.bounds) - height) / 2;
    
    CGFloat width;
    if (!self.cancelButtonHidden) {
        width = CGRectGetMinX(self.cancelButton.frame) - x - 14;
    }else {
        width = CGRectGetWidth(self.bounds) - 12.f * 2;
    }
    self.searchTextField.frame = CGRectMake(x, y, width, height);
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (UIButton *)cancelButton {
    return _cancelButton;
}

- (UITextField *)textField {
    return self.searchTextField.textField;
}

- (void)setText:(NSString *)text {
    self.searchTextField.text = text;
}

- (NSString *)text {
    return self.searchTextField.text;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.searchTextField.placeholder = placeholder;
}

- (NSString *)placeholder {
    return self.searchTextField.placeholder;
}

- (BOOL)backButtonHidden {
    return self.backButton.hidden;
}

- (void)setBackButtonHidden:(BOOL)backButtonHidden {
    self.backButton.hidden = backButtonHidden;
}

- (BOOL)cancelButtonHidden {
    return self.cancelButton.hidden;
}

- (void)setCancelButtonHidden:(BOOL)cancelButtonHidden {
    self.cancelButton.hidden = cancelButtonHidden;
}

- (void)cancelButtonClick: (UIButton *)btn {
    [self.textField resignFirstResponder];
    self.text = nil;
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(searchDidCancel)]) {
            [self.delegate searchDidCancel];
        }
        
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(shouldClearText)]) {
            return [self.delegate shouldClearText];
        }
    }
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL isEmpty = self.text.length == 0;
    if (!isEmpty) {
        [textField resignFirstResponder];
        if (self.delegate) {
            [self.delegate searchText:textField.text];
        }
    }
    return !isEmpty;
}

- (void)textFieldDidBeginEditingNoti:(NSNotification *)noti {
    if ([self.delegate respondsToSelector:@selector(searchDidBegin)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate searchDidBegin];
        });
    }
}

- (CGRect)editRect {
    return self.searchTextField.frame;
}

- (void)hideKeyboard {
    [self.textField resignFirstResponder];
}


@end
