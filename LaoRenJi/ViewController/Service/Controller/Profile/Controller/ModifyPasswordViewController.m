//
//  ModifyPasswordViewController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/11/3.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "XHAPI+API.h"
#import "XHUser.h"

@interface ModifyPasswordViewController ()

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    self.title = @"重置密码";
    [super viewDidLoad];
}

- (NSArray<NSString *> *)placeholders {
    return @[@"新密码", @"确认新密码", @"原始密码"];
}

- (BOOL)secureTextEntryAtIndex:(NSInteger)index {
    return true;
}

- (void)actionButtonClick:(UIButton *)button {
    
    if (![self.textFields[1].text isEqualToString:self.textFields[0].text]) {
        [self toast:@"两次密码输入不一致"];
        return;
    }
    
    [self showLoadingHUD];
    WEAKSELF;
    [XHAPI resetPasswordWithToken:[XHUser currentUser].token
                      oldPassword:self.textFields[2].text
                      newPassword:self.textFields[0].text
                          handler:^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
                              [weakSelf hideAllHUD];
                              [weakSelf toast:result.message];
                              if (result.isSuccess) {
                                  [XHUser currentUser].password = weakSelf.textFields[0].text;
                                  [[XHUser currentUser] login];
                                  [weakSelf.navigationController popViewControllerAnimated:true];
                              }
                              
                          }];
}



@end
