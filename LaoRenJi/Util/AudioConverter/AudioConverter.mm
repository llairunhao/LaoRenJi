//
//  AudioConverter.m
//  Chat
//
//  Created by RunHao on 2017/5/22.
//  Copyright © 2017年 RunHao. All rights reserved.
//

#import "AudioConverter.h"
#import "amrFileCodec.h"

@implementation AudioConverter

+ (BOOL)encode:(NSString *)wavPath to:(NSString *)amrPath {
    return EncodeWAVEFileToAMRFile([wavPath cStringUsingEncoding:NSASCIIStringEncoding], [amrPath cStringUsingEncoding:NSASCIIStringEncoding], 1, 16);
  
}

+ (BOOL)decode:(NSString *)amrPath to:(NSString *)wavPath {
    return DecodeAMRFileToWAVEFile([amrPath cStringUsingEncoding:NSASCIIStringEncoding], [wavPath cStringUsingEncoding:NSASCIIStringEncoding]);
}

@end
