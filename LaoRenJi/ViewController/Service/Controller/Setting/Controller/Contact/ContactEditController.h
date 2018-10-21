//
//  ContactEditController.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/20.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XHContact;

typedef void(^ContactHandler)(XHContact *contact);

NS_ASSUME_NONNULL_BEGIN

@interface ContactEditController : UIViewController

@property (nonatomic, strong) XHContact *contact;

@property (nonatomic, copy) ContactHandler contactHandler;

@property (nonatomic, copy) VoidHandler reloadHandler;

@end

NS_ASSUME_NONNULL_END
