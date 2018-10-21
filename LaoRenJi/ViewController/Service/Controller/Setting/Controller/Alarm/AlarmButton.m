//
//  AlarmButton.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/21.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "AlarmButton.h"

@implementation AlarmButton
{
    __weak UILabel *_leftLabel;
    __weak UILabel *_rightLabel;
    __weak UIImageView *_arrowView;
    __weak UIView *_line;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:textLabel];
        _leftLabel = textLabel;
        
        textLabel = [[UILabel alloc] init];
        textLabel.font = [UIFont systemFontOfSize:16];
        textLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:textLabel];
        _rightLabel = textLabel;
        
        UIImageView *arrowView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        [self addSubview:arrowView];
        _arrowView = arrowView;
        
        UIView *line = [[UIView alloc] init];
        [self addSubview:line];
        line.backgroundColor = [UIColor C6];
        _line = line;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect = self.bounds;
    rect.origin.x = 12.f;
    CGSize size = [_leftLabel sizeThatFits:CGSizeZero];
    rect.size.width = size.width;
    _leftLabel.frame = rect;
    
    size = [_arrowView sizeThatFits:CGSizeZero];
    rect.origin.x = CGRectGetWidth(self.bounds) - 12.f - size.width;
    rect.origin.y = (CGRectGetHeight(self.bounds) - size.height) / 2;
    rect.size = size;
    _arrowView.frame = rect;
    
    rect = self.bounds;
    rect.size.width = CGRectGetMinX(_arrowView.frame) - CGRectGetMaxX(_leftLabel.frame) - 24.f;
    rect.origin.x = CGRectGetMaxX(_leftLabel.frame) + 12.f;
    _rightLabel.frame = rect;
    
    rect = self.bounds;
    rect.size.height = [UIView onePixel];
    rect.origin.y = CGRectGetHeight(self.bounds) - [UIView onePixel] + [UIView pixelAdjustOffset];
    _line.frame = rect;
}

- (UILabel *)leftLabel {
    return _leftLabel;
}

- (UILabel *)rightLabel {
    return _rightLabel;
}

@end
