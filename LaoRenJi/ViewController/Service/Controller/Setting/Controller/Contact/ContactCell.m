//
//  ContactCell.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/20.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "ContactCell.h"
#import "XHContact.h"

@implementation ContactCell
{
    __weak UIButton *_switchButton;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageView.image = [UIImage imageNamed:@"contact_avatar"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:button];
        [button setImage:[UIImage imageNamed:@"SWITCH"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"SWITCHON"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(switchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _switchButton = button;
        
        self.textLabel.textColor = [UIColor C1];
        self.detailTextLabel.textColor = [UIColor C3];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    CGSize size1 = [self.textLabel sizeThatFits:CGSizeZero];
//    CGSize size2 = [self.detailTextLabel sizeThatFits:CGSizeZero];
//    CGSize size3 = [self.imageView sizeThatFits:CGSizeZero];

    CGSize size = [_switchButton sizeThatFits:CGSizeZero];
    CGRect rect = self.bounds;
    rect.origin.x = CGRectGetWidth(rect) - size.width - 12.f;
    rect.origin.y = (CGRectGetHeight(rect) - size.height ) / 2;
    rect.size = size;
    _switchButton.frame = rect;
}

- (void)switchButtonClick: (UIButton *)button {
    self.contact.isAutoAnswer = !button.selected;
    [self.delegate updateContact:self.contact];
}

- (void)setContact:(XHContact *)contact {
    _contact = contact;
    self.textLabel.text = contact.name;
    self.detailTextLabel.text = contact.phone;
    _switchButton.selected = contact.isAutoAnswer;
}

@end
