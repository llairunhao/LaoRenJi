//
//  DBManager.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/20.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "DBManager.h"
#import "XHUser.h"
#import "XHDevice.h"
#import "XHChat.h"

@implementation DBManager

+ (nonnull DBManager * )sharedInstance {
    static DBManager * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DBManager alloc] init];
    });
    return sharedInstance;
}

- (NSString *)getCurrentDevicePhone {
    XHUser *user = [XHUser currentUser];
    NSString *simMark = user.currentSimMark;
    if (!simMark) {
        return @"";
    }
    NSString *key = [NSString stringWithFormat:@"%@_%@",user.account, simMark];
    return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}

- (void)setCurrentDevicePhone:(NSString *)phone {
    XHUser *user = [XHUser currentUser];
    NSString *simMark = user.currentSimMark;
    if (!simMark) {
        return;
    }
    NSString *key = [NSString stringWithFormat:@"%@_%@",user.account, simMark];
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveChats:(NSArray<XHChat *> *)chats {
    XHUser *user = [XHUser currentUser];
    NSString *simMark = user.currentSimMark;
    if (!simMark) {
        return;
    }
    NSString *key = [NSString stringWithFormat:@"%@_%@_chats",user.account, simMark];
    if (chats.count == 0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:chats.count];
    for (XHChat *chat in chats) {
        NSDictionary *dict = @{
                               @"video" : chat.videoUrlString,
                               @"from" : chat.fromNickname,
                               @"date" : chat.dateString
                               };
        [array addObject:dict];
    }
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[array copy] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray<XHChat *>*)listOfChats {
    XHUser *user = [XHUser currentUser];
    NSString *simMark = user.currentSimMark;
    if (!simMark) {
        return @[];
    }
    NSString *key = [NSString stringWithFormat:@"%@_%@_chats",user.account, simMark];
    NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:key];
    NSMutableArray *chats = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dict in array) {
        XHChat *chat = [[XHChat alloc] init];
        chat.videoUrlString = dict[@"video"];
        chat.fromNickname = dict[@"from"];
        chat.dateString = dict[@"date"];
        [chats addObject:chat];
    }
    return [chats copy];
}

- (void)saveCurrentDeviceLocusState:(BOOL)open {
    XHUser *user = [XHUser currentUser];
    NSString *simMark = user.currentSimMark;
    if (!simMark) {
        return;
    }
    NSString *key = [NSString stringWithFormat:@"%@_%@_locus",user.account, simMark];
    [[NSUserDefaults standardUserDefaults] setBool:open forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"%@", @([self getCurrentDeviceLocusState]));
}

- (BOOL)getCurrentDeviceLocusState {
    XHUser *user = [XHUser currentUser];
    NSString *simMark = user.currentSimMark;
    if (!simMark) {
        return false;
    }
    NSString *key = [NSString stringWithFormat:@"%@_%@_locus",user.account, simMark];
    BOOL result = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    NSLog(@"%@", @(result));
    return result;
}


- (void)saveCurrentDeviceLog:(NSInteger)type timeSp:(NSTimeInterval)timeSp {
    XHUser *user = [XHUser currentUser];
    NSString *simMark = user.currentSimMark;
    if (!simMark) {
        return;
    }
    NSString *key = [NSString stringWithFormat:@"%@_%@_log",user.account, simMark];
    NSDictionary *value = @{@"type": @(type), @"timeSp": @(timeSp)};
    NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:key];
    if (!array) {
        array = @[value];
    }else {
        NSMutableArray *array2 = [NSMutableArray arrayWithArray:array];
        [array2 insertObject:value atIndex:0];
        array = [array2 copy];
    }
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (NSArray<NSDictionary *> *)listOfCurrentDeviceLogs {
    XHUser *user = [XHUser currentUser];
    NSString *simMark = user.currentSimMark;
    if (!simMark) {
        return @[];
    }
    NSString *key = [NSString stringWithFormat:@"%@_%@_log",user.account, simMark];
    NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:key];
    if (!array) {
        return @[];
    }
    return array;
}

- (void)removeCurrentDeviceAllLogs {
    XHUser *user = [XHUser currentUser];
    NSString *simMark = user.currentSimMark;
    if (!simMark) {
        return;
    }
    NSString *key = [NSString stringWithFormat:@"%@_%@_log",user.account, simMark];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
