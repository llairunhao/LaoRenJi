//
//  UIView+Space.m
//  FHTower
//
//  Created by 菲凡数据科技-iOS开发 on 2018/8/17.
//  Copyright © 2018年 菲凡数据科技. All rights reserved.
//

#import "UIView+Space.h"

@implementation UIView (Space)



+ (CGFloat)onePixel {
    return 1 / [[UIScreen mainScreen] scale];
}

+ (CGFloat)pixelAdjustOffset {
    static CGFloat offset = 0;
    if (offset == 0) {
        CGFloat scale = [[UIScreen mainScreen] scale];
        CGFloat lineWidth = 1 / scale;
        if (((NSInteger)(lineWidth * scale) + 1) % 2 == 0) {
            offset = (1 / scale) / 2;
        }
    }
    return offset;
}


+ (CGFloat)statusBarHeight {
    return ((IS_IPHONEX) ? 44 : 20);
}

+ (CGFloat)tabBarHeight {
    return ((IS_IPHONEX) ? 83 : 49);
}

+ (CGFloat)navigationBarHeight {
    return 44;
}

+ (CGFloat)normalCellHeight {
    return 50.f;
}

+ (CGFloat)largeCellHeight {
    return 60.f;
}


+ (CGFloat)topSafeAreaHeight {
    return [self navigationBarHeight] + [self statusBarHeight];
}

+ (CGFloat)bottomSafeAreaHeight {
    return ((IS_IPHONEX) ? 34 : 0);
}

+ (CGFloat)safeAreaHeight {
    return [self topSafeAreaHeight] + [self bottomSafeAreaHeight];
}

@end
