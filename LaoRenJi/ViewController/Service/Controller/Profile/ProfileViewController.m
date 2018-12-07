//
//  ProfileViewController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/27.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileCell.h"
#import "UIButton+Landing.h"
#import "ProfileHeaderView.h"
#import "XHUser.h"
#import "LoginViewController.h"
#import "XHNavigationController.h"
#import "DBManager.h"
#import "AlarmTextEditController.h"
#import "UIViewController+ChildController.h"

@interface ProfileViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
}
- (void)setupSubviews {
    self.title = @"个人中心";
    CGRect rect = self.view.bounds;
    UIButton *button = [UIButton landingButtonWithTitle:@"退出登录" target:self action:@selector(buttonClick:)];
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
    
    ProfileHeaderView *headerView = [[ProfileHeaderView alloc] initWithFrame:rect];
    size = [headerView sizeThatFits:CGSizeZero];
    rect = self.view.bounds;
    CGFloat height = size.height / size.width * CGRectGetWidth(rect);
    rect.size.height = height;
    headerView.frame = rect;
    [headerView reloadData];
    _tableView.tableHeaderView = headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *titles = @[@"账号", @"密码", @"昵称", @"设备管理", @"终端号码"];
    NSArray *contents = @[[XHUser currentUser].account,
                          @"********",
                          [XHUser currentUser].nickname,
                          @"",
                          [[DBManager sharedInstance] getCurrentDevicePhone]];
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bind"];
    if (!cell) {
        cell = [[ProfileCell alloc] initWithReuseIdentifier:@"bind"];
        cell.leftWidth = indexPath.row == 3 ? 200.f : 90.f;
    }
    cell.textLabel.text = titles[indexPath.row];
    cell.contentLabel.text = contents[indexPath.row];
    cell.arrowView.hidden = indexPath.row == 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView  deselectRowAtIndexPath:indexPath animated:true];
    
    if (indexPath.row == 3) {
        UIViewController *controller = [[NSClassFromString(@"DevicesViewController") alloc] init];
        [self.navigationController pushViewController:controller animated:true];
    }else if (indexPath.row == 1) {
        UIViewController *controller = [[NSClassFromString(@"ModifyPasswordViewController") alloc] init];
        [self.navigationController pushViewController:controller animated:true];
    }else if (indexPath.row == 4) {
        AlarmTextEditController *editController = [[AlarmTextEditController alloc] init];
        editController.placeholder = @"请输入设备号码";
        editController.title = @"设备号码";
        editController.text = [[DBManager sharedInstance] getCurrentDevicePhone];
        UNSAFESELF;
        editController.textHandler = ^(NSString *text) {
            [[DBManager sharedInstance] setCurrentDevicePhone:text];
            [unsafeSelf.tableView reloadData];
        };
        [self addController:editController];
        editController.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
}

- (void)buttonClick: (UIButton *)button {
    [[XHUser currentUser] logout];
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    XHNavigationController *nav = [[XHNavigationController alloc] initWithRootViewController:loginViewController];
    nav.navigationBarHidden = true;
    [self presentViewController:nav animated:true completion:^{
        [self.navigationController popToRootViewControllerAnimated:true];
    }];
}


@end
