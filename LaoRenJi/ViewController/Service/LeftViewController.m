//
//  LeftViewController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/17.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "LeftViewController.h"
#import "LeftViewDeviceCell.h"
#import "LeftViewBindCell.h"


@interface LeftViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UIView *tableBgView;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
}

- (void)setupSubviews {
    CGRect rect = self.view.bounds;
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0;
    [self.view addSubview:bgView];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAnimation)];
    [bgView addGestureRecognizer:tapGestureRecognizer];
    _bgView = bgView;
    

    rect.size.width = 150.f;
    rect.origin.x = -(CGRectGetWidth(rect));
    UIView *tableBgView = [[UIView alloc] initWithFrame:rect];
    tableBgView.backgroundColor = [UIColor EC1];
    tableBgView.alpha = 0.7;
    [self.view addSubview:tableBgView];
    self.tableBgView = tableBgView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)hideAnimation {
    CGRect rect = self.tableView.frame;
    rect.origin.x = -CGRectGetWidth(rect);
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.frame = rect;
        self.tableBgView.frame = rect;
        self.bgView.alpha = 0;
    }completion:^(BOOL finished) {
        self.view.hidden = finished;
    }];
}

- (void)showAnimation {
    self.view.hidden = false;
    CGRect rect = self.tableView.frame;
    rect.origin.x = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.frame = rect;
        self.tableBgView.frame = rect;
        self.bgView.alpha = 0.3;
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LeftViewDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"device"];
        if (!cell) {
            cell = [[LeftViewDeviceCell alloc] initWithReuseIdentifier:@"device"];
        }
        cell.ticked = self.selectedIndex == indexPath.row;
        cell.textLabel.text = @"31231";
        return cell;
    }
    LeftViewBindCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bind"];
    if (!cell) {
        cell = [[LeftViewBindCell alloc] initWithReuseIdentifier:@"bind"];
    }
    cell.textLabel.text = @"添加设备";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        self.selectedIndex = indexPath.row;
        [tableView reloadData];
    }
    
}

@end
