//
//  XHFence.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/28.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHFence.h"

@implementation XHFence

- (instancetype)init {
    self = [super init];
    if (self) {
        self.latitude = 999999;
        self.longitude = 999999;
        self.radius = 500;
    }
    return self;
}

- (BOOL)isValid {
    return self.longitude != 999999 && self.latitude != 999999;
}

- (instancetype)initWithJSON:(XHJSON *)JSON {
    self = [super init];
    if (self) {
        [self setupWithJSON:JSON];
    }
    return self;
}

- (void)setupWithJSON:(XHJSON *)JSON {
    self.fenceId    =   [JSON JSONForKey:@"id"].integerValue;
    self.longitude  =   [JSON JSONForKey:@"longitude"].doubleValue;
    self.latitude   =   [JSON JSONForKey:@"latitude"].doubleValue;
    self.radius     =   [JSON JSONForKey:@"radius"].unsignedIntegerValue;
    self.name       =   [JSON JSONForKey:@"enclosureName"].stringValue;
}
@end
