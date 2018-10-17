//
//  UITextField+Landing.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/14.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "UITextField+Landing.h"

@implementation UITextField (Landing)

+ (UITextField *)landingTextFieldWithPlaceholder: (NSString *)placeholder  {
    UITextField *textField = [[UITextField alloc] init];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.backgroundColor = RGBA(245, 247, 250, 1);
    textField.placeholder = placeholder;
    return textField;
}

@end
