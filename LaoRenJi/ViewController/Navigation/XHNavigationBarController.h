//
//  XHNavigationBarController.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/14.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHSafeNavigationBar.h"
#import "XHNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface XHNavigationBarController : UIViewController

@property (nonatomic, readonly) XHNavigationBar *navigationBar;
@property (nonatomic, readonly) XHSafeNavigationBar *safeNavigationBar;

@property (nonatomic, assign) BOOL navigationBarHidden;

@end

NS_ASSUME_NONNULL_END
