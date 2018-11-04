//
//  DevicesViewController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/11/3.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "DevicesViewController.h"
#import "DeviceSettingCell.h"
#import "XHUser.h"
#import "XHDevice.h"
#import "DeviceInfoViewController.h"

@interface DevicesViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;


@end

@implementation DevicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设备列表";
    [self setupSubviews];
}
- (void)setupSubviews {
    
    CGRect rect = self.view.bounds;
    rect.origin.y = [UIView topSafeAreaHeight];
    rect.size.height -= [UIView safeAreaHeight];
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    tableView.rowHeight = 60.f;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.tableFooterView = [[UIView alloc] init];
    _tableView = tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [XHUser currentUser].devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bind"];
    if (!cell) {
        cell = [[DeviceSettingCell alloc] initWithReuseIdentifier:@"bind"];
    }
    cell.textLabel.text = [XHUser currentUser].devices[indexPath.row].name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView  deselectRowAtIndexPath:indexPath animated:true];
    XHDevice *device = [XHUser currentUser].devices[indexPath.row];
    DeviceInfoViewController *controller = [[DeviceInfoViewController alloc] init];
    controller.device = device;
    [self.navigationController pushViewController:controller animated:true];
}


@end
