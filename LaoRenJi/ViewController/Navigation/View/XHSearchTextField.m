//
//  FHTSearchBar.m
//  FHTower
//
//  Created by 菲凡数据科技-iOS开发 on 2018/1/3.
//  Copyright © 2018年 菲凡数据科技. All rights reserved.
//

#import "XHSearchTextField.h"

@implementation XHSearchTextField
{
    __weak UIImageView *_placeholderIcon;
    __weak UIView *_bgView;
    __weak UITextField *_textField;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor C7];
        bgView.layer.cornerRadius = 4;
        [self addSubview:bgView];
        _bgView = bgView;
        
        UIImageView *placeholderIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search_default"]];
        [self addSubview:placeholderIcon];
        _placeholderIcon = placeholderIcon;
        
        
        UITextField *textField = [[UITextField alloc] init];
        textField.backgroundColor = [UIColor clearColor];
        textField.font = [UIFont systemFontOfSize:14];
        textField.textColor = [UIColor C1];
        textField.returnKeyType = UIReturnKeySearch;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        [self addSubview:textField];
        _textField = textField;
        
        self.placeholder = @"请输入您要查找内容的关键字";
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    CGFloat barWidth =  CGRectGetWidth(rect);
    CGFloat barHeight = CGRectGetHeight(rect);

    _bgView.frame = CGRectMake(0, 0, barWidth, barHeight);
    
    CGSize size = [_placeholderIcon sizeThatFits:CGSizeZero];
    CGRect iconFrame = CGRectZero;
    iconFrame.origin.y = (barHeight - size.height) * 0.5;
    iconFrame.origin.x = 10;
    iconFrame.size = size;
    _placeholderIcon.frame = iconFrame;
    
    _textField.frame = CGRectMake(CGRectGetMaxX(iconFrame) + 4.f,
                                  0,
                                  barWidth - CGRectGetMaxX(iconFrame) - 4.f * 2,
                                  barHeight);
}

- (void)setText:(NSString *)text {
    _textField.text = text;
}

- (NSString *)text {
    return _textField.text;
}

- (void)setPlaceholder:(NSString *)placeholder {
    NSDictionary *dict = @{ NSFontAttributeName : [UIFont systemFontOfSize:14],
                            NSForegroundColorAttributeName : [UIColor C3]};
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:placeholder attributes:dict];
    _textField.attributedPlaceholder = string;
}

- (NSString *)placeholder {
    return _textField.attributedPlaceholder.string;
}

- (UITextField *)textField {
    return _textField;
}

@end
