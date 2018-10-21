//
//  AlarmCell.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/21.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XHAlarm;

@protocol AlarmCellDelegate <NSObject>

- (void)updateAlarmEnable: (XHAlarm *) alarm;

@end



@interface AlarmCell : UITableViewCell

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier;

@property (nonatomic, weak)XHAlarm *alarm;

@property (nonatomic, weak)id<AlarmCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
