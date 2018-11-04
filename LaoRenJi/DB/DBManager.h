//
//  DBManager.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/20.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XHChat;

NS_ASSUME_NONNULL_BEGIN

@interface DBManager : NSObject

+ (nonnull DBManager * )sharedInstance;


- (nullable NSString *)getCurrentDevicePhone;
- (void)setCurrentDevicePhone: (NSString *)phone;

- (void)saveChats: (NSArray<XHChat *> *)chats;
- (NSArray<XHChat *>*)listOfChats;


- (void)saveCurrentDeviceLocusState: (BOOL)open;
- (BOOL)getCurrentDeviceLocusState;


@end

NS_ASSUME_NONNULL_END
