//
//  XHContact.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/20.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHContact : NSObject<XHJSONObjectDelegate>

@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *phone;

@property (nonatomic, assign)BOOL isUrgent;
@property (nonatomic, assign)BOOL isAutoAnswer;
@property (nonatomic, assign)NSUInteger urgentLevel;
@property (nonatomic, assign)NSUInteger contactId;


@end

NS_ASSUME_NONNULL_END
