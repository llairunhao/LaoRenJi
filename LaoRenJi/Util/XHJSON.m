//
//  XHJSON.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/14.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHJSON.h"

@implementation XHJSON
{
    id _value;
}

+ (XHJSON *)JSONWithValue:(id)value {
    return [[XHJSON alloc] initWithValue:value];
}

+ (XHJSON *)nullJSON {
     return [[XHJSON alloc] initWithValue:nil];
}

- (instancetype)initWithValue:(id)value {
    self = [super init];
    if (self) {
        _value = value;
    }
    return self;
}

- (NSString *)stringValue {
    if (self.isNull) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@", _value];
}

- (NSUInteger)unsignedIntegerValue {
    if (self.isNull) {
        return 0;
    }
    if (self.isNumber) {
        return [_value unsignedIntegerValue];
    }
    NSInteger v = [self.stringValue integerValue];
    if (v < 0) {
        return 0;
    }
    return v;
}

- (unsigned long)unsignedLongValue {
    if (self.isNull) {
        return 0;
    }
    if (self.isNumber) {
        return [_value unsignedLongValue];
    }
    return 0;
}

- (NSInteger)integerValue {
    if (self.isNull) {
        return 0;
    }
    if (self.isNumber) {
        return [_value integerValue];
    }
    return [self.stringValue integerValue];
}

- (double)doubleValue {
    if (self.isNull) {
        return 0;
    }
    if (self.isNumber) {
        return [_value doubleValue];
    }
    return [self.stringValue doubleValue];
}

- (float)floatValue {
    if (self.isNull) {
        return 0;
    }
    if (self.isNumber) {
        return [_value floatValue];
    }
    return [self.stringValue floatValue];
}

- (BOOL)boolValue {
    if (self.isNull) {
        return false;
    }
    if ([NSStringFromClass([_value class]) isEqualToString:@"__NSCFBoolean"]) {
        return [_value boolValue];
    }
    if (self.isNumber) {
        return [_value boolValue];
    }
    return [self.stringValue boolValue];
}



- (BOOL)isNumber {
    if (_value) {
        return[NSStringFromClass([_value class]) isEqualToString:@"__NSCFNumber"];
    }
    return false;
}

- (BOOL)isNull {
    if (_value) {
        return [NSStringFromClass([_value class]) isEqualToString:@"NSNull"];
    }
    return true;
}

- (BOOL)isArray {
    if (_value) {
        return [_value isKindOfClass:[NSArray class]];
    }
    return false;
}

- (BOOL)isDictionary {
    if (_value) {
        if ([_value isKindOfClass:[NSDictionary class]]) {
            return true;
        }
    }
    return false;
}

- (NSArray<XHJSON *> *)JSONArrayValue {
    if (_value) {
        if (self.isArray) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:[_value count]];
            [_value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [array addObject:[XHJSON JSONWithValue:obj]];
            }];
            return [array copy];
        }
        return @[];
    }
    return @[];
}

- (NSArray<NSString *> *)stringArrayValue {
    if (_value) {
        if (self.isArray) {
            if ([[_value firstObject] isKindOfClass:[NSString class]]) {
                return _value;
            }
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:[_value count]];
            [_value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [array addObject: [NSString stringWithFormat:@"%@", obj]];
            }];
            return [array copy];
        }
    }
    return @[];
}

- (NSArray<NSDictionary *> *)dictionaryArrayValue {
    if (_value) {
        if (self.isArray) {
            if ([[_value firstObject] isKindOfClass:[NSDictionary class]]) {
                return _value;
            }
            return @[];
        }
    }
    return @[];
}

- (NSDictionary<NSString*, XHJSON *> *)JSONDictionaryValue {
    
    if (_value) {
        if ([_value isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:[_value count]];
            [_value enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                dict[key] = [XHJSON JSONWithValue:obj];
            }];
            return [dict copy];
        }
        return @{};
    }
    return @{};
}

- (XHJSON *)JSONForKey:(NSString *)key {
    if ([_value isKindOfClass:[NSDictionary class]]) {
        id item = [_value objectForKey:key];
        if (item) {
            return [XHJSON JSONWithValue:item];
        }
    }
    return [XHJSON JSONWithValue:nil];
}



@end
