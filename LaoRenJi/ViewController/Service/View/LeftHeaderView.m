//
//  LeftHeaderView.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/17.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "LeftHeaderView.h"
#import <SDWebImage/UIButton+WebCache.h>

#import "XHUser.h"

#define kAvatarWH 80.f

@implementation LeftHeaderView
{
    __weak UIButton *_avatarButton;
    __weak UIButton *_nameButton;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CAShapeLayer *mask = [[CAShapeLayer alloc] init];
        mask.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, kAvatarWH, kAvatarWH)].CGPath;
        button.layer.mask = mask;
        [self addSubview:button];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _avatarButton = button;
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button  setTitle:@"未登录" forState: UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _nameButton = button;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews {
    
    CGFloat avatarWH = kAvatarWH;
    CGFloat nameH = [_nameButton sizeThatFits:CGSizeZero].height;
    CGFloat totalH = avatarWH + nameH;
    CGFloat y = (CGRectGetHeight(self.bounds) - totalH ) / 2;
    CGFloat x = (CGRectGetWidth(self.bounds) - avatarWH ) / 2;
    _avatarButton.frame = CGRectMake(x, y, avatarWH, avatarWH);
    _nameButton.frame = CGRectMake(x, CGRectGetMaxY(_avatarButton.frame), avatarWH, nameH);
}

- (void)reloadData {
    XHUser *user = [XHUser currentUser];
    [_avatarButton sd_setBackgroundImageWithURL:user.avatarURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_avatar_placeholder"]];
    [_nameButton setTitle:user.nickname forState:UIControlStateNormal];
                                                                        
}

- (void)buttonClick: (UIButton *)button {
    if (self.clickHandler) {
        self.clickHandler();
    }
}

@end
