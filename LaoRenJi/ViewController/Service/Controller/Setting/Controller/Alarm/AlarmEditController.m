//
//  AlarmEditController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/21.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "AlarmEditController.h"
#import "AlarmTimeCell.h"
#import "XHAlarm.h"
#import "AlarmButton.h"
#import "UIButton+Landing.h"
#import "AlarmPickerFlowLayout.h"
#import "AlarmTextEditController.h"
#import "UIViewController+ChildController.h"
#import "XHAPI+API.h"
#import "XHUser.h"
#import "AlarmRepeatDayController.h"

@interface AlarmEditController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *hourView;
@property (nonatomic, weak) UICollectionView *minuteView;

@property (nonatomic, weak) AlarmButton *repeatButton;
@property (nonatomic, weak) AlarmButton *contentButton;


@property (nonatomic, weak) AlarmPickerFlowLayout *hourLayout;
@property (nonatomic, weak) AlarmPickerFlowLayout *minuteLayout;
@end

@implementation AlarmEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    
    if (@available(iOS 11.0, *)) {
        _hourView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _minuteView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_hourView reloadData];
    [_minuteView reloadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hourView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.alarm.hour inSection:500] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:false];
        [self.minuteView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.alarm.minute inSection:500] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:false];
    });
}

- (XHAlarm *)alarm {
    if (!_alarm) {
        _alarm = [XHAlarm emptyAlarm];
    }
    return _alarm;
}

