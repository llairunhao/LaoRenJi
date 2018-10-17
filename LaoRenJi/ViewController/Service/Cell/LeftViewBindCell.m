//
//  LeftViewBindCell.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/17.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "LeftViewBindCell.h"

@implementation LeftViewBindCell


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageView.image = [UIImage imageNamed:@"绑定设备"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = [self.imageView sizeThatFits:CGSizeZero];
    CGRect rect = self.bounds;
    rect.origin.x = CGRectGetWidth(self.bounds) - size.width - 10;
    rect.origin.y = (CGRectGetHeight(self.bounds) - size.height ) / 2;
    rect.size = size;
    self.imageView.frame = rect;
    
}



@end
