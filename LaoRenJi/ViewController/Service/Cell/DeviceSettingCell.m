//
//  DeviceSettingCell.m
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/10/19.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import "DeviceSettingCell.h"

@implementation DeviceSettingCell
{
    __weak UIImageView *_arrowView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *arrowView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        [self.contentView addSubview:arrowView];
        _arrowView = arrowView;
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = [self.imageView sizeThatFits:CGSizeZero];
    CGRect rect = self.bounds;
    rect.origin.x = 12.f;
    rect.origin.y = (CGRectGetHeight(self.bounds) - size.height) / 2;
    rect.size = size;
    self.imageView.frame = rect;
    
    size = [_arrowView sizeThatFits:CGSizeZero];
    rect.origin.x = CGRectGetWidth(self.bounds) - 12.f - size.width;
    rect.origin.y = (CGRectGetHeight(self.bounds) - size.height) / 2;
    rect.size = size;
    _arrowView.frame = rect;
    
    rect = self.bounds;
    rect.origin.x = CGRectGetMaxX(self.imageView.frame) + 12.f;
    rect.size.width = CGRectGetMinX(_arrowView.frame) - CGRectGetMaxX(self.imageView.frame) - 24.f;
    self.textLabel.frame = rect;
}

@end

