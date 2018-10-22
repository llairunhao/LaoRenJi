//
//  XHAPI+API.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/14.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface XHAPI (API)

+ (NSURLSessionDataTask *)loginWithAccount: (NSString *)account
                                  password: (NSString *)password
                                   xgToken: (NSString *)xgToken
                                   handler: (nullable XHAPIResultHandler)handler;

+ (NSURLSessionDataTask *)listOfDevicesByToken: (NSString *)token
                                       handler: (nullable XHAPIResultHandler)handler;

+ (NSURLSessionDataTask *)getCurrentDeviceStateByToken: (NSString *)token
                                               handler: (nullable XHAPIResultHandler)handler;

+ (NSURLSessionDataTask *)setCurrentDeviceByToken: (NSString *)token
                                    deviceSimMark: (NSString *)simMark
                                          handler: (nullable XHAPIResultHandler)handler;


+ (NSURLSessionDataTask *)listOfContactsByToken: (NSString *)token
                                        handler: (nullable XHAPIResultHandler)handler;


+ (NSURLSessionDataTask *)updateContactByToken: (NSString *)token
                                     contactId: (NSUInteger)contactId
                                          name: (NSString *)name
                                         phone: (NSString *)phone
                                      isUrgent: (BOOL)isUrgent
                                   urgentLevel: (NSInteger)urgentLevel
                                  isAutoAnswer: (BOOL)isAutoAnswer
                                       handler: (nullable XHAPIResultHandler)handler;

+ (NSURLSessionDataTask *)saveContactByToken: (NSString *)token
                                        name: (NSString *)name
                                       phone: (NSString *)phone
                                    isUrgent: (BOOL)isUrgent
                                 urgentLevel: (NSInteger)urgentLevel
                                isAutoAnswer: (BOOL)isAutoAnswer
                                     handler: (nullable XHAPIResultHandler)handler;

+ (NSURLSessionDataTask *)removeContactByToken: (NSString *)token
                                     contactId: (NSUInteger)contactId
                                       handler: (nullable XHAPIResultHandler)handler;

+ (NSURLSessionDataTask *)saveDeviceWifiByToken: (NSString *)token
                                       wifiName: (NSString *)wifiName
                                           type: (NSInteger)type
                                       password: (NSString *)password
                                        handler: (nullable XHAPIResultHandler)handler;

+ (NSURLSessionDataTask *)listOfAlarmClocksByToken: (NSString *)token
                                           handler:(nullable XHAPIResultHandler)handler;

+ (NSURLSessionDataTask *)getAlarmClockById: (NSUInteger )clockId
                                      token: (NSString *)token
                                    handler: (nullable XHAPIResultHandler)handler;

+ (NSURLSessionDataTask *)saveAlarmClockByToken: (NSString *)token
                                      eventName: (NSString *)eventName
                                   eventContent: (NSString *)eventContent
                                      eventTime: (NSString *)eventTime
                                   timeInterval: (NSString *)timeInterval
                                         enable: (BOOL)enable
                                        simMark: (NSString *)simMark
                                        handler: (nullable XHAPIResultHandler)handler;

+ (NSURLSessionDataTask *)updateAlarmClockById: (NSUInteger )clockId
                                         token: (NSString *)token
                                     eventName: (NSString *)eventName
                                  eventContent: (NSString *)eventContent
                                     eventTime: (NSString *)eventTime
                                  timeInterval: (NSString *)timeInterval
                                        enable: (BOOL)enable
                                       simMark: (NSString *)simMark
                                       handler: (nullable XHAPIResultHandler)handler;

+ (NSURLSessionDataTask *)removeAlarmClockById: (NSUInteger )clockId
                                         token: (NSString *)token
                                       handler: (nullable XHAPIResultHandler)handler;


+ (NSURLSessionDataTask *)uploadAudioData: (NSData *)data
                                   suffix: (NSString *)suffix
                                    token: (NSString *)token
                                  handler: (nullable XHAPIResultHandler)handler;

+ (NSURLSessionDataTask *)listOfAudiosByToken: (NSString *)token
                                      handler: (nullable XHAPIResultHandler)handler;

+ (NSURLSessionDataTask *)updateAudioReadStateById: (NSUInteger)audioId
                                           handler: (nullable XHAPIResultHandler)handler;
@end

NS_ASSUME_NONNULL_END

