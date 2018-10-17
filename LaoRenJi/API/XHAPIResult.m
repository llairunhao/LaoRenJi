//
//  XHAPIResult.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/14.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHAPIResult.h"

@implementation XHAPIResult

- (BOOL)isSuccess {
    return self.code == XHAPIResultCodeSuccess;
}

@end
