//
//  XHSafeNavigationBar.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/14.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHSafeNavigationBar.h"

@implementation XHSafeNavigationBar


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(70, 174, 173, 1);
    }
    return self;
}

- (void)layoutSubviews {
    for (UIView *view in self.subviews) {
        CGRect rect = self.bounds;
        rect.origin.y = [UIView statusBarHeight];
        rect.size.height = [UIView navigationBarHeight];
        view.frame = rect;
    }
    
}

@end
