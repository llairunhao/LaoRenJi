//
//  AlarmRepeatDayController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/21.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "AlarmRepeatDayController.h"
#import "UIButton+Landing.h"
#import "DeviceSettingCell.h"

@interface AlarmRepeatDayController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation AlarmRepeatDayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重复";
    [self setupSubviews];
}

- (void)setRepeatDays:(NSMutableArray *)repeatDays {
    _repeatDays = [NSMutableArray arrayWithArray:[repeatDays copy]];
}

- (void)setupSubviews {
    
    CGRect rect = self.view.bounds;
    UIButton *button = [UIButton landingButtonWithTitle:@"确定" target:self action:@selector(buttonClick:)];
    CGSize size = [button sizeThatFits:CGSizeZero];
     size.width = MIN(size.width, CGRectGetWidth(self.view.bounds) - 24.f);
    rect.origin.y = CGRectGetHeight(rect) - size.height - 12.f - [UIView bottomSafeAreaHeight];
    rect.origin.x = (CGRectGetWidth(rect) - size.width ) / 2;
    rect.size = size;
    button.frame = rect;
    [self.view addSubview:button];
    
    rect = self.view.bounds;
    rect.origin.y = [UIView topSafeAreaHeight];
    rect.size.height = CGRectGetMinY(button.frame) - CGRectGetMinY(rect) - 12.f;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 50;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[DeviceSettingCell alloc] initWithReuseIdentifier:@"cell"];
    }
    NSString *imageName =  [self.repeatDays[indexPath.row] integerValue] == 0 ? @"icon_tickbox_nor" : @"icon_tickbox_sel";
    cell.arrowView.image = [UIImage imageNamed:imageName];
    NSArray *days = @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"];
    cell.textLabel.text = days[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSUInteger value = [self.repeatDays[indexPath.row] unsignedIntegerValue];
    value = value == 0 ? 1 : 0;
    self.repeatDays[indexPath.row] = @(value);
    [tableView reloadData];
}

- (void)buttonClick: (UIButton *)button {
    if (self.repeatDayHandler) {
        self.repeatDayHandler(self.repeatDays);
    }
    [self.navigationController popViewControllerAnimated:true];
}

@end
