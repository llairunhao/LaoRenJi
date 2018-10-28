//
//  XHChat.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/27.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHChat.h"

@implementation XHChat

static NSDateFormatter *kFormatter;

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

@end
