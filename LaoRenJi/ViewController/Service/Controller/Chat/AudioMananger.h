//
//  AudioMananger.h
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/10/22.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AudioManangerDelegate <NSObject>

- (void)recordingDidFinish: (NSString *)amrPath;

- (void)downloadRecordFileFromUrlString: (NSString *)urlString toFilePath: (NSString *)filePath;

- (void)failedToPlayFileUrlString: (NSString *)urlString error: (nullable NSError *)error;

@end

@interface AudioMananger : NSObject

@property (nonatomic, weak)id<AudioManangerDelegate> delegate;

- (void)startRecord;
- (void)stopRecord;
- (void)cancelRecord;
- (float)currentPeakPower;
- (void)playAudioFromUrlString: (NSString *)urlString;

@end

NS_ASSUME_NONNULL_END
