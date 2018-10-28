//
//  ProfileCell.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/27.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileCell : UITableViewCell

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier;

@property (nonatomic, readonly) UILabel *contentLabel;

@property (nonatomic, readonly) UIImageView *arrowView;


@end

NS_ASSUME_NONNULL_END
