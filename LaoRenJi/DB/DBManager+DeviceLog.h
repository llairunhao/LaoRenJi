//
//  DBManager+DeviceLog.h
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/12/5.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import "DBManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBManager (DeviceLog)

- (NSArray<NSDictionary *> *)listOfCurrentDeviceLogs;
- (void)saveCurrentDeviceLog: (NSInteger)type timeSp: (NSTimeInterval)timeSp;
- (void)removeCurrentDeviceAllLogs;
- (NSArray<NSDictionary *> *)listOfUnreadCurrentDeviceLogs;
- (void)updateAllCurrentDeviceLogStatus;
 
@end

NS_ASSUME_NONNULL_END
