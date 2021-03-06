//
//  LocusViewController.m
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/10/19.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import "LocusViewController.h"
#import "DeviceSettingCell.h"
#import "XHAPI+API.h"
#import "XHUser.h"
#import "DBManager.h"

@interface LocusViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation LocusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"轨迹";
    [self setupSubviews];
}

- (void)setupSubviews {
    CGRect rect = self.view.bounds;
    rect.origin.y = [UIView topSafeAreaHeight];
    rect.size.height -= [UIView safeAreaHeight];
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    tableView.rowHeight = 70.f;
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSString *identifier = indexPath.row == 0 ? @"s" : @"b";
    NSArray *titles = @[@"开启轨迹记录", @"查看历史轨迹", @"查看当前位置", @"设置围栏"];
    DeviceSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DeviceSettingCell alloc] initWithReuseIdentifier:identifier];
    }
    UIButton *button = [cell viewWithTag:1024];
    if (indexPath.row == 0) {
        if (!button) {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            [cell.contentView addSubview:button];
            [button setImage:[UIImage imageNamed:@"SWITCH"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"SWITCHON"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(switchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            CGSize size = [button sizeThatFits:CGSizeZero];
            CGRect rect = self.view.bounds;
            rect.origin.x = CGRectGetWidth(rect) - size.width - 12.f;
            rect.origin.y = (tableView.rowHeight - size.height ) / 2;
            rect.size = size;
            button.frame = rect;
            button.tag = 1024;
        }
        button.selected = [[DBManager sharedInstance] getCurrentDeviceLocusState];
    }
    button.hidden = indexPath.row > 0;
    cell.textLabel.text = titles[indexPath.row];
    cell.arrowView.hidden = indexPath.row == 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSArray *classes = @[@"",
                         @"TraceViewController",
                         @"LocationViewController",
                         @"FenceViewController"];
    UIViewController *controller = [[NSClassFromString(classes[indexPath.row]) alloc] init];
    if (controller) {
        [self.navigationController pushViewController:controller animated:true];
    }
}

- (void)switchButtonClick: (UIButton *)button {
    //button.selected = !button.selected;
    
    __weak typeof(button) weakButton = button;
    WEAKSELF;
    [self showLoadingHUD];
    XHLocationStatus status = !button.selected ? XHLocationStop : XHLocationOpen;
    [XHAPI locateDeviceByToken:[XHUser currentUser].token
                        status:status
                      duration:60
                         count:99999
                      accuracy:XHLocationAccuracyBest
                       handler:^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
                           [weakSelf hideAllHUD];
                           if (result.isSuccess) {
                               [weakSelf toast:result.message];
                               weakButton.selected = !weakButton.selected;
                               [[DBManager sharedInstance] saveCurrentDeviceLocusState:weakButton.selected];
                           }else {
                               [weakSelf toast:result.message];
                           }
                       }];
}

@end
