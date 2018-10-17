//
//  XHKeyboardObserver.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/14.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHKeyboardObserver : NSObject

@property (nonatomic, weak) UIView *mainView;

@property (nonatomic, weak) UIView *editView;

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak, nullable) UIView *inputBar;
@end

NS_ASSUME_NONNULL_END
