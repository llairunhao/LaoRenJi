//
//  XHChat.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/27.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHChat : NSObject<XHJSONObjectDelegate>

@property (nonatomic, copy) NSString *fromNickname;
@property (nonatomic, copy) NSString *fromAccount;

@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, copy) NSString *videoUrlString;


@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) NSUInteger chatId;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSTimeInterval timeSp;

@end

NS_ASSUME_NONNULL_END
