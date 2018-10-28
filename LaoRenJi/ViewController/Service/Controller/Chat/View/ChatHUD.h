//
//  ChatHUD.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/25.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatHUD : UIView

@property (readonly) UIImageView *imageView;
@property (readonly) UILabel *label;

@property (nonatomic, assign) BOOL recording;

@end

NS_ASSUME_NONNULL_END
