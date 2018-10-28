//
//  ResetPassworViewController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/14.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "ResetPassworViewController.h"
#import "XHAPI+API.h"

@interface ResetPassworViewController ()

@end

@implementation ResetPassworViewController

- (void)actionButtonClick:(UIButton *)button {
    for (NSInteger i = 0; i < self.textFields.count; i++) {
        if (self.textFields[i].text.length == 0) {
            [self toast:@"请输入正确的格式"];
            return;
        }
    }
    
    WEAKSELF;
    XHAPIResultHandler handler = ^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        [weakSelf hideAllHUD];
        if (result.isSuccess) {
            [weakSelf toast:@"注册成功，返回登陆页面"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:true];
            });
        }else {
            [weakSelf toast:result.message];
        }
    };
    [self showLoadingHUD];
    [XHAPI resetPasswordWithAccount:self.textFields[0].text
                           password:self.textFields[1].text
                               code:self.textFields[3].text
                            handler:handler];
}

- (void)viewDidLoad {
    
    self.title = @"重置密码";
    [super viewDidLoad];
}

- (NSArray<NSString *> *)placeholders {
    return  @[@"手机号码", @"新密码", @"短信验证码"];
}

- (BOOL)secureTextEntryAtIndex:(NSInteger)index {
    return index == 1;
}

@end
