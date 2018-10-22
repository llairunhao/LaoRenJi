//
//  AudioMananger.m
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/10/22.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import "AudioMananger.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioConverter.h"
#import "XHUser.h"

@interface AudioMananger ()<AVAudioPlayerDelegate>

@property (nonatomic, readonly) NSString *amrPath;
@property (nonatomic, readonly) NSString *wavPath;

@property (nonatomic, readonly) NSString *mainDirectoryPath;
@property (nonatomic, readonly) NSString *wavDirectoryPath;
@property (nonatomic, readonly) NSString *amrDirectoryPath;
@property (nonatomic, readonly) NSString *otherDirectoryPath;

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation AudioMananger



#pragma mark- File
- (NSString *)mainDirectoryPath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *directoryPath = [path stringByAppendingPathComponent:@"Audio"];
    directoryPath = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [XHUser currentUser].account]];
    return directoryPath;
}

- (NSString *)amrDirectoryPath {
    NSString * directoryPath = [self.mainDirectoryPath stringByAppendingPathComponent:@"amr"];
    return [self createDirectoryIfNotExistsAtPath:directoryPath];
}

- (NSString *)wavDirectoryPath {
    NSString * directoryPath = [self.mainDirectoryPath stringByAppendingPathComponent:@"wav"];
    return [self createDirectoryIfNotExistsAtPath:directoryPath];
}

- (NSString *)otherDirectoryPath {
    NSString * directoryPath = [self.mainDirectoryPath stringByAppendingPathComponent:@"other"];
    return [self createDirectoryIfNotExistsAtPath:directoryPath];
}

- (NSString *)amrPath {
    return [self.amrDirectoryPath stringByAppendingPathComponent:@"1234.amr"];
}

- (NSString *)wavPath {
    return [self.wavDirectoryPath stringByAppendingPathComponent:@"1234.wav"];
}

- (NSString *)createDirectoryIfNotExistsAtPath: (NSString *)path {
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDirectory = true;
    if ([manager fileExistsAtPath:path isDirectory:&isDirectory]) {
        return path;
    }
    [manager createDirectoryAtPath:path withIntermediateDirectories:true attributes:nil error:nil];
    return path;
}

#pragma mark- Record
- (void)initSession: (BOOL)play {
    AVAudioSession *session =[AVAudioSession sharedInstance];
    NSError *sessionError;
    if (play) {
        [session setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    }else {
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    }
    if (session == nil) {
        NSLog(@"Error creating session: %@",[sessionError description]);
    }else{
        [session setActive:YES error:nil];
    }
}


- (void)startRecord {
    NSLog(@"开始录音");
    
    //设置参数
    NSDictionary *recordSetting = @{
                                    //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                    AVSampleRateKey : @(8000.0),
                                    // 音频格式
                                    AVFormatIDKey : @(kAudioFormatLinearPCM),
                                    //采样位数  8、16、24、32 默认为16
                                    AVLinearPCMBitDepthKey : @(16),
                                    // 音频通道数 1 或 2
                                    AVNumberOfChannelsKey : @(1),
                                    //录音质量
                                    AVEncoderAudioQualityKey : @(AVAudioQualityHigh)
                                    };
    [self initSession:false];
    NSURL *url = [NSURL URLWithString:self.wavPath];
    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:nil];
    
    if (_recorder) {
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
        [_recorder record];
    }else{
        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
        
    }
}

- (void)stopRecord {
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:self.wavPath]){
        NSLog(@"录制完成");
        if ([AudioConverter encode:self.wavPath to:self.amrPath]) {
            NSLog(@"转换完成");
        }
     //   [self playFilePath:self.wavPath];
        
        [manager removeItemAtPath:self.wavPath error:nil];
        [self.delegate recordingDidFinish:self.amrPath];
        [manager removeItemAtPath:self.amrPath error:nil];
    }
}

- (void)playAudioFromUrlString:(NSString *)urlString {
    if (self.player.isPlaying) {
        return;
    }
    
    NSString *filename = urlString.lastPathComponent;
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([urlString.pathExtension isEqualToString:@"amr"]) {
        NSString *wavName = [filename stringByReplacingOccurrencesOfString:@"amr" withString:@"wav"];
        NSString *wavPath = [self.wavDirectoryPath stringByAppendingPathComponent:wavName];
        NSString *amrPath = [self.amrDirectoryPath stringByAppendingPathComponent:filename];
        
        if ([manager fileExistsAtPath:wavPath]) {
            NSError *err = [self playFilePath:wavPath];
            if (err) {
                [self.delegate failedToPlayFileUrlString:urlString error:err];
            }
            return;
        }
     
        if ([manager fileExistsAtPath:amrPath]) {
            [AudioConverter decode:amrPath to:wavPath];
            NSError *err = [self playFilePath:wavPath];
            if (err) {
                [self.delegate failedToPlayFileUrlString:urlString error:err];
            }
            return;
        }
        
        [self.delegate downloadRecordFileFromUrlString:urlString toFilePath:amrPath];
        return;
    }

    
    NSString *directoryPath = [urlString.pathExtension isEqualToString: @"wav"] ? self.wavDirectoryPath : self.otherDirectoryPath;
    NSString *path = [directoryPath stringByAppendingPathComponent:filename];
    if ([manager fileExistsAtPath:path]) {
        NSError *err = [self playFilePath:path];
        if (err) {
            [self.delegate failedToPlayFileUrlString:urlString error:err];
        }
        return;
    }
    [self.delegate downloadRecordFileFromUrlString:urlString toFilePath:path];
}


- (NSError *)playFilePath: (NSString *)filePath {
    [self initSession: true];
    NSError *err;
    if ([self.player.url.absoluteString isEqualToString:filePath]) {
        [self.player play];
        return nil;
    }
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:&err];
    self.player.meteringEnabled = true;

    self.player.delegate = self;
    if (err) {
        return err;
    }

    if (err) {
        return err;
    }
    self.player.volume = 1;
    [self.player prepareToPlay];
    if (![self.player play]){
        return [NSError errorWithDomain:@"com.xh.audio"
                                   code:1000
                               userInfo:@{ NSLocalizedDescriptionKey : @"不支持的音频格式" }];
    }
    return nil;
}



- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer*)player error:(NSError *)error {
    NSLog(@"%@", error);
}

@end
