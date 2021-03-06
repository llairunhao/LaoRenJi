//
//  RegisterViewController.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/14.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHNavigationBarController.h"


NS_ASSUME_NONNULL_BEGIN

@interface RegisterViewController : XHNavigationBarController

@property (readonly) NSArray <NSString *> *placeholders;

@property (readonly) NSArray <UITextField *> *textFields;

- (BOOL)secureTextEntryAtIndex: (NSInteger)index;

- (void)actionButtonClick: (UIButton *)button;

- (BOOL)codeButtonHidden;

@end

NS_ASSUME_NONNULL_END
