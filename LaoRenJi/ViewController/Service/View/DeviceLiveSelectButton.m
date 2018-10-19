//
//  DeviceLiveSelectButton.m
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/10/19.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import "DeviceLiveSelectButton.h"

@implementation DeviceLiveSelectButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self setTitleColor:[UIColor lightGrayColor] forState: UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size1 = [self.imageView sizeThatFits:CGSizeZero];
    CGSize size2 = [self.titleLabel sizeThatFits:CGSizeZero];
    

    CGRect rect = self.bounds;
    rect.origin.y = CGRectGetHeight(self.bounds) - size2.height;
    rect.size.height = size2.height;
    self.titleLabel.frame = rect;
    
    rect = self.bounds;
    rect.origin.x = (CGRectGetWidth(self.bounds) - size1.width ) / 2;
    rect.origin.y = (CGRectGetMinY(self.titleLabel.frame) - size1.height ) / 2;
    rect.size = size1;
    self.imageView.frame = rect;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize size1 = self.currentImage.size;
    CGSize size2 = [self.titleLabel sizeThatFits:CGSizeZero];
    
    CGFloat totalH = size1.height + size2.height + 12.f;
    return CGSizeMake(MAX(size1.width, size2.width), totalH);
}

@end
