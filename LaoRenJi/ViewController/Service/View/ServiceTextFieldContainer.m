//
//  ServiceTextFieldContainer.m
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/10/19.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import "ServiceTextFieldContainer.h"

@implementation ServiceTextFieldContainer
{
    __weak UITextField *_textField;
    __weak UILabel *_textLabel;
    __weak UIView *_line;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UITextField *textField = [[UITextField alloc] init];
        [self addSubview:textField];
        textField.textColor = [UIColor C1];
        _textField = textField;
        
        UILabel *textLabel = [[UILabel alloc] init];
        [self addSubview:textLabel];
         textLabel.textColor = [UIColor C1];
        _textLabel = textLabel;
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor C6];
        [self addSubview:line];
        _line = line;
        
        textField.font = textLabel.font;
    }
    return self;
}


- (void)layoutSubviews {
    CGRect rect = self.bounds;
    
    CGSize size = [_textLabel sizeThatFits:CGSizeZero];
    rect.origin.x = 12.f;
    if (_labelWidth > 0) {
        rect.size.width = _labelWidth;
    }else {
        rect.size.width = size.width;
    }
    _textLabel.frame = rect;
    
    rect.origin.x = CGRectGetMaxX(rect);
    rect.size.width = CGRectGetWidth(self.bounds)- CGRectGetMinX(rect) - 12.f;
    _textField.frame = rect;
    
    rect = self.bounds;
    rect.size.height = [UIView onePixel];
    rect.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(rect) - [UIView pixelAdjustOffset];
    _line.frame = rect;
}

- (UILabel *)textLabel {
    return _textLabel;
}

- (UITextField *)textField {
    return _textField;
}

- (void)setLineHidden:(BOOL)lineHidden {
    _line.hidden = lineHidden;
}

- (BOOL)lineHidden {
    return _line.hidden;
}

- (void)setFont:(UIFont *)font {
    _textField.font = font;
    _textLabel.font = font;
}

- (UIFont *)font {
    return _textLabel.font;
}

@end
