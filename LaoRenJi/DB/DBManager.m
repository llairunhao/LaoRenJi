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
#import <FMDB/FMDB.h>

@implementation DBManager

+ (nonnull DBManager * )sharedInstance {
    static DBManager * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DBManager alloc] init];
    });
    return sharedInstance;
}

- (FMDatabaseQueue *)chatDBQueue {
    if (!_chatDBQueue) {
        XHUser *user = [XHUser currentUser];
        NSString *dbName = [NSString stringWithFormat:@"%@.sqlite",user.account];
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSString *sqlFilePath = [path stringByAppendingPathComponent:dbName];
        _chatDBQueue = [FMDatabaseQueue databaseQueueWithPath:sqlFilePath];
        WEAKSELF;
        [_chatDBQueue inDatabase:^(FMDatabase * _Nonnull db) {
            [weakSelf createChatTable:db];
        }];
    }
    return _chatDBQueue;
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



- (void)createChatTable: (nonnull FMDatabase *)db {
    NSString *sql = @"CREATE TABLE IF NOT EXISTS t_chat \
    (\
    id INTEGER PRIMARY KEY AUTOINCREMENT,\
    chat_id INTEGER,\
    url VARCHAR(255) NOT NULL UNIQUE,\
    sim_mark VARCHAR(255) NOT NULL,\
    from_account VARCHAR(255) NOT NULL,\
    status TINYINT DEFAULT 0,\
    chat_type TINYINT DEFAULT 0,\
    timeSp timestamp DEFAULT 0\
    );";
    
    BOOL success = [db executeUpdate:sql];
    if (success) {
        success = [db executeUpdate:@"CREATE UNIQUE INDEX uk_url ON t_chat (url);"];
        if (success) {
            NSLog(@"创建索引成功");
        }else {
            NSLog(@"创建索引失败");
        }
        
    } else {
        NSLog(@"创建表失败");
    }
}

- (void)close {
    if (_chatDBQueue) {
        [_chatDBQueue close];
        _chatDBQueue = nil;
    }
}

@end
