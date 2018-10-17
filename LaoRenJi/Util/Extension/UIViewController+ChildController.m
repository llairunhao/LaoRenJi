//
//  UIViewController+ChildController.m
//  FHTower
//
//  Created by 菲凡数据科技-iOS开发 on 2018/9/28.
//  Copyright © 2018年 菲凡数据科技. All rights reserved.
//

#import "UIViewController+ChildController.h"

@implementation UIViewController (ChildController)

- (void)addController:(__kindof UIViewController *)controller {
    [self addController:controller originY:0];
}

- (void)addController:(__kindof UIViewController *)controller originY:(CGFloat)y {
    CGRect rect = self.view.bounds;
    rect.origin.y = y;
    rect.size.height -= (y + [UIView bottomSafeAreaHeight]);
    [self addController:controller frame:rect];
}

- (void)addController:(__kindof UIViewController *)controller frame:(CGRect)frame {
    [controller willMoveToParentViewController:self];
    [self addChildViewController:controller];
    controller.view.frame = frame;
    [self.view addSubview:controller.view];
    [controller didMoveToParentViewController:self];
}

- (void)removeSelf {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [self didMoveToParentViewController:nil];
}

@end
