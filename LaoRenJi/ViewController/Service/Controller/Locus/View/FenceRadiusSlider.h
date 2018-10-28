//
//  FenceRadiusSlider.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/28.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FenceRadiusSlider : UIView

@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) NSInteger value;


@property (nonatomic, assign) NSInteger maxValue;
@property (nonatomic, assign) NSInteger minValue;

@property (nonatomic, copy) IntegerHandler handler;

@end

NS_ASSUME_NONNULL_END
