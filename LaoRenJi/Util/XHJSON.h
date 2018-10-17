//
//  XHJSON.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/14.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHJSON : NSObject

+ (XHJSON *)JSONWithValue: (nullable id)value;
+ (XHJSON *)nullJSON;

- (instancetype)initWithValue: (nullable id)value;

@property (readonly) BOOL isNull;
@property (readonly) BOOL isNumber;
@property (readonly) BOOL isDictionary;
@property (readonly) BOOL isArray;

@property (readonly) NSString *stringValue;
@property (readonly) NSUInteger unsignedIntegerValue;
@property (readonly) NSInteger integerValue;

@property (readonly) double doubleValue;
@property (readonly) float floatValue;
@property (readonly) BOOL boolValue;
@property (readonly) unsigned long unsignedLongValue;

@property (readonly) NSArray<XHJSON *> *JSONArrayValue;
@property (readonly) NSDictionary<NSString*, XHJSON *> *JSONDictionaryValue;

@property (readonly) NSArray<NSString *> *stringArrayValue;
@property (readonly) NSArray<NSDictionary *> *dictionaryArrayValue;

- (XHJSON *)JSONForKey: (NSString *)key;

@end

@protocol XHJSONObjectDelegate <NSObject>
- (instancetype)initWithJSON: (XHJSON *)JSON;
- (void)setupWithJSON: (XHJSON *)JSON;
@end

NS_ASSUME_NONNULL_END
