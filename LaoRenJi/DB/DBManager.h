//
//  DBManager.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/20.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBManager : NSObject

+ (nonnull DBManager * )sharedInstance;


- (nullable NSString *)getCurrentDevicePhone;
- (void)setCurrentDevicePhone: (NSString *)phone;

@end

NS_ASSUME_NONNULL_END
