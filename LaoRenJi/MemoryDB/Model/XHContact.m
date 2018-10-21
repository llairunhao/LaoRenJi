//
//  XHContact.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/20.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHContact.h"

@implementation XHContact

- (instancetype)initWithJSON:(XHJSON *)JSON {
    self = [super init];
    if (self) {
        [self setupWithJSON:JSON];
    }
    return self;
}

- (void)setupWithJSON:(XHJSON *)JSON {
    self.name           =   [JSON JSONForKey:@"contactName"].stringValue;
    self.phone          =   [JSON JSONForKey:@"contactPhone"].stringValue;
    self.contactId      =   [JSON JSONForKey:@"id"].unsignedIntegerValue;
    self.isAutoAnswer   =   [JSON JSONForKey:@"isAutoAnswer"].boolValue;
    self.isUrgent       =   [JSON JSONForKey:@"isUrgent"].boolValue;
    self.urgentLevel    =   [JSON JSONForKey:@"urgentLevel"].unsignedIntegerValue;
}

@end
