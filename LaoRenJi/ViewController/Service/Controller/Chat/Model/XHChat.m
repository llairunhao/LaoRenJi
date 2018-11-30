//
//  XHChat.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/27.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHChat.h"
#import "XHUser.h"
#import "XHDevice.h"

@implementation XHChat

static NSDateFormatter *kFormatter;


- (instancetype)initWithJSON:(XHJSON *)JSON {
    self = [super init];
    if (self) {
        [self setupWithJSON:JSON];
    }
    return self;
}

- (void)setupWithJSON:(XHJSON *)JSON {
    self.fromAccount    =   [JSON JSONForKey:@"account"].stringValue;
    self.chatId         =   [JSON JSONForKey:@"id"].unsignedIntegerValue;
    self.status         =   [JSON JSONForKey:@"status"].integerValue;
    self.timeSp         =   [JSON JSONForKey:@"createTime"].doubleValue / 1000;
    self.type           =   [JSON JSONForKey:@"type"].integerValue;
    self.videoUrlString =   [JSON JSONForKey:@"url"].stringValue;
}

- (NSString *)dateString {
    if (_dateString) {
        return _dateString;
    }
    if (!kFormatter) {
        kFormatter = [[NSDateFormatter alloc] init];
        kFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    NSString *string = [kFormatter stringFromDate:self.date];
    _dateString = [string stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
    return _dateString;
}

- (NSDate *)date {
    if (_date) {
        return _date;
    }
    _date = [NSDate dateWithTimeIntervalSince1970:self.timeSp];
    return _date;
}

- (NSString *)fromNickname {
    if (!_fromNickname) {
        if ([self.fromAccount isEqualToString:[XHUser currentUser].account]) {
            _fromNickname = @"我";
        }else {
            _fromNickname = [XHUser currentUser].currentDevice.name;
        }
    }
    return _fromNickname;
}


- (NSTimeInterval)timeSp {
    if (_timeSp == 0) {
        if (_date) {
            _timeSp = [_date timeIntervalSince1970];
        }else {
            _timeSp = [[NSDate date] timeIntervalSince1970];
        }
    }
    return _timeSp;
}


@end
