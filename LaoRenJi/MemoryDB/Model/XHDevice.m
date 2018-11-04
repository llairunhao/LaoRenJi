//
//  XHDevice.m
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/10/19.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import "XHDevice.h"

@implementation XHDevice

- (instancetype)initWithJSON:(XHJSON *)JSON {
    self = [super init];
    if (self) {
        [self setupWithJSON:JSON];
    }
    return self;
}

- (void)setupWithJSON:(XHJSON *)JSON {
    self.deviceId   =   [JSON JSONForKey:@"id"].unsignedIntegerValue;
    self.name       =   [JSON JSONForKey:@"mobileName"].stringValue;
    self.admin      =   [JSON JSONForKey:@"isAdmin"].boolValue;
    self.simMark    =   [JSON JSONForKey:@"simMark"].stringValue;
    self.appAccount =   [JSON JSONForKey:@"appAccount"].stringValue;
}
@end
