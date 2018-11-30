//
//  UIViewController+HUD.m
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/10/19.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import "UIViewController+HUD.h"
#import <MBProgressHUD.h>

@implementation UIViewController (HUD)


- (void)showLoadingHUD {
    [self showLoadingHUD:@"请稍等..."];
}

- (void)showLoadingHUD: (NSString *)title {
    MBProgressHUD *HUD = [MBProgressHUD HUDForView:self.view];
    if (!HUD) {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        HUD.bezelView.color = [UIColor blackColor];
        HUD.contentColor = [UIColor whiteColor];
        HUD.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    }
    HUD.label.text = title;
   // self.view.userInteractionEnabled = false;
}

- (void)hideAllHUD {
    self.view.userInteractionEnabled = true;
    [MBProgressHUD hideHUDForView:self.view animated:true];
}

- (void)toast: (NSString *)text {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    HUD.bezelView.color = [UIColor blackColor];
    HUD.contentColor = [UIColor whiteColor];
    HUD.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.mode = MBProgressHUDModeText;
    HUD.label.text = text;
    HUD.label.font = [UIFont systemFontOfSize:14];
    [HUD hideAnimated:true afterDelay:0.8];
}


- (void)destructiveAlertWithTitle: (nullable NSString *)title
                          message: (nullable NSString *)message
                   confirmHandler: (nullable AlertActionHandler) confirmHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消"
                                                     style: UIAlertActionStyleCancel
                                                   handler:nil];
    [alertController addAction:action];
    
    action = [UIAlertAction actionWithTitle:@"确定"
                                      style: UIAlertActionStyleDestructive
                                    handler:confirmHandler];
    [alertController addAction:action];
    [self presentViewController:alertController animated:true completion:nil];
}


@end
