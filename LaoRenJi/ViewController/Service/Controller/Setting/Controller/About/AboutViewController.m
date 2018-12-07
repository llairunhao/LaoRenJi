//
//  AboutViewController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/20.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";
   

    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *bulid = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *str = [NSString stringWithFormat:@"版本号：V%@ bulid:%@", version, bulid];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, [UIView topSafeAreaHeight], CGRectGetWidth(self.view.bounds), 60)];
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor C1];
    label.text = str;
    [self.view addSubview:label];
    
}


@end
