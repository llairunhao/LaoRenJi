//
//  ChatCell.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/27.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "ChatCell.h"

@implementation ChatCell
{
    __weak UIView *_redPoint;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageView.image = [UIImage imageNamed:@"chat_voice"];
        self.textLabel.textColor = [UIColor C1];
        self.detailTextLabel.textColor = [UIColor C3];
        self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
        self.detailTextLabel.numberOfLines = 0;
        
        
        UIView *point = [[UIView alloc] init];
        point.backgroundColor = [UIColor redColor];
        point.layer.cornerRadius = 4;
        [self.contentView addSubview:point];
        _redPoint = point;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = [self.textLabel sizeThatFits:CGSizeZero];
    CGRect rect = self.bounds;
    rect.origin.x = 12.f;
    rect.size.width = size.width;
    self.textLabel.frame = rect;
    
    size = [self.detailTextLabel sizeThatFits:CGSizeZero];
    rect.origin.x = CGRectGetWidth(self.bounds) - 12.f - size.width;
    rect.size.width = size.width;
    self.detailTextLabel.frame = rect;
    
    size = [self.imageView sizeThatFits:CGSizeZero];
    rect.origin.x = CGRectGetMaxX(self.textLabel.frame);
    rect.origin.y = (CGRectGetHeight(self.bounds) - size.height ) / 2;
    rect.size = size;
    self.imageView.frame = rect;
    
    
    rect.size = CGSizeMake(8, 8);
    rect.origin.x = CGRectGetMaxX(self.imageView.frame) + 4;
    rect.origin.y = (CGRectGetHeight(self.bounds) - 8 ) / 2;
    _redPoint.frame = rect;
}

- (UIView *)redPoint {
    return _redPoint;
}

@end
