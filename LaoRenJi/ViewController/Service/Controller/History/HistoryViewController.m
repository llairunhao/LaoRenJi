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

@interface HistoryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史";
    [self setupSubviews];
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
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bind"];
    if (!cell) {
        cell = [[HistoryCell alloc] initWithReuseIdentifier:@"bind"];
    }
    cell.textLabel.text = @"爸爸";
    cell.detailTextLabel.text = @"2018-12-12   09:30";
    cell.historyType = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView  deselectRowAtIndexPath:indexPath animated:true];

}


- (void)buttonClick: (UIButton *)button {
    
}

@end
