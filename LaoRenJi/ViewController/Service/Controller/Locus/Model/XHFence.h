//
//  XHFence.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/28.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHFence : NSObject<XHJSONObjectDelegate>

@property (nonatomic, assign) NSInteger fenceId;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) NSInteger radius;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, readonly) BOOL isValid;

@end

NS_ASSUME_NONNULL_END
