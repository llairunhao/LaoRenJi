//
//  DBManager+Chat.m
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/11/30.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import "DBManager+Chat.h"
#import <FMDB/FMDB.h>
#import "XHUser.h"
#import "XHChat.h"

@implementation DBManager (Chat)


- (NSArray<XHChat *> *)listOfChats {
    if (!self.chatDBQueue) {
        return @[];
    }
    NSString *simMark = [XHUser currentUser].currentSimMark;
    NSMutableArray *array = [NSMutableArray array];
    [self.chatDBQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = @"SELECT * FROM t_chat WHERE sim_mark = ? AND status < 2 ORDER BY timeSp DESC;";
        FMResultSet *rs = [db executeQuery:sql, simMark];
        while ([rs next]) {
            XHChat *chat = [[XHChat alloc] init];
            chat.chatId = [rs intForColumn:@"chat_id"];
            chat.fromAccount = [rs stringForColumn:@"from_account"];
            chat.videoUrlString = [rs stringForColumn:@"url"];
            chat.status = [rs intForColumn:@"status"];
            chat.timeSp = [rs doubleForColumn:@"timeSp"];
            [array addObject:chat];
        }
        [rs close];
    }];
    return array;
}

- (void)saveChat: (XHChat *)chat {
    if (!self.chatDBQueue) {
        return;
    }
    NSString *simMark = [XHUser currentUser].currentSimMark;
    [self.chatDBQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = @"INSERT INTO t_chat(chat_id, url, sim_mark, from_account, status, chat_type, timeSp) values(?, ?, ?, ?, ?, ?, ?);";
        BOOL result = [db executeUpdate:sql,
                       @(chat.chatId),
                       chat.videoUrlString,
                       simMark,
                       chat.fromAccount,
                       @(chat.status),
                       @(chat.type),
                       @(chat.timeSp)];
        if (!result) {
            NSLog(@"插入失败");
        }
    }];
}

- (void)saveChats:(NSArray<XHChat *> *)chats {
    if (!self.chatDBQueue) {
        return;
    }
    
    NSString *simMark = [XHUser currentUser].currentSimMark;
    [self.chatDBQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db beginTransaction];
        @try {
            NSString *sql = @"INSERT INTO t_chat(chat_id, url, sim_mark, from_account, status, chat_type, timeSp) values(?, ?, ?, ?, ?, ?, ?);";
            for (XHChat *chat in chats) {
                BOOL result = [db executeUpdate:sql,
                               @(chat.chatId),
                               chat.videoUrlString,
                               simMark,
                               chat.fromAccount,
                               @(chat.status),
                               @(chat.type),
                               @(chat.timeSp)];
                if (!result) {
                    break;
                }
            }
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
        } @finally {
            [db commit];
        }
    }];
}


- (void)removeAllChats {
    if (!self.chatDBQueue) {
        return;
    }
    XHUser *user = [XHUser currentUser];
    NSString *simMark = user.currentSimMark;
    [self.chatDBQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = @"UPDATE t_chat SET status = 2 WHERE sim_mark = ?;";
        [db executeUpdate:sql, simMark];
    }];
}

- (void)updateChatStatusById:(NSInteger)chatId {
    if (!self.chatDBQueue) {
        return;
    }
    XHUser *user = [XHUser currentUser];
    NSString *simMark = user.currentSimMark;
    [self.chatDBQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = @"UPDATE t_chat SET status = 1 WHERE sim_mark = ? AND chat_id = ?;";
        [db executeUpdate:sql, simMark, @(chatId)];
    }];
}

- (NSInteger)lastChatId {
    __block NSInteger chatId = 0;
    if (!self.chatDBQueue) {
        return 0;
    }
    XHUser *user = [XHUser currentUser];
    NSString *simMark = user.currentSimMark;
    [self.chatDBQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = @"SELECT chat_id FROM t_chat WHERE sim_mark = ? AND chat_id > 0 ORDER BY timeSp DESC LIMIT 1;";
        FMResultSet *rs = [db executeQuery:sql, simMark];
        while ([rs next]) {
            chatId = [rs intForColumn:@"chat_id"];
        }
        [rs close];
    }];
    return chatId;
}



@end
