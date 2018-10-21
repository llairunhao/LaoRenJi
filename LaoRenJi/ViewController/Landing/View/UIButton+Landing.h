//
//  UIButton+Landing.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/14.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Landing)

+ (UIButton *)landingButtonWithTitle:(NSString *)title
                              target:(nullable id)target
                              action:(SEL)action;

+ (UIButton *)grayButtonWithTitle:(NSString *)title
                           target:(nullable id)target
                           action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
