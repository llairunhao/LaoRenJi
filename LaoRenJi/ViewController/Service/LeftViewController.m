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
#import "LeftHeaderView.h"

#import "XHUser.h"
#import "XHDevice.h"
#import "XHAPI+API.h"

#import "QRScanningViewController.h"
#import "ProfileViewController.h"


@interface LeftViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UIView *tableBgView;
@property (nonatomic, weak) LeftHeaderView *headerView;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvLoginNoti:) name:XHUserDidLoginNotification object:nil];
  
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
    
    rect = CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetWidth(rect) * 1.618);
    LeftHeaderView *headerView = [[LeftHeaderView alloc] initWithFrame:rect];
    tableView.tableHeaderView = headerView;
     [headerView reloadData];
    _headerView = headerView;
    UNSAFESELF;
    headerView.clickHandler = ^{
        ProfileViewController *controller = [[ProfileViewController alloc] init];
        [unsafeSelf.navigationController pushViewController:controller animated:true];
    };
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
        return [XHUser currentUser].devices.count;
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
        cell.textLabel.text = [XHUser currentUser].devices[indexPath.row].name;
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
    if (indexPath.section == 1) {
        QRScanningViewController *controller = [[QRScanningViewController alloc] init];
        [self.navigationController pushViewController:controller animated:true];
        [self hideAnimation];
        return;
    }
    
    
    WEAKSELF;
    [self showLoadingHUD];
    XHDevice *device = [XHUser currentUser].devices[indexPath.row];
    XHAPIResultHandler handler = ^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        [weakSelf hideAllHUD];
        if (result.isSuccess) {
            weakSelf.selectedIndex = indexPath.row;
            [XHUser currentUser].currentDevice = device;
            [tableView reloadData];
        }else {
            [weakSelf toast:result.message];
        }
    };
    [XHAPI setCurrentDeviceByToken:[XHUser currentUser].token
                     deviceSimMark:device.simMark
                           handler:handler];
    
    
}

- (void)recvLoginNoti: (NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.selectedIndex = 0;
        [self.headerView reloadData];
    });
}

@end