- (void)setupSubviews {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CLOCK"]];
    imageView.userInteractionEnabled = true;
    [self.view addSubview:imageView];

    CGSize size = [imageView sizeThatFits:CGSizeZero];
    CGRect rect = self.view.bounds;
    rect.origin.y = [UIView topSafeAreaHeight] + 24.f;
    rect.origin.x = (CGRectGetWidth(self.view.bounds) - size.width ) / 2;
    rect.size = size;
    imageView.frame = rect;
    
    rect.origin = CGPointZero;
    rect.size.width = size.width / 2;
    
    AlarmPickerFlowLayout *layout = [[AlarmPickerFlowLayout alloc] init];
    _hourLayout = layout;
    layout.itemSize = rect.size;
    layout.hour = self.alarm.hour;
    layout.minimumLineSpacing = CGFLOAT_MIN;
    layout.minimumInteritemSpacing = CGFLOAT_MIN;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    [collectionView registerClass:[AlarmTimeCell class] forCellWithReuseIdentifier:@"cell"];
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = false;
    [imageView addSubview:collectionView];
    _hourView = collectionView;
    
    rect.origin.x = CGRectGetMaxX(rect);
    layout = [[AlarmPickerFlowLayout alloc] init];
    _minuteLayout = layout;
    layout.minute = self.alarm.minute;
    layout.itemSize = rect.size;
    layout.minimumLineSpacing = CGFLOAT_MIN;
    layout.minimumInteritemSpacing = CGFLOAT_MIN;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    [collectionView registerClass:[AlarmTimeCell class] forCellWithReuseIdentifier:@"cell"];
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = false;
    [imageView addSubview:collectionView];
    _minuteView = collectionView;
    
    AlarmButton *button = [AlarmButton buttonWithType:UIButtonTypeCustom];
    button.leftLabel.text = @"重复：";
    button.rightLabel.text = self.alarm.repeatDay;
    rect = self.view.bounds;
    rect.origin.y = CGRectGetMaxY(imageView.frame) + 24.f;
    rect.size.height = 50.f;
    button.frame = rect;
    [button addTarget:self
               action:@selector(alarmButtonClick:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    _repeatButton = button;
    
    button = [AlarmButton buttonWithType:UIButtonTypeCustom];
    button.tag = 1;
    button.leftLabel.text = @"说明：";
    button.rightLabel.text = self.alarm.eventContent;
    rect.origin.y = CGRectGetMaxY(rect);
    button.frame = rect;
    [button addTarget:self
               action:@selector(alarmButtonClick:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    _contentButton = button;
    
    UIButton *button1 = [UIButton landingButtonWithTitle:@"确定" target:self action:@selector(actionButtonClick:)];
    rect.origin.y = CGRectGetMaxY(rect) + 24.f;
    rect.size.width = (CGRectGetWidth(self.view.bounds) - 24.f - 12.f ) / 2;
    rect.size.height = 50.f;
    rect.origin.x = 12.f;
    button1.frame = rect;
    [self.view addSubview:button1];
    
    button1 = [UIButton grayButtonWithTitle:@"取消" target:self action:@selector(actionButtonClick:)];
    button1.tag = 1;
    rect.origin.x = CGRectGetMaxX(rect) + 12.f;
    button1.frame = rect;
    [self.view addSubview:button1];
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1000;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _hourView) {
        return 24;
    }
    return 60;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AlarmTimeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.time = indexPath.item;
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    return cell;
}

- (void)alarmButtonClick: (UIButton *)button {
    if (button.tag == 1) {
        AlarmTextEditController *controller = [[AlarmTextEditController alloc] init];
        controller.text = self.alarm.eventContent;
        controller.placeholder = @"请输入说明";
        controller.title = @"修改说明";
        UNSAFESELF;
        controller.textHandler = ^(NSString *text) {
            unsafeSelf.alarm.eventContent = text;
            unsafeSelf.alarm.eventName = text;
            unsafeSelf.contentButton.rightLabel.text = text;
        };
        [self addController:controller];
    }else {
        AlarmRepeatDayController *controller = [[AlarmRepeatDayController alloc] init];
        controller.repeatDays = self.alarm.repeatDays;
        UNSAFESELF;
        controller.repeatDayHandler = ^(NSMutableArray * _Nonnull repeatDays) {
            unsafeSelf.alarm.repeatDays = repeatDays;
            unsafeSelf.repeatButton.rightLabel.text = unsafeSelf.alarm.repeatDay;
        };
        [self.navigationController pushViewController:controller animated:true];
    }
}

- (void)actionButtonClick: (UIButton *)button {
    if (button.tag == 1) {
        [self.navigationController popViewControllerAnimated:true];
        return;
    }
    if (self.alarm.eventContent.length == 0) {
        [self toast:@"请输入提醒说明"];
        return;
    }
    

    [self updateAlarm];
}



- (void) updateAlarm{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitYear |NSCalendarUnitMonth |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self.alarm.alarmDate];
    components.hour = _hourLayout.hour;
    components.minute = _minuteLayout.minute;

    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
    self.alarm.alarmDate = date;
    [self showLoadingHUD];
    
    WEAKSELF;
    XHAPIResultHandler handler = ^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        [weakSelf hideAllHUD];
        if (result.isSuccess) {
            if (weakSelf.alarm.alarmId == 0) {
                weakSelf.alarm.alarmId = JSON.unsignedIntegerValue;
            }
            weakSelf.alarmHandler(weakSelf.alarm);
            [weakSelf.navigationController popViewControllerAnimated:true];
        }else {
            [weakSelf toast:result.message];
        }
    };
    
    NSString *token = [XHUser currentUser].token;
    if (self.alarm.alarmId > 0) {
        [XHAPI updateAlarmClockById:self.alarm.alarmId
                              token:token
                          eventName:self.alarm.eventName
                       eventContent:self.alarm.eventContent
                          eventTime:self.alarm.eventTime
                       timeInterval:self.alarm.timeInterval
                             enable:self.alarm.enable
                            simMark:self.alarm.simMark
                            handler:handler];
    }else {
        [XHAPI saveAlarmClockByToken:token
                           eventName:self.alarm.eventName
                        eventContent:self.alarm.eventContent
                           eventTime:self.alarm.eventTime
                        timeInterval:self.alarm.timeInterval
                              enable:self.alarm.enable
                             simMark:self.alarm.simMark
                             handler:handler];
    }
}

@end
