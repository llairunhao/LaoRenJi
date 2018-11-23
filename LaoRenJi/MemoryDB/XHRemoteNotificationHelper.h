//
//  XHRemoteNotificationHelper.h
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/11/21.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHRemoteNotificationHelper : NSObject

+ (void)handleNotificaion: (NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
