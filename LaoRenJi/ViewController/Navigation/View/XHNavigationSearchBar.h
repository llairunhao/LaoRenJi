//
//  XHNavigationSearchBar.h
//  FHTower
//
//  Created by 菲凡数据科技-iOS开发 on 2018/1/2.
//  Copyright © 2018年 菲凡数据科技. All rights reserved.
//

#import "XHNavigationBar.h"

@protocol XHNavigationSearchBarDelegate<NSObject>
@optional
- (void)searchDidBegin;
- (BOOL)shouldClearText;
@required
- (void)searchText: (NSString *)text;
- (void)searchDidCancel;
@end

@interface XHNavigationSearchBar : XHNavigationBar

@property (nonatomic, readonly) UITextField *textField;
@property (nonatomic, readonly) UIButton *cancelButton;

@property (nonatomic, assign) BOOL backButtonHidden;
@property (nonatomic, assign) BOOL cancelButtonHidden;

@property (nonatomic, weak) id<XHNavigationSearchBarDelegate>delegate;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, readonly) CGRect editRect;


@end
