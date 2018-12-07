//
//  HistoryViewController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/27.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryCell.h"
#import "UIButton+Landing.h"
#import "XHUser.h"
#import "XHDevice.h"
#import "DBManager+DeviceLog.h"

@interface HistoryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *source;
@property (nonatomic, weak)UILabel *emptyLabel;
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史";
    [self setupSubviews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:XHNewDeviceLogNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupSubviews {
   
     CGRect rect = self.view.bounds;
    UIButton *button = [UIButton landingButtonWithTitle:@"清空" target:self action:@selector(buttonClick:)];
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
    tableView.rowHeight = 70.f;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.tableFooterView = [[UIView alloc] init];
    _tableView = tableView;
    
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.textColor = [UIColor C3];
    label.text = @"无提醒记录";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:label];
    self.emptyLabel = label;
    
    self.source = [[DBManager sharedInstance] listOfCurrentDeviceLogs];
    label.hidden = self.source.count > 0;
}

- (void)reloadData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[DBManager sharedInstance] updateAllCurrentDeviceLogStatus];
        self.source = [[DBManager sharedInstance] listOfCurrentDeviceLogs];
        self.emptyLabel.hidden = self.source.count > 0;
    });
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.source.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bind"];
    if (!cell) {
        cell = [[HistoryCell alloc] initWithReuseIdentifier:@"bind"];
    }
    NSDictionary *dict = self.source[indexPath.row];
    cell.textLabel.text = [XHUser currentUser].currentDevice.name;
    
    static NSDateFormatter *formatter;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd hh:mm";
    }
    NSTimeInterval interval = [dict[@"timeSp"] doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    cell.detailTextLabel.text = [formatter stringFromDate:date];
    cell.historyType = [dict[@"type"] integerValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView  deselectRowAtIndexPath:indexPath animated:true];

}


- (void)buttonClick: (UIButton *)button {
    [[DBManager sharedInstance] removeCurrentDeviceAllLogs];
    self.source = @[];
    [self.tableView reloadData];
    self.emptyLabel.hidden = false;
}

@end
