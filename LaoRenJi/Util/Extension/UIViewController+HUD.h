//
//  UIViewController+HUD.h
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/10/19.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AlertActionHandler)(UIAlertAction * _Nonnull action);

@interface UIViewController (HUD)

- (void)showLoadingHUD: (NSString *)title;
- (void)showLoadingHUD;
- (void)hideAllHUD;

- (void)toast: (NSString *)text;

- (void)destructiveAlertWithTitle: (nullable NSString *)title
                          message: (nullable NSString *)message
                   confirmHandler: (nullable AlertActionHandler) confirmHandler;

@end

NS_ASSUME_NONNULL_END
