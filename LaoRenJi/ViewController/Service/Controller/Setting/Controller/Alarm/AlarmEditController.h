//
//  AlarmEditController.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/21.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHNavigationBarController.h"

NS_ASSUME_NONNULL_BEGIN

@class XHAlarm;

typedef void(^AlarmHandler)(XHAlarm *alarm);

@interface AlarmEditController : XHNavigationBarController

@property (nonatomic, strong) XHAlarm *alarm;
@property (nonatomic, copy) AlarmHandler alarmHandler;

@end

NS_ASSUME_NONNULL_END
