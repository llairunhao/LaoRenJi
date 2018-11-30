//
//  DBManager.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/20.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabaseQueue;

NS_ASSUME_NONNULL_BEGIN

@interface DBManager : NSObject

+ (nonnull DBManager * )sharedInstance;

@property (nonatomic, strong, nullable) FMDatabaseQueue *chatDBQueue;

- (void)close;


- (nullable NSString *)getCurrentDevicePhone;
- (void)setCurrentDevicePhone: (NSString *)phone;



- (void)saveCurrentDeviceLocusState: (BOOL)open;
- (BOOL)getCurrentDeviceLocusState;


- (NSArray<NSDictionary *> *)listOfCurrentDeviceLogs;
- (void)saveCurrentDeviceLog: (NSInteger)type timeSp: (NSTimeInterval)timeSp;
- (void)removeCurrentDeviceAllLogs;

@end

NS_ASSUME_NONNULL_END
