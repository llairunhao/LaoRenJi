//
//  AudioConverter.h
//  Chat
//
//  Created by RunHao on 2017/5/22.
//  Copyright © 2017年 RunHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioConverter : NSObject

+ (BOOL)encode:(NSString *)wavPath to:(NSString *)amrPath;

+ (BOOL)decode:(NSString *)amrPath to:(NSString *)wavPath;

@end
