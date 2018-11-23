//
//  HistoryCell.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/27.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "HistoryCell.h"

@implementation HistoryCell
{
    __weak UILabel *_typeLabel;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor C2];
        [self.contentView addSubview:label];
        _typeLabel = label;
        
        self.textLabel.textColor = [UIColor C1];
        self.detailTextLabel.textColor = [UIColor C3];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = [self.imageView sizeThatFits:CGSizeZero];
    CGRect rect = self.bounds;
    rect.origin.x = CGRectGetWidth(self.bounds) - size.width - 12.f;
    rect.origin.y = CGRectGetMinY(self.textLabel.frame);
    rect.size = size;
    self.imageView.frame = rect;
    
    rect = self.textLabel.frame;
    rect.origin.x = 12.f;
    self.textLabel.frame = rect;
    
    rect = self.detailTextLabel.frame;
    rect.origin.x = 12.f;
    self.detailTextLabel.frame = rect;
    
    size = [_typeLabel sizeThatFits:CGSizeZero];
    rect.origin.x = CGRectGetMinX(self.imageView.frame) - 12.f - size.width;
    rect.origin.y = CGRectGetMinY(self.textLabel.frame);
    rect.size = size;
    _typeLabel.frame = rect;

}

- (void)setHistoryType:(XHDeviceLogType)historyType {
    NSString *desc;
    NSString *imageName;
    switch (historyType) {
        case XHDeviceLogTypeFall:
        {
            desc = @"跌倒";
            imageName = @"跌倒";
        }
            break;
        case XHDeviceLogTypeLeaveFence:
        {
            desc = @"跨越围栏";
            imageName = @"跨越围栏";
        }
            break;
        case XHDeviceLogTypeMessage:
        {
            desc = @"留言";
            imageName = @"留言2";
        }
            break;
        case XHDeviceLogTypeLowPower:
        {
            desc = @"低电报警";
            imageName = @"低电报警";
        }
            break;
    }
    self.imageView.image = [UIImage imageNamed:imageName];
    _typeLabel.text = desc;
}

@end
