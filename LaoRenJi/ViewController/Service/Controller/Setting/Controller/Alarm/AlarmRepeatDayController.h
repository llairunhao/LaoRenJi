//
//  AlarmRepeatDayController.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/21.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHNavigationBarController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RepeatDaysHandler)(NSMutableArray *repeatDays);

@interface AlarmRepeatDayController : XHNavigationBarController

@property (nonatomic, strong) NSMutableArray *repeatDays;

@property (nonatomic, copy) RepeatDaysHandler repeatDayHandler;

@end

NS_ASSUME_NONNULL_END
