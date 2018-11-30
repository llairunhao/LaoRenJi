//
//  XHGlobal.h
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/10/19.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString *XHLocationStatus;

extern NSString * const XHUserDidLoginNotification;
extern NSString * const XHUserDidLogoutNotification;

extern NSString * const XHCurrentDeviceDidChangeNotification;
extern NSString * const XHDevicesDidChangeNotification;

extern NSString * const XHDeviceDidReadyMonitorNotification;
extern NSString * const XHNewDeviceLogNotification;
extern NSString * const XHNewMessageNotification;

extern XHLocationStatus const XHLocationOpen;
extern XHLocationStatus const XHLocationStop;

typedef NS_ENUM(NSInteger, XHLocationAccuracy) {
    XHLocationAccuracyBest,
    XHLocationAccuracyLowPower,
    XHLocationAccuracyGPS
};

typedef NS_ENUM(NSInteger, XHLiveType) {
    XHLiveTypeVideo,
    XHLiveTypeAudio,
};

typedef NS_ENUM(NSInteger, XHCameraType) {
    XHCameraTypeRear,
    XHCameraTypeFront,

};


typedef NS_ENUM(NSInteger, XHMonitorStatus) {
    XHMonitorStatusFailed,
    XHMonitorStatusReady
};

typedef NS_ENUM(NSInteger, XHDeviceLogType) {
    XHDeviceLogTypeLowPower,
    XHDeviceLogTypeLeaveFence,
    XHDeviceLogTypeFall,
    XHDeviceLogTypeMessage
};


typedef void(^VoidHandler)(void);
typedef void(^TextHandler)(NSString *text);
typedef void(^BOOLHandler)(BOOL result);
typedef void(^IntegerHandler)(NSInteger i);
