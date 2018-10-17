//
//  UIView+Space.h
//  FHTower
//
//  Created by 菲凡数据科技-iOS开发 on 2018/8/17.
//  Copyright © 2018年 菲凡数据科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Space)


+ (CGFloat)onePixel;                //1像素
+ (CGFloat)pixelAdjustOffset;       //1像素时Y轴调整


+ (CGFloat)statusBarHeight;        
+ (CGFloat)tabBarHeight;
+ (CGFloat)navigationBarHeight;
+ (CGFloat)topSafeAreaHeight;
+ (CGFloat)bottomSafeAreaHeight;
+ (CGFloat)safeAreaHeight;

@end
