//
//  FenceRadiusSlider.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/28.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "FenceRadiusSlider.h"
#import "FenceRadiusLabel.h"

#define kPointRadius 8

@implementation FenceRadiusSlider
{
    __weak UIView *_point;
    __weak UIView *_line;
    __weak FenceRadiusLabel *_label;
    __weak UIView *_bgView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self addSubview:bgView];
        _bgView = bgView;
        
        UIView *point = [[UIView alloc] init];
        point.backgroundColor = [UIColor EC1];
        point.layer.cornerRadius = kPointRadius;
        [self addSubview:point];
        _point = point;
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor EC1];
        line.layer.cornerRadius = 1;
        [self addSubview:line];
        _line = line;
        
        FenceRadiusLabel *label = [[FenceRadiusLabel alloc] initWithFrame:CGRectZero];
        [self addSubview:label];
        _label = label;
    
        UIPanGestureRecognizer *ges = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
        [self addGestureRecognizer:ges];
    }
    return self;
}

- (void)layoutSubviews {
    _bgView.frame = self.bounds;
    
    CGSize size = [_label sizeThatFits:CGSizeZero];
    CGFloat vPadding = (kPointRadius * 2 + size.height ) / 2;
    
    CGRect rect = self.bounds;
    rect.origin.x = size.width / 2;
    rect.size.width -= (size.width + kPointRadius + 8);
    rect.origin.y = CGRectGetHeight(self.bounds) - vPadding - kPointRadius;
    rect.size.height = 2.f;
    _line.frame = rect;
    
    rect.size = CGSizeMake(kPointRadius * 2, kPointRadius * 2);
    rect.origin.x = CGRectGetWidth(_line.frame) * _scale + CGRectGetMinX(_line.frame);
    rect.origin.y = (CGRectGetHeight(_line.frame) - CGRectGetHeight(rect)) / 2 + CGRectGetMinY(_line.frame);
    _point.frame = rect;
    
    rect.size = size;
    rect.origin.y = vPadding;
    rect.origin.x = (CGRectGetWidth(_point.frame) - CGRectGetWidth(rect)) / 2 + CGRectGetMinX(_point.frame);
    _label.frame = rect;
}

- (void)panView: (UIPanGestureRecognizer *)ges {
    CGPoint point = [ges locationInView:_line];

    CGFloat x = MAX(0, point.x);
    x = MIN(CGRectGetWidth(_line.frame), x);
    self.scale = x / CGRectGetWidth(_line.frame);

    if (ges.state == UIGestureRecognizerStateEnded) {
        self.handler([self value]);
    }
}

- (void)setScale:(CGFloat)scale {
    _scale = scale;
    _value = (_maxValue - _minValue) * _scale + _minValue;
    _label.text = [NSString stringWithFormat:@"%@m", @(_value)];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setValue:(NSInteger)value {
   
    _value = value;
    CGFloat padding = (value - _minValue );
    CGFloat total = (_maxValue - _minValue);
    _scale = padding / total;
    _label.text = [NSString stringWithFormat:@"%@m", @(_value)];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}



@end
