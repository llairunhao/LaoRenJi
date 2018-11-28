//
//  SerchPositionController.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/27.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHNavigationBarController.h"

NS_ASSUME_NONNULL_BEGIN

@class AMapPOI;

typedef void(^SelectHandler)(AMapPOI *poi);

@interface SerchPositionController : XHNavigationBarController

@property (nonatomic, copy)SelectHandler selectHandler;

@property (nonatomic, copy) NSString *city;

@end

NS_ASSUME_NONNULL_END
