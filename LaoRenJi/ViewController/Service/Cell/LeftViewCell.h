//
//  LeftViewCell.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/17.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LeftViewCell : UITableViewCell

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier;

@property (nonatomic, assign) BOOL ticked;

@end

NS_ASSUME_NONNULL_END
