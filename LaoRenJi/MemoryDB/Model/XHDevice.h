//
//  XHDevice.h
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/10/19.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHDevice : NSObject<XHJSONObjectDelegate>

@property (nonatomic, assign) NSUInteger deviceId;
@property (nonatomic, assign) BOOL admin;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *simMark;
@property (nonatomic, copy) NSString *appAccount;
@property (nonatomic, assign) BOOL online;


@end

NS_ASSUME_NONNULL_END
