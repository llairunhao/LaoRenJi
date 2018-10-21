//
//  AlarmViewController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/20.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "AlarmViewController.h"
#import "XHAPI+API.h"
#import "XHUser.h"
#import "XHAlarm.h"
#import "UIButton+Landing.h"
#import "AlarmCell.h"

#import "AlarmEditController.h"

@interface AlarmViewController ()<UITableViewDelegate, UITableViewDataSource, AlarmCellDelegate>

@property (nonatomic, strong) NSMutableArray <XHAlarm *> *alarmClocks;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak)UILabel *emptyLabel;

@end

@implementation AlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提醒设置";
    [self setupSubview];
    [self refreshData];
 
}

- (void)refreshData {
    [self showLoadingHUD];
    WEAKSELF;
    XHAPIResultHandler handler = ^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        [weakSelf hideAllHUD];
        if (result.isSuccess) {
            NSArray *array = JSON.JSONArrayValue;
            weakSelf.alarmClocks = [NSMutableArray array];
            for (XHJSON *json in array) {
                XHAlarm *alarm = [[XHAlarm alloc] initWithJSON:json];
                [weakSelf.alarmClocks addObject:alarm];
            }
            [weakSelf.tableView reloadData];
            
            weakSelf.emptyLabel.hidden = weakSelf.alarmClocks.count > 0;
        }else {
            [weakSelf toast:result.message];
        }
    };
    [XHAPI listOfAlarmClocksByToken:[XHUser currentUser].token
                            handler:handler];
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
    _tableView = tableView;
    
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.textColor = [UIColor C3];
    label.text = @"无提醒记录";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    [self.view insertSubview:label atIndex:0];
    self.emptyLabel = label;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _alarmClocks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[AlarmCell alloc] initWithReuseIdentifier:@"cell"];
        cell.delegate = self;
    }
    cell.alarm = self.alarmClocks[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    AlarmEditController *controller = [[AlarmEditController alloc] init];
    controller.alarm = [self.alarmClocks[indexPath.row] copy];
    UNSAFESELF;
    controller.alarmHandler = ^(XHAlarm * _Nonnull alarm) {
        unsafeSelf.alarmClocks[indexPath.row] = alarm;
        [unsafeSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:controller animated:true];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WEAKSELF;
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf removeAlarmClockAtIndex:indexPath.row];
    }];
    return @[action];
}

- (void)buttonClick: (UIButton *)button {
    AlarmEditController *controller = [[AlarmEditController alloc] init];
    UNSAFESELF;
    controller.alarmHandler = ^(XHAlarm * _Nonnull alarm) {
        [unsafeSelf.alarmClocks addObject:alarm];
        [unsafeSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:controller animated:true];
}

- (void)removeAlarmClockAtIndex: (NSInteger)index {
    [self showLoadingHUD];
    XHAlarm *alarm = self.alarmClocks[index];
    WEAKSELF;
    XHAPIResultHandler handler = ^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        [weakSelf hideAllHUD];
        if (result.isSuccess) {
            [weakSelf.alarmClocks removeObjectAtIndex:index];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            weakSelf.emptyLabel.hidden = weakSelf.alarmClocks.count > 0;
        }else {
            [weakSelf.tableView endEditing:true];
            [weakSelf toast:result.message];
        }
    };
    
    [XHAPI removeAlarmClockById:alarm.alarmId
                          token:[XHUser currentUser].token
                        handler:handler];
}

- (void)updateAlarmEnable:(XHAlarm *)alarm {
    
    [self showLoadingHUD];
    WEAKSELF;
    XHAPIResultHandler handler = ^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        [weakSelf hideAllHUD];
        if (result.isSuccess) {
            [weakSelf.tableView reloadData];
        }else {
            alarm.enable = !alarm.enable;
            [weakSelf.tableView endEditing:true];
            [weakSelf toast:result.message];
        }
    };
    
    [XHAPI updateAlarmClockById:alarm.alarmId
                          token:[XHUser currentUser].token
                      eventName:alarm.eventName
                   eventContent:alarm.eventContent
                      eventTime:alarm.eventTime
                   timeInterval:alarm.timeInterval
                         enable:alarm.enable
                        simMark:alarm.simMark
                        handler:handler];
}

@end
