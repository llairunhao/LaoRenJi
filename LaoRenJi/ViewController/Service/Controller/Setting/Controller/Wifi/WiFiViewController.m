//
//  WiFiViewController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/20.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "WiFiViewController.h"
#import "ServiceTextFieldContainer.h"
#import "UIButton+Landing.h"
#import "XHAPI+API.h"
#import "XHUser.h"

@interface WiFiViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    __weak UITextField *_nameTF;
    __weak UITextField *_typeTF;
    __weak UITextField *_passwordTF;
    
    NSString *_password;
}
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation WiFiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"网络设置";
    [self setupSubviews];
}

- (void)setupSubviews {
    CGRect rect = self.view.bounds;
    rect.origin.y = [UIView topSafeAreaHeight];
    rect.size.height = 60;
    ServiceTextFieldContainer *containter = [[ServiceTextFieldContainer alloc] initWithFrame:rect];
    containter.textLabel.text = @"WIFI名称：";
    CGSize size = [containter.textLabel sizeThatFits:CGSizeZero];
    CGFloat labelWidth = size.width + 8;
    containter.labelWidth = labelWidth;
    containter.textField.placeholder = @"请输入WIFI名称";
    _nameTF = containter.textField;
    [self.view addSubview:containter];
    
//    rect.origin.y = CGRectGetMaxY(rect);
//    containter = [[ServiceTextFieldContainer alloc] initWithFrame:rect];
//    containter.textLabel.text = @"加密类型：";
//    containter.textField.placeholder = @"请选择加密类型";
//    _typeTF = containter.textField;
//    containter.labelWidth = labelWidth;
//    containter.textField.delegate = self;
//    containter.textField.keyboardType = UIKeyboardTypeNumberPad;
//    [self.view addSubview:containter];
    
    rect.origin.y = CGRectGetMaxY(rect);
    containter = [[ServiceTextFieldContainer alloc] initWithFrame:rect];
    containter.textLabel.text = @"密      码：";
    containter.textField.placeholder = @"请输入WIFI密码";
    containter.labelWidth = labelWidth;
    _passwordTF = containter.textField;
    containter.textField.secureTextEntry = true;
    [self.view addSubview:containter];
    
    UIButton *button = [UIButton landingButtonWithTitle:@"保存" target:self action:@selector(buttonClick:)];
    size = [button sizeThatFits:CGSizeZero];
     size.width = MIN(size.width, CGRectGetWidth(self.view.bounds) - 24.f);
    rect.origin.x = (CGRectGetWidth(self.view.bounds) - size.width ) / 2;
    rect.origin.y = CGRectGetMaxY(containter.frame) + 24.f;
    rect.size = size;
    button.frame = rect;
    [self.view addSubview:button];
    
    
    rect.origin.y = CGRectGetMaxY(_typeTF.superview.frame);
    rect.size.height = CGFLOAT_MIN;
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 44.f;
    [self.view addSubview:tableView];
    _tableView = tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.textColor = [UIColor C1];
    }
    cell.textLabel.text = @[@"NOPASS", @"WEP", @"WPA"][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect rect = _tableView.frame;
    rect.size.height = CGFLOAT_MIN;
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.frame = rect;
    }];
    _typeTF.text = @[@"NOPASS", @"WEP", @"WPA"][indexPath.row];
    if (indexPath.row == 0) {
        _password = _passwordTF.text;
    }
    _passwordTF.enabled = indexPath.row != 0;
    if (indexPath.row == 0) {
        _passwordTF.text = @"NO PASSWORD";
    }else {
        _passwordTF.text = _password;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CGRect rect = _tableView.frame;
    rect.origin.x = CGRectGetMinX(_typeTF.frame) - 12;
    _tableView.frame = rect;
    rect.size.height = _tableView.rowHeight * 3;
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.frame = rect;
    }];
    return false;
}



- (void)buttonClick: (UIButton *)button {
    if (_nameTF.text.length == 0) {
        [self toast:@"请输入WIFI名称"];
        return;
    }
//    if (_typeTF.text.length == 0) {
//        [self toast:@"请选择加密类型"];
//        return;
//    }
    if (_passwordTF.text.length == 0 && _tableView.indexPathForSelectedRow.row != 0) {
        [self toast:@"请输入WIFI密码"];
        return;
    }
    [self showLoadingHUD];
    WEAKSELF;
    XHAPIResultHandler handler = ^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        [weakSelf hideAllHUD];
        
        if (result.isSuccess) {
            [weakSelf toast:@"设置成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:true];
            });
        }else {
            [weakSelf toast:result.message];
        }
    };
    
    [XHAPI saveDeviceWifiByToken:[XHUser currentUser].token
                        wifiName:_nameTF.text
                            type:3
                        password:_passwordTF.text
                         handler:handler];
}
@end
