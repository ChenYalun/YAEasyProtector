//
//  YAEasyProtector.m
//  YAEasyProtector <https://github.com/ChenYalun/YAEasyProtector>
//
//  Created by Chen,Yalun on 2019/8/2.
//  Copyright © 2019 Chen,Yalun. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "YAEasyProtector.h"
#import <objc/runtime.h>

#define kYACurrentCallStackSymbols [NSString stringWithFormat:@"%@", [NSThread callStackSymbols]]
NSString *const kYAEasyProtectorItemTypeKey      = @"kYAEasyProtectorItemTypeKey";
NSString *const kYAEasyProtectorItemClassKey     = @"kYAEasyProtectorItemClassKey";
NSString *const kYAEasyProtectorItemSELKey       = @"kYAEasyProtectorItemSELKey";
NSString *const kYAEasyProtectorItemCallStackKey = @"kYAEasyProtectorItemCallStackKey";
NSString *const kYAEasyProtectorItemUserInfoKey  = @"kYAEasyProtectorItemUserInfoKey";

// Method swizzle.
BOOL ya_methodSwizzle(Class cls, SEL originalSelector, SEL swizzleSelector) {
    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    Method swizzleMethod = class_getInstanceMethod(cls, swizzleSelector);
    BOOL success = class_addMethod(cls,
                                   originalSelector,
                                   method_getImplementation(swizzleMethod),
                                   method_getTypeEncoding(swizzleMethod));
    if (success) {
        class_replaceMethod(cls,
                            swizzleSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }
    return YES;
}

void ya_recordCrashInfo(YACrashType type, Class cls, SEL _cmd, NSString *userInfo) {
    if (YAEasyProtector.sharedProtector.crashHandler) {
        if (!userInfo) userInfo = @"";
        NSDictionary *info = @{
            kYAEasyProtectorItemTypeKey: @(type),
            kYAEasyProtectorItemClassKey: cls,
            kYAEasyProtectorItemSELKey: NSStringFromSelector(_cmd),
            kYAEasyProtectorItemCallStackKey: kYACurrentCallStackSymbols,
            kYAEasyProtectorItemUserInfoKey: userInfo,
        };
        YAEasyProtector.sharedProtector.crashHandler(info);
    }
}

@implementation YAEasyProtector
+ (instancetype)sharedProtector {
    static dispatch_once_t onceToken;
    static YAEasyProtector *sharedProtector;
    dispatch_once(&onceToken, ^{
        sharedProtector = [YAEasyProtector new];
    });
    return sharedProtector;
}
@end
