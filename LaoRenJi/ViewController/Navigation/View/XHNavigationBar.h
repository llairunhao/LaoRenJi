//
//  XHNavigationBar.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/14.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHNavigationBar : UIView

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UIButton *backButton;
@property (nonatomic, copy) VoidHandler backHandler;


@property (nonatomic, readonly) NSArray<UIView *> *rightItems;
@property (nonatomic, readonly) NSArray<UIView *> *leftItems;

- (void)addRigthItem: (UIView *)rightItem;
- (void)addLeftItem: (UIView *)leftItem;
- (void)removeAllItems;


@end

NS_ASSUME_NONNULL_END
