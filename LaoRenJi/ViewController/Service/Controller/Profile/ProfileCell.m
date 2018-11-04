//
//  ProfileCell.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/27.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "ProfileCell.h"

@implementation ProfileCell
{
    __weak UIImageView *_arrowView;
    __weak UILabel *_contentLabel;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *arrowView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        [self.contentView addSubview:arrowView];
        _arrowView = arrowView;
        
        UILabel *label = [[UILabel alloc] init];
        label.font = self.textLabel.font;
        label.textColor = [UIColor C2];
        [self.contentView addSubview:label];
        _contentLabel = label;
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    CGSize size = [_arrowView sizeThatFits:CGSizeZero];
    rect.origin.x = CGRectGetWidth(self.bounds) - 12.f - size.width;
    rect.origin.y = (CGRectGetHeight(self.bounds) - size.height) / 2;
    rect.size = size;
    _arrowView.frame = rect;
    
    rect = self.bounds;
    rect.origin.x = 12.f;
    rect.size.width = self.leftWidth;
    self.textLabel.frame = rect;
    
    rect.origin.x = CGRectGetMaxX(rect) + 12;
    rect.size.width = CGRectGetMinX(_arrowView.frame) - CGRectGetMaxX(self.textLabel.frame) - 24.f;
    _contentLabel.frame = rect;
}

- (UILabel *)contentLabel {
    return _contentLabel;
}

- (UIImageView *)arrowView {
    return _arrowView;
}


@end
