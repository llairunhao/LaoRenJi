//
//  XHAlarm.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/21.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHAlarm : NSObject<XHJSONObjectDelegate>

+ (instancetype)emptyAlarm;

@property (nonatomic, assign)NSUInteger alarmId;

@property (nonatomic, copy)NSString *eventName;
@property (nonatomic, copy)NSString *eventContent;
@property (nonatomic, copy)NSString *simMark;

@property (nonatomic, strong) NSMutableArray<NSNumber *> *repeatDays;
@property (nonatomic, strong) NSDate *alarmDate;

@property (nonatomic, assign)BOOL enable;

@property (nonatomic, readonly) NSString *eventTime;
@property (nonatomic, readonly) NSString *timeInterval;
@property (nonatomic, readonly) NSString *repeatDay;
@property (nonatomic, readonly) NSUInteger hour;
@property (nonatomic, readonly) NSUInteger minute;


- (XHAlarm *)copy;

@end

NS_ASSUME_NONNULL_END
