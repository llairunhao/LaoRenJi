//
//  AlarmCell.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/21.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "AlarmCell.h"
#import "XHAlarm.h"

@implementation AlarmCell
{
    UIButton *_switchButton;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:button];
        [button setImage:[UIImage imageNamed:@"SWITCH"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"SWITCHON"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(switchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _switchButton = button;
        
        self.textLabel.textColor = [UIColor C1];
//        self.textLabel.font = [UIFont systemFontOfSize:20];
        self.detailTextLabel.textColor = [UIColor C3];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
 
    CGSize size = [_switchButton sizeThatFits:CGSizeZero];
    CGRect rect = self.bounds;
    rect.origin.x = CGRectGetWidth(rect) - size.width - 12.f;
    rect.origin.y = CGRectGetMinY( self.textLabel.frame); //(CGRectGetHeight(rect) - size.height ) / 2;
    rect.size = size;
    _switchButton.frame = rect;
}

- (void)setAlarm:(XHAlarm *)alarm {
    _alarm = alarm;
    self.textLabel.text = [alarm.eventTime componentsSeparatedByString:@" "].lastObject;
    
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@，%@", alarm.eventName, alarm.repeatDay];
    _switchButton.selected = alarm.enable;
}



- (void)switchButtonClick: (UIButton *)button {
    self.alarm.enable = !button.selected;
    [self.delegate updateAlarmEnable: self.alarm];
}



@end
