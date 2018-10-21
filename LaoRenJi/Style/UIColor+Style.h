//
//  UIColor+Style.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/17.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Style)

+ (UIColor *)EC1;

+ (UIColor *)C1;    //用于重要级文字、标题性文字
+ (UIColor *)C2;    //用于普通级文字、引导词
+ (UIColor *)C3;    //用于辅助、次要的文字信息、按钮
+ (UIColor *)C4;    //用于文字不可点击、未输入文字
+ (UIColor *)C5;    //用于导航栏描边
+ (UIColor *)C6;    //用于页面分割线
+ (UIColor *)C7;    //用于页面背景、标签底色、输入框底色、搜索框底色

@end

NS_ASSUME_NONNULL_END
