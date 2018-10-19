//
//  XHGlobal.h
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/10/19.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const XHUserDidLoginNotification;
extern NSString * const XHUserDidLogoutNotification;

extern NSString * const XHDeviceDidChangeNotification;


typedef void(^VoidHandler)(void);
typedef void(^TextHandler)(NSString *text);
typedef void(^BOOLHandler)(BOOL result);
typedef void(^IntegerHandler)(NSInteger i);
