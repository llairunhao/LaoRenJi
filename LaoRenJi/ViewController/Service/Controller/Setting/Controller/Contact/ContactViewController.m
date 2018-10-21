//
//  ContactViewController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/20.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "ContactViewController.h"
#import "UIButton+Landing.h"
#import "UIViewController+ChildController.h"
#import "ContactCell.h"

#import "XHAPI+API.h"
#import "XHUser.h"
#import "XHContact.h"

#import "ContactEditController.h"

@interface ContactViewController ()<UITableViewDelegate, UITableViewDataSource, ContactCellDelegate>

@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, weak)UILabel *emptyLabel;

@property (nonatomic, strong)NSMutableArray *contacts;
@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"电话本设置";
    [self setupSubview];
    [self refreshData];
}

- (void)refreshData {
    self.contacts = [NSMutableArray array];
    WEAKSELF;
    [self showLoadingHUD];
    
    [XHAPI listOfContactsByToken:[XHUser currentUser].token handler:^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        [weakSelf hideAllHUD];
        if (result.isSuccess) {
            NSArray *array = JSON.JSONArrayValue;
            for (XHJSON *json in array) {
                XHContact *contact = [[XHContact alloc] initWithJSON:json];
                [weakSelf.contacts addObject:contact];
            }
            weakSelf.tableView.hidden = false;
            [weakSelf.tableView reloadData];
            weakSelf.emptyLabel.hidden = weakSelf.contacts.count > 0;
        }else {
            [weakSelf toast:result.message];
        }
    }];
}

- (void)setupSubview {
    CGRect rect = self.view.bounds;
    
    UIButton *button = [UIButton landingButtonWithTitle:@"新增" target:self action:@selector(buttonClick:)];
    CGSize size = [button sizeThatFits:CGSizeZero];
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
    tableView.rowHeight = 70;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    tableView.hidden = true;
    _tableView = tableView;
    
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.textColor = [UIColor C3];
    label.text = @"无联系人记录";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    [self.view insertSubview:label atIndex:0];
    self.emptyLabel = label;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ContactCell alloc] initWithReuseIdentifier:@"cell"];
        cell.delegate = self;
    }
    cell.contact = self.contacts[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    ContactEditController *controller = [[ContactEditController alloc] init];
    controller.contact = self.contacts[indexPath.row];
    UNSAFESELF;
    controller.reloadHandler = ^{
        [unsafeSelf.tableView reloadData];
    };
    [self addController:controller];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WEAKSELF;
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf removeContactAtIndex:indexPath.row];
    }];
    return @[action];
}

- (void)buttonClick: (UIButton *)button {
    ContactEditController *controller = [[ContactEditController alloc] init];
    UNSAFESELF;
    controller.contactHandler = ^(XHContact *contact) {
        [unsafeSelf.contacts addObject:contact];
        [unsafeSelf.tableView reloadData];
    };
    [self addController:controller];
}

- (void)removeContactAtIndex: (NSInteger)index {
    [self showLoadingHUD];
    XHContact *contact = self.contacts[index];
    WEAKSELF;
    XHAPIResultHandler handler = ^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        [weakSelf hideAllHUD];
        if (result.isSuccess) {
            [weakSelf.contacts removeObjectAtIndex:index];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            weakSelf.emptyLabel.hidden = weakSelf.contacts.count > 0;
        }else {
            [weakSelf.tableView endEditing:true];
            [weakSelf toast:result.message];
        }
    };
    
    [XHAPI removeContactByToken:[XHUser currentUser].token
                      contactId:contact.contactId
                        handler:handler];
}

- (void)updateContact:(XHContact *)contact {
    [self showLoadingHUD];
    
    WEAKSELF;
    XHAPIResultHandler handler = ^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        [weakSelf hideAllHUD];
        if (result.isSuccess) {
            [weakSelf.tableView reloadData];
        }else {
            if (weakSelf) {
                contact.isAutoAnswer = false;
            }
            [weakSelf toast:result.message];
        }
    };
    
    [XHAPI updateContactByToken:[XHUser currentUser].token
                      contactId:contact.contactId
                           name:contact.name
                          phone:contact.phone
                       isUrgent:contact.isUrgent
                    urgentLevel:contact.urgentLevel
                   isAutoAnswer:contact.isAutoAnswer
                        handler:handler];
}

@end
