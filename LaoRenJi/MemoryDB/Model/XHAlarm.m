//
//  XHAlarm.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/21.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHAlarm.h"
#import "XHUser.h"
#import "XHDevice.h"

@implementation XHAlarm

static NSDateFormatter *kFormatter;

+ (instancetype)emptyAlarm {
    XHAlarm *alarm = [[XHAlarm alloc] init];
    alarm.eventContent = @"";
    alarm.eventName = @"";
    alarm.alarmDate = [NSDate date];
    alarm.repeatDays = [@[@(0),@(0),@(0),@(0),@(0),@(0),@(0)] mutableCopy];
    alarm.enable = true;
    alarm.simMark = [XHUser currentUser].currentDevice.simMark;
    return alarm;
}

- (instancetype)initWithJSON:(XHJSON *)JSON {
    self = [super init];
    if (self) {
        [self setupWithJSON:JSON];
    }
    return self;
}

- (XHAlarm *)copy {
    XHAlarm *alarm      =   [[XHAlarm alloc] init];
    alarm.eventName     =   self.eventName;
    alarm.eventContent  =   self.eventContent;
    alarm.enable        =   self.enable  ;
    alarm.alarmId       =   self.alarmId ;
    alarm.simMark       =   self.simMark ;
    alarm.repeatDays    =   [NSMutableArray arrayWithArray:[self.repeatDays copy]];
    alarm.alarmDate     =   self.alarmDate;
    return alarm;
}

- (void)setupWithJSON:(XHJSON *)JSON {
    self.eventName      =   [JSON JSONForKey:@"eventName"].stringValue;
    self.eventContent   =   [JSON JSONForKey:@"eventContent"].stringValue;
    self.enable         =   [JSON JSONForKey:@"status"].boolValue;
    self.alarmId        =   [JSON JSONForKey:@"id"].unsignedIntegerValue;
    self.simMark        =   [JSON JSONForKey:@"simMark"].stringValue;
    
    
    NSString *timeInterval = [JSON JSONForKey:@"timeInterval"].stringValue;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:7];
    for(NSInteger i = 0; i < timeInterval.length; i++){
        NSInteger value = [[timeInterval substringWithRange:NSMakeRange(i, 1)] integerValue];
        [array addObject:@(value)];
    }
    for (NSInteger i = array.count; i < 7; i++) {
        [array addObject:@(0)];
    }
    self.repeatDays = [[array subarrayWithRange:NSMakeRange(0, 7)] mutableCopy];
    
    NSString *eventTime = [JSON JSONForKey:@"eventTime"].stringValue;
    if (!kFormatter) {
        kFormatter = [[NSDateFormatter alloc] init];
        kFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    self.alarmDate = [kFormatter dateFromString:eventTime];
}

- (NSString *)repeatDay {
    if (![self.repeatDays containsObject:@(1)]) {
        return @"只响一次";
    }
    if (![self.repeatDays containsObject:@(0)]) {
        return @"每天";
    }
    NSArray *workRepeat = [self.repeatDays subarrayWithRange:NSMakeRange(0, 5)];
    NSArray *weekRepeat = [self.repeatDays subarrayWithRange:NSMakeRange(5, 2)];
    if (![workRepeat containsObject:@(0)] && ![weekRepeat containsObject:@(1)]) {
        return @"工作日";
    }
    if (![workRepeat containsObject:@(1)] && ![weekRepeat containsObject:@(0)]) {
        return @"周末";
    }
    NSMutableString *string = [NSMutableString string];
    NSArray *days = @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"];
    for (NSInteger i = 0; i < self.repeatDays.count; i++) {
        if ([self.repeatDays[i] integerValue] == 1) {
            [string appendFormat:@"%@ ", days[i]];
        }
    }
    return string;
}


- (NSString *)eventTime {
    if (!kFormatter) {
        kFormatter = [[NSDateFormatter alloc] init];
        kFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    return [kFormatter stringFromDate:self.alarmDate];
}

- (NSString *)timeInterval {
    NSMutableString *string = [NSMutableString string];
    for (NSNumber *i in self.repeatDays) {
        [string appendFormat:@"%@", i];
    }
    return [string copy];
}

- (NSUInteger)hour {
    return [[NSCalendar currentCalendar] component:NSCalendarUnitHour fromDate:self.alarmDate];
}


- (NSUInteger)minute {
    return [[NSCalendar currentCalendar] component:NSCalendarUnitMinute fromDate:self.alarmDate];
}

@end
