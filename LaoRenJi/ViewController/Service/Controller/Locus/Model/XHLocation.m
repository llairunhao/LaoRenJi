//
//  XHLocation.m
//  LaoRenJi
//
//  Created by RunHao on 2018/11/3.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHLocation.h"

@implementation XHLocation

- (instancetype)initWithJSON:(XHJSON *)JSON {
    self = [super init];
    if (self) {
        [self setupWithJSON:JSON];
    }
    return self;
}

- (void)setupWithJSON:(XHJSON *)JSON {
    self.longitude  =   [JSON JSONForKey:@"longitude"].doubleValue;
    self.latitude   =   [JSON JSONForKey:@"latitude"].doubleValue;
}

@end
