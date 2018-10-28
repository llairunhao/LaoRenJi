//
//  HistoryCell.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/27.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HistoryType) {
    HistoryTypeFall,
    HistoryTypeLeave,
    HistoryTypeMessage,
    HistoryTypeLowPower
};

@interface HistoryCell : UITableViewCell

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier;

@property (nonatomic, assign) HistoryType historyType;

@end

NS_ASSUME_NONNULL_END
