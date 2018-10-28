//
//  FenceRadiusLabel.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/28.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "FenceRadiusLabel.h"

@implementation FenceRadiusLabel
{
    __weak UILabel *_textLabel;
    __weak UIView *_arrowView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:11];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"1000m";
        label.backgroundColor = [UIColor EC1];
        [self addSubview:label];
        _textLabel = label;
        
        UIView *arrowView = [[UIView alloc] init];
        arrowView.backgroundColor = [UIColor EC1];
        [self addSubview:arrowView];
        _arrowView = arrowView;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointZero];
        [path addLineToPoint:CGPointMake([self arrowSize].width, 0)];
        [path addLineToPoint:CGPointMake([self arrowSize].width / 2, [self arrowSize].height)];
        [path closePath];
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.path = path.CGPath;
        _arrowView.layer.mask = layer;
        
        CGRect rect = CGRectMake(0, 0, [self textSize].width, [self textSize].height);
        path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:4];
        layer = [[CAShapeLayer alloc] init];
        layer.path = path.CGPath;
        _textLabel.layer.mask = layer;
    }
    return self;
}

- (void)layoutSubviews {
    
    CGRect rect1 = CGRectZero;
    CGRect rect2 = CGRectZero;
    
    rect1.origin.x = (CGRectGetWidth(self.bounds) - [self textSize].width) / 2;
    rect2.origin.x = (CGRectGetWidth(self.bounds) - [self arrowSize].width ) / 2;
    rect2.origin.y = CGRectGetHeight(self.bounds) - [self arrowSize].height;
    rect1.origin.y = CGRectGetMinY(rect2) - [self textSize].height;
    rect1.size = [self textSize];
    rect2.size = [self arrowSize];
    
    _textLabel.frame = rect1;
    _arrowView.frame = rect2;

}


- (void)setText:(NSString *)text {
    _textLabel.text = text;
}

- (NSString *)text {
    return _textLabel.text;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize size1 = [self textSize];
    CGSize size2 = [self arrowSize];
    return CGSizeMake(size1.width, size1.height + size2.height);
}

- (CGSize)textSize {
    return CGSizeMake(50, 18);
}

- (CGSize)arrowSize {
    return CGSizeMake(8, 6);
}

@end
