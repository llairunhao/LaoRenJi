//
//  ChatHUD.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/25.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "ChatHUD.h"

@implementation ChatHUD
{
    __weak UIImageView *_imageView;
    __weak UILabel *_label;
    __weak UIView *_contentView;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *contentView = [[UIView alloc] init];
        contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        contentView.layer.cornerRadius = 4;
        [self addSubview:contentView];
        _contentView = contentView;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        _imageView = imageView;
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _label = label;
    }
    return self;
}

- (void)layoutSubviews {
    _contentView.frame = self.bounds;
    
    CGSize size = [_label sizeThatFits:CGSizeZero];
    CGRect rect = CGRectZero;
    rect.origin.y = CGRectGetWidth(self.bounds) - 12.f - size.height;
    rect.origin.x = (CGRectGetWidth(self.bounds) - size.width ) / 2;;
    rect.size = size;
    _label.frame = rect;
    
    size = [_imageView sizeThatFits:CGSizeZero];
    rect.origin.y = (CGRectGetHeight(self.bounds) - size.height ) / 2;
    rect.origin.x = (CGRectGetWidth(self.bounds) - size.width ) / 2;
    rect.size = size;
    _imageView.frame = rect;
}

- (CGSize)sizeThatFits:(CGSize)size {
   
    CGSize size1 = [_imageView sizeThatFits:CGSizeZero];
    CGSize size2 = [_label sizeThatFits:CGSizeZero];
    
    CGFloat height = size1.height + size2.height + 8 + 24;
    CGFloat width = size2.width + 24;
    CGFloat wh = MAX(height, width);
    return CGSizeMake(wh, wh);
}


- (UIImageView *)imageView {
    return _imageView;
}

- (UILabel *)label {
    return _label;
}



@end
