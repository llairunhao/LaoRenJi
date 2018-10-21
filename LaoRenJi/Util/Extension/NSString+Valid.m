//
//  NSString+Valid.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/20.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "NSString+Valid.h"

@implementation NSString (Valid)

- (BOOL)isPhoneNumber {
    if (self.length == 11 && [self characterAtIndex:0] == '1') {
        NSString *string = [self stringByTrimmingCharactersInSet: [NSCharacterSet decimalDigitCharacterSet]];
        return string.length == 0;
    }
    return false;
}

- (BOOL)isNumberOnly {
    NSString *string = [self stringByTrimmingCharactersInSet: [NSCharacterSet decimalDigitCharacterSet]];
    return string.length == 0;
}


- (BOOL)isAlphaNumeric  {
    NSString *regex = @"^[A-Za-z0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:self];
}

@end
