//
//  YAEasyProtector.h
//  YAEasyProtector <https://github.com/ChenYalun/YAEasyProtector>
//
//  Created by Chen,Yalun on 2019/8/2.
//  Copyright © 2019 Chen,Yalun. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YACrashType) {
    YACrashTypeUnknow = 0,
    YACrashTypeKVC    = 1,
    YACrashTypeKVO    = 2,
    YACrashTypeArrayNilValue = 3,
    YACrashTypeArrayBeyondBounds = 4,
    YACrashTypeDictionaryNilValue = 5,
    YACrashTypeUnrecognizedSelector = 6,
};

// Function
BOOL ya_methodSwizzle(Class cls, SEL originalSelector, SEL swizzleSelector);
void ya_recordCrashInfo(YACrashType type, Class cls, SEL _cmd, NSString *info);
extern NSString * const kYAEasyProtectorItemTypeKey;
extern NSString * const kYAEasyProtectorItemClassKey;
extern NSString * const kYAEasyProtectorItemSELKey;
extern NSString * const kYAEasyProtectorItemCallStackKey;
extern NSString * const kYAEasyProtectorItemUserInfoKey;

@interface YAEasyProtector : NSObject
@property (nonatomic, copy) void (^crashHandler)(NSDictionary *userInfo);
+ (instancetype)sharedProtector;
@end

