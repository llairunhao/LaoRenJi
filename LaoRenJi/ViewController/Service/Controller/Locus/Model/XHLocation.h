//
//  XHLocation.h
//  LaoRenJi
//
//  Created by RunHao on 2018/11/3.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHLocation : NSObject<XHJSONObjectDelegate>

@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;

@end

NS_ASSUME_NONNULL_END
