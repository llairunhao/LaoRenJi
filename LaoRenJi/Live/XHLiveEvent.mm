//
//  XHLiveEvent.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/13.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHLiveEvent.h"

@implementation XHLiveEvent

-(void)OnEvent:(NSString*)sAction
          data:(NSString*)sData
        render:(NSString*)sRender {
    
//    
//    NSLog(@"Action:%@, Data:%@, sRender:%@", sAction, sData, sRender);
//    if ([sAction isEqualToString:@"VideoStatus"]) {
//        // Video status report
//    }
//    else if ([sAction isEqualToString:@"Notify"]) {
//        // Receive the notify from capture side
//        NSString* sInfo = [NSString stringWithFormat:@"Receive notify, data=%@", sData];
//        [self showAlert:sInfo];
//    }
//    else if ([sAction isEqualToString:@"RenderJoin"]) {
//        // A render join
//        NSString* sInfo = [NSString stringWithFormat:@"Render join, render=%@", sRender];
//        [self showAlert:sInfo];
//    }
//    else if ([sAction isEqualToString:@"RenderLeave"]) {
//        // A render leave
//        NSString* sInfo = [NSString stringWithFormat:@"Render leave, render=%@", sRender];
//        [self showAlert:sInfo];
//    }
//    else if ([sAction isEqualToString:@"Message"]) {
//        // Receive the message from render or capture
//        NSString* sInfo = [NSString stringWithFormat:@"Receive msg, data=%@, render=%@", sData, sRender];
//        [self showAlert:sInfo];
//    }
//    else if ([sAction isEqualToString:@"Login"]) {
//        // Login reply
//        if ([sData isEqualToString:@"0"]) {
//            NSString* sInfo = @"Login success";
//            [self showAlert:sInfo];
//        }
//        else {
//            NSString* sInfo = [NSString stringWithFormat:@"Login failed, error=%@", sData];
//            [self showAlert:sInfo];
//        }
//    }
//    else if ([sAction isEqualToString:@"Logout"] ) {
//        // Logout
//        NSString* sInfo = @"Logout";
//        [self showAlert:sInfo];
//    }
//    else if ([sAction isEqualToString:@"Connect"] ) {
//        // Connect to capture
//        NSString* sInfo = @"Connect to capture";
//        [self showAlert:sInfo];
//    }
//    else if ([sAction isEqualToString:@"Disconnect"] ) {
//        // Disconnect from capture
//        NSString* sInfo = @"Disconnect from capture";
//        [self showAlert:sInfo];
//    }
//    else if ([sAction isEqualToString:@"Reject"] ) {
//        // Disconnect from capture
//        NSString* sInfo = @"Reject by capture";
//        [self showAlert:sInfo];
//    }
//    else if ([sAction isEqualToString:@"Offline"]) {
//        // The capture is offline.
//        NSString* sInfo = @"The capture is offline";
//        [self showAlert:sInfo];
//    }
//    else if ([sAction isEqualToString:@"LanScanResult"] ) {
//        // Lan scan result.
//        NSString* sInfo = [NSString stringWithFormat:@"Lan scan result: %@", sData];
//        [self showAlert:sInfo];
//    }
//    else if ([sAction isEqualToString:@"ForwardAllocReply"] ) {
//        [self outString:sData];
//        NSString* sInfo = [NSString stringWithFormat:@"Forward alloc reply, error=%@", sData];
//        [self showAlert:sInfo];
//    }
//    else if ([sAction isEqualToString:@"ForwardFreeReply"] ) {
//        [self outString:sData];
//        NSString* sInfo = [NSString stringWithFormat:@"Forward free reply, error=%@", sData];
//        [self showAlert:sInfo];
//    }
//    else if ([sAction isEqualToString:@"FileAccept"] ) {
//        NSString* sInfo = [NSString stringWithFormat:@"File accept: %@", sData];
//        [self showAlert:sInfo];
//    }
//    else if ([sAction isEqualToString:@"FileReject"] ) {
//        [self FileReject];
//    }
//    else if ([sAction isEqualToString:@"FileAbort"] ) {
//        [self FileAbort];
//    }
//    else if ([sAction isEqualToString:@"FileFinish"] ) {
//        // 文件传输完毕
//        [self FileFinish];
//    }
//    else if ([sAction isEqualToString:@"FileProgress"]) {
//        [self FileProgress:sData];
//    }
//    else if ([sAction isEqualToString:@"outString"]) {
//        [self outString:sData];
//    }
//    else if ([sAction isEqualToString:@"SvrNotify"]) {
//        NSString* sInfo = [NSString stringWithFormat:@"Receive server notify, data=%@", sData];
//        [self showAlert:sInfo];
//    }
}

@end
