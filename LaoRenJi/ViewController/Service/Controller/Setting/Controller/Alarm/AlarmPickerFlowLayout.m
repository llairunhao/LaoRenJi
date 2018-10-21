//
//  AlarmPickerFlowLayout.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/21.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "AlarmPickerFlowLayout.h"

@implementation AlarmPickerFlowLayout

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    CGFloat height = round(proposedContentOffset.y / self.itemSize.height) *  self.itemSize.height;
    self.tareget = height;
    return CGPointMake(0, height);
}


@end
