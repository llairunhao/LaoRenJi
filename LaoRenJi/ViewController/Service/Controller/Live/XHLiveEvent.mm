//
//  XHLiveEvent.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/13.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHLiveEvent.h"

@implementation XHLiveEvent


-(void)OnEvent:(NSString *)sAction data:(NSString *)sData capid:(NSString *)sCapID {
    [self.delegate OnEvent:sAction data:sData capid:sCapID];
}

@end
