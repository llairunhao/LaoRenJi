//
//  ProfileHeaderView.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/27.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileHeaderView : UIView

@property (nonatomic, readonly) UIButton *avatarButton;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
