//
//  AlarmTimeCell.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/21.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "AlarmTimeCell.h"

@implementation AlarmTimeCell
{
    __weak UIImageView *_left;
    __weak UIImageView *_right;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        _left = imageView;
        
        imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        _right = imageView;
    }
    return self;
}

//- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
//    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
//    if (self) {
//
//    }
//    return self;
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size1 = [_left sizeThatFits:CGSizeZero];
    CGSize size2 = [_right sizeThatFits:CGSizeZero];
    
    CGFloat padding = (CGRectGetWidth(self.bounds) - size1.width - size2.width - 2.f) / 2;
    
    
    CGRect rect = self.bounds;
    rect.origin.x = padding;
    rect.origin.y = (CGRectGetHeight(self.bounds) - size1.height ) / 2;
    rect.size = size1;
    _left.frame = rect;
    
    rect.origin.x = CGRectGetMaxX(rect) + 2;
    rect.origin.y = (CGRectGetHeight(self.bounds) - size2.height ) / 2;
    rect.size = size2;
    _right.frame = rect;
}

- (void)setTime:(NSInteger)time {
    _time = time;
  
    if (time < 0) {
        return;
    }
    _right.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", @(time % 10)]];
    _left.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", @(time / 10)]];
}

- (void)prepareForReuse {
    self.time = -1;
}

@end
