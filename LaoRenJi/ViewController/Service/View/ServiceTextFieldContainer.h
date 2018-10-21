//
//  ServiceTextFieldContainer.h
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/10/19.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ServiceTextFieldContainer : UIView

@property (readonly) UITextField *textField;
@property (readonly) UILabel *textLabel;

@property (nonatomic, assign) BOOL lineHidden;
@property (nonatomic, strong) UIFont *font;

@property (nonatomic, assign) CGFloat labelWidth;

@end

NS_ASSUME_NONNULL_END
