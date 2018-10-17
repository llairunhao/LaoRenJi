//
//  XHNavigationBar.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/14.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHNavigationBar.h"

@implementation XHNavigationBar
{
    NSMutableArray<UIView *> *_rightItems;
    NSMutableArray<UIView *> *_leftItems;
    
    __weak UILabel *_titleLabel;
    __weak UIButton *_backButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"nav_icon_back_white"] forState: UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"nav_icon_back_press"] forState:UIControlStateHighlighted];
        [backButton addTarget:self
                       action:@selector(backToPrevViewController:)
             forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        _backButton = backButton;
        _backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 12.f, 0, 0);
    }
    return self;
}



- (void)layoutSubviews {
 
    
    CGRect titleFrame = _titleLabel.frame;
    titleFrame.size.height = CGRectGetHeight(self.bounds);
    titleFrame.size.width = 200;
    titleFrame.origin.y = 0;
    titleFrame.origin.x = (CGRectGetWidth(self.bounds) - 200) * 0.5;
    _titleLabel.frame = titleFrame;
    
    CGSize size = [_backButton sizeThatFits:CGSizeZero];
    CGRect btnFrame = CGRectZero;
    btnFrame.origin.x = 0;
    btnFrame.size.width = size.width + 12.f;
    btnFrame.size.height = CGRectGetHeight(self.bounds);
    _backButton.frame = btnFrame;
    
    CGFloat padding = 12.f;
    if (_leftItems) {
        for (NSInteger i = 0; i < _leftItems.count; i++) {
            UIView *item = _leftItems[i];
            CGRect itemFrame = CGRectZero;
            itemFrame.size = [item sizeThatFits:CGSizeZero];
            itemFrame.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(itemFrame)) * 0.5;
            if (i > 0) {
                itemFrame.origin.x = CGRectGetMaxX(_rightItems[i - 1].frame);
            } else {
                itemFrame.origin.x = 0;
            }
            itemFrame.origin.x += padding;
            item.frame = itemFrame;
        }
    }
    
    if (_rightItems) {
        for (NSInteger i = 0; i < _rightItems.count; i++) {
            UIView *item = _rightItems[i];
            CGRect itemFrame = CGRectZero;
            itemFrame.size = [item sizeThatFits:CGSizeZero];
            itemFrame.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(itemFrame)) * 0.5;
            if (i > 0) {
                itemFrame.origin.x = CGRectGetMinX(_rightItems[i - 1].frame);
            } else {
                itemFrame.origin.x = CGRectGetWidth(self.bounds);
            }
            itemFrame.origin.x -= (padding + CGRectGetWidth(itemFrame));
            item.frame = itemFrame;
        }
    }
}

- (void)backToPrevViewController: (UIButton *)btn {
    if (self.backHandler) {
        self.backHandler();
    }
}

- (void)addRigthItem:(UIView *)rightItem {
    if (!_rightItems) {
        _rightItems = [NSMutableArray array];
    }
    if (![_rightItems containsObject:rightItem]) {
        [_rightItems addObject:rightItem];
        [self addSubview:rightItem];
    }
    
}

- (void)addLeftItem: (UIView *)leftItem {
    if (!_leftItems) {
        _leftItems = [NSMutableArray array];
    }
    _backButton.hidden = true;
    if (![_leftItems containsObject:leftItem]) {
        [_leftItems addObject:leftItem];
        [self addSubview:leftItem];
    }
}


- (void)removeAllItems {
    if (_rightItems) {
        for (UIView *view in _rightItems) {
            [view removeFromSuperview];
        }
    }
    _rightItems = nil;
    
    if (_leftItems) {
        for (UIView *view in _leftItems) {
            [view removeFromSuperview];
        }
    }
    _leftItems = nil;
}


- (NSArray<UIView *> *)rightItems {
    return [_rightItems copy];
}

- (NSArray<UIView *> *)leftItems {
    return [_leftItems copy];
}

- (UILabel *)titleLabel {
    return _titleLabel;
}

- (UIButton *)backButton {
    return _backButton;
}
@end
