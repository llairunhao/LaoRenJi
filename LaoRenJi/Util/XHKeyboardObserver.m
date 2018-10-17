//
//  XHKeyboardObserver.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/14.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHKeyboardObserver.h"
#import "AppDelegate.h"

@interface XHKeyboardObserver ()

@property (nonatomic, assign) CGRect keyboardRect;

@end


@implementation XHKeyboardObserver

- (instancetype)init {
    self = [super init];
    if (self) {
        _keyboardRect = CGRectZero;
        [self addKeyboardObserver];
    }
    return self;
}

- (void)setEditView:(UIView *)editView {
    _editView = editView;
    [self resetContentOffset];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark- KeyboardObserver
- (void)addKeyboardObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name: UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name: UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow: (NSNotification *)noti {
    NSValue *value = noti.userInfo[UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = value.CGRectValue;
    _keyboardRect = keyboardRect;
    if (_inputBar) {
        CGRect barFrame = _inputBar.frame;
        barFrame.origin.y = CGRectGetMinY(keyboardRect) - CGRectGetHeight(barFrame);
        [UIView animateWithDuration:0.25 animations:^{
            self.inputBar.frame = barFrame;
        }];
    }
    
    [self resetContentOffset];
    
}

- (void)keyboardWillHide: (NSNotification *)noti {
    if (_inputBar) {
        CGRect barFrame = _inputBar.frame;
        barFrame.origin.y = CGRectGetHeight(self.mainView.bounds) - CGRectGetHeight(barFrame) - [UIView bottomSafeAreaHeight];
        [UIView animateWithDuration:0.25 animations:^{
            self.inputBar.frame = barFrame;
        }];
    }
    
    CGFloat maxOffsetY = self.scrollView.contentSize.height - CGRectGetHeight(self.scrollView.frame);
    if (self.scrollView.contentOffset.y > maxOffsetY ) {
        maxOffsetY = MAX(0, maxOffsetY);
        [self.scrollView setContentOffset:CGPointMake(0, maxOffsetY) animated:true];
    }
    _keyboardRect = CGRectZero;
    _editView = nil;
}

- (void)resetContentOffset {
    if (CGRectEqualToRect(_keyboardRect, CGRectZero) || self.editView == nil) {
        return;
    }
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CGRect tableRect = [self.scrollView convertRect:_keyboardRect fromView:appDelegate.window];
    CGFloat offsetY = CGRectGetMaxY(self.editView.frame) - tableRect.origin.y;
    offsetY = self.scrollView.contentOffset.y + offsetY + CGRectGetHeight(_inputBar.frame);
    if (offsetY > 0){
        [self.scrollView setContentOffset:CGPointMake(0, offsetY) animated:true];
    }else if (offsetY < 0) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:true];
    }
}

@end
