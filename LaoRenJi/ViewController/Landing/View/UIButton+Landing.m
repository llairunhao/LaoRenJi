//
//  UIButton+Landing.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/14.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "UIButton+Landing.h"

@implementation UIButton (Landing)

+ (UIButton *)landingButtonWithTitle:(NSString *)title
                              target:(nullable id)target
                              action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"RoundedRectangle3"] forState:UIControlStateNormal];
     [button setBackgroundImage:[UIImage imageNamed:@"RoundedRectangle7"] forState:UIControlStateDisabled];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


+ (UIButton *)grayButtonWithTitle:(NSString *)title
                           target:(id)target
                           action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"RoundedRectangle7"] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
