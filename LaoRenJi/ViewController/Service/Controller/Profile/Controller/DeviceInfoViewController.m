//
//  DeviceInfoViewController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/11/3.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "DeviceInfoViewController.h"
#import "XHUser.h"
#import "XHDevice.h"
#import "ProfileCell.h"
#import "UIButton+Landing.h"
#import "AlarmTextEditController.h"
#import "UIViewController+ChildController.h"
#import "XHAPI+API.h"

@interface DeviceInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation DeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设备信息";
    [self setupSubviews];
}
- (void)setupSubviews {
    
    CGRect rect = self.view.bounds;
    UIButton *button = [UIButton landingButtonWithTitle:@"解除绑定" target:self action:@selector(buttonClick:)];
    CGSize size = [button sizeThatFits:CGSizeZero];
    size.width = MIN(size.width, CGRectGetWidth(self.view.bounds) - 24.f);
    rect.origin.x = (CGRectGetWidth(self.view.bounds) - size.width ) / 2;
    rect.origin.y = CGRectGetHeight(self.view.bounds) - size.height - 12.f - [UIView bottomSafeAreaHeight];
    rect.size = size;
    button.frame = rect;
    [self.view addSubview:button];
    
    rect = self.view.bounds;
    rect.origin.y = [UIView topSafeAreaHeight];
    rect.size.height = CGRectGetMinY(button.frame) - 12.f - [UIView topSafeAreaHeight];
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    tableView.rowHeight = 60.f;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.tableFooterView = [[UIView alloc] init];
    _tableView = tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [XHUser currentUser].devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bind"];
    if (!cell) {
        cell = [[ProfileCell alloc] initWithReuseIdentifier:@"bind"];
        cell.leftWidth = 90.f;
    }
    
    NSArray *titles = @[@"设备编号：", @"设备名称："];
    NSArray *contents = @[self.device.simMark,
                          self.device.name];
    cell.textLabel.text = titles[indexPath.row];
    cell.contentLabel.text = contents[indexPath.row];
    cell.arrowView.hidden = indexPath.row == 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView  deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.row == 1) {
        AlarmTextEditController *controller = [[AlarmTextEditController alloc] init];
        controller.title = @"修改设备名称";
        controller.text = self.device.name;
        [self addController:controller];
        WEAKSELF;
        controller.textHandler = ^(NSString *text) {
            [weakSelf updateDeviceName: text];
        };
    }
    
}
- (void)buttonClick: (UIButton *)button {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"解除绑定该设备？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [controller addAction:action];
    
    action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self unbindDevice];
    }];
    [controller addAction:action];
    
    [self presentViewController:controller animated:true completion:nil];
}

- (void)unbindDevice {
    [self showLoadingHUD];
    WEAKSELF;
    [XHAPI unbindDeviceByToken:[XHUser currentUser].token
                    appAccount:self.device.appAccount
                       handler:^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
                           [weakSelf hideAllHUD];
                           if (!result.isSuccess) {
                               [weakSelf toast:result.message];
                           }else {
                               [[XHUser currentUser] removeDevice:weakSelf.device];
                               [weakSelf.navigationController popViewControllerAnimated:true];
                           }
                       }];
}

- (void)updateDeviceName: (NSString *)text {

}
@end
