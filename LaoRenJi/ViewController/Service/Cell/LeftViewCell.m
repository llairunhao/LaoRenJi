//
//  LeftViewCell.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/17.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "LeftViewCell.h"

@implementation LeftViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect = self.bounds;
    rect.origin.x = 26.f;
    rect.size.width = CGRectGetWidth(self.bounds) - CGRectGetMinX(rect);
    self.textLabel.frame = rect;
}

- (void)setTicked:(BOOL)ticked {
    if (_ticked == ticked) {
        return;
    }
    _ticked = ticked;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    [[UIColor whiteColor] set];
    
    CGFloat padding = 10.f;
    CGFloat radius = 5.f;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat centerY = CGRectGetHeight(rect) / 2;
    CGFloat centerX = padding + radius;
    [path moveToPoint:CGPointMake(centerX, 0)];
    [path addLineToPoint:CGPointMake(centerX, centerY - radius)];
    [path moveToPoint:CGPointMake(centerX, centerY + radius)];
    [path addLineToPoint:CGPointMake(centerX, CGRectGetHeight(rect))];
    [path stroke];
    
    CGRect drawRect = CGRectMake(padding, centerY - radius, radius * 2, radius * 2);
    path = [UIBezierPath bezierPathWithOvalInRect: drawRect];
    [path stroke];
    
    if (self.ticked) {
        drawRect = CGRectInset(drawRect, 2, 2);
        path = [UIBezierPath bezierPathWithOvalInRect: drawRect];
        [path fill];
    }
}
@end
