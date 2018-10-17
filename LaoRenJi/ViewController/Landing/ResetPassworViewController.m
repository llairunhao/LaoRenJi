//
//  ResetPassworViewController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/14.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "ResetPassworViewController.h"


@interface ResetPassworViewController ()

@end

@implementation ResetPassworViewController

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
