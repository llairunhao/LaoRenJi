//
//  ContactCell.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/20.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XHContact;

@protocol ContactCellDelegate <NSObject>

- (void)updateContact: (XHContact *)contact;

@end

@interface ContactCell : UITableViewCell

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier;

@property (nonatomic, weak) XHContact *contact;

@property (nonatomic, weak) id<ContactCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
