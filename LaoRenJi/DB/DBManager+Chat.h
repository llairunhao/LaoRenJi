//
//  DBManager+Chat.h
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/11/30.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import "DBManager.h"

@class XHChat;

NS_ASSUME_NONNULL_BEGIN

@interface DBManager (Chat)

- (void)saveChats: (NSArray<XHChat *> *)chats;
- (NSArray<XHChat *>*)listOfChats;
- (void)saveChat: (XHChat *)chat;
- (void)removeAllChats;
- (NSInteger)lastChatId;
- (void)updateChatStatusById: (NSInteger)chatId;

@end

NS_ASSUME_NONNULL_END
