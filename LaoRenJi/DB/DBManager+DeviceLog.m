//
//  DBManager+DeviceLog.m
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/12/5.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import "DBManager+DeviceLog.h"
#import <FMDB/FMDB.h>
#import "XHUser.h"

@implementation DBManager (DeviceLog)

- (void)saveCurrentDeviceLog:(NSInteger)type timeSp:(NSTimeInterval)timeSp {
    if (!self.chatDBQueue) {
        return;
    }
    NSString *simMark = [XHUser currentUser].currentSimMark;
    [self.chatDBQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = @"INSERT INTO t_device_log(sim_mark, log_type, timeSp) values(?, ?, ?);";
        BOOL result = [db executeUpdate:sql,
                       simMark,
                       @(type),
                       @(timeSp)];
        if (!result) {
            NSLog(@"插入失败");
        }
    }];
}

- (void)removeCurrentDeviceAllLogs {
    if (!self.chatDBQueue) {
        return;
    }
    [self.chatDBQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = @"DELETE FROM t_device_log;";
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"删除失败");
        }
    }];
}

- (NSArray<NSDictionary *> *)listOfCurrentDeviceLogs {
    if (!self.chatDBQueue) {
        return @[];
    }
    NSString *simMark = [XHUser currentUser].currentSimMark;
    NSMutableArray *array = [NSMutableArray array];
    [self.chatDBQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = @"SELECT log_type, timeSp FROM t_device_log WHERE sim_mark = ?  ORDER BY timeSp DESC;";
        FMResultSet *rs = [db executeQuery:sql, simMark];
        while ([rs next]) {
            NSInteger type = [rs intForColumn:@"log_type"];
            NSTimeInterval timeSp = [rs doubleForColumn:@"timeSp"];
            NSDictionary *dict = @{@"type": @(type), @"timeSp": @(timeSp)};
            [array addObject:dict];
        }
        [rs close];
    }];
    return array;
}

- (void)updateAllCurrentDeviceLogStatus {
    if (!self.chatDBQueue) {
        return;
    }
    XHUser *user = [XHUser currentUser];
    NSString *simMark = user.currentSimMark;
    [self.chatDBQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = @"UPDATE t_device_log SET status = 1 WHERE sim_mark = ?;";
        [db executeUpdate:sql, simMark];
    }];
}

- (NSArray<NSDictionary *> *)listOfUnreadCurrentDeviceLogs {
    if (!self.chatDBQueue) {
        return @[];
    }
    NSString *simMark = [XHUser currentUser].currentSimMark;
    NSMutableArray *array = [NSMutableArray array];
    [self.chatDBQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = @"SELECT log_type, timeSp FROM t_device_log WHERE sim_mark = ? AND status = 0 ORDER BY timeSp DESC;";
        FMResultSet *rs = [db executeQuery:sql, simMark];
        while ([rs next]) {
            NSInteger type = [rs intForColumn:@"log_type"];
            NSTimeInterval timeSp = [rs doubleForColumn:@"timeSp"];
            NSDictionary *dict = @{@"type": @(type), @"timeSp": @(timeSp)};
            [array addObject:dict];
        }
        [rs close];
    }];
    return array;
}

@end
