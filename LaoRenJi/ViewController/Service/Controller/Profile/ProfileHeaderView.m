//
//  ProfileHeaderView.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/27.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "ProfileHeaderView.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "XHUser.h"

#define kAvatarWH 80.f

@implementation ProfileHeaderView
{
    __weak UIImageView *_imageView;
    __weak UIButton *_avatarButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BACK"]];
        [self addSubview:imageView];
        _imageView = imageView;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CAShapeLayer *mask = [[CAShapeLayer alloc] init];
        mask.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, kAvatarWH, kAvatarWH)].CGPath;
        button.layer.mask = mask;
        [self addSubview:button];
        _avatarButton = button;
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [_imageView sizeThatFits:size];
}

- (void)layoutSubviews {
    
    _imageView.frame = self.bounds;
    
    CGFloat avatarWH = kAvatarWH;
    CGFloat totalH = avatarWH;
    CGFloat y = (CGRectGetHeight(self.bounds) - totalH ) / 3;
    CGFloat x = (CGRectGetWidth(self.bounds) - avatarWH ) / 2;
    _avatarButton.frame = CGRectMake(x, y, avatarWH, avatarWH);
}

- (void)reloadData {
    XHUser *user = [XHUser currentUser];
    [_avatarButton sd_setBackgroundImageWithURL:user.avatarURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_avatar_placeholder"]];

    
}

@end
