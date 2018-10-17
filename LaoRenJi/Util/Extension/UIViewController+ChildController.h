//
//  UIViewController+ChildController.h
//  FHTower
//
//  Created by 菲凡数据科技-iOS开发 on 2018/9/28.
//  Copyright © 2018年 菲凡数据科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ChildController)

- (void)addController:(__kindof UIViewController *)controller;

- (void)addController:(__kindof UIViewController *)controller originY: (CGFloat)y;

- (void)addController:(__kindof UIViewController *)controller frame: (CGRect)frame;

- (void)removeSelf;

@end

NS_ASSUME_NONNULL_END
