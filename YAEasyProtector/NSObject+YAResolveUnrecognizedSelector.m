//
//  NSObject+YAResolveUnrecognizedSelector.m
//  YAEasyProtector <https://github.com/ChenYalun/YAEasyProtector>
//
//  Created by Chen,Yalun on 2019/8/2.
//  Copyright © 2019 Chen,Yalun. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <objc/runtime.h>
#import "YAEasyProtector.h"

@interface YAForwardingTarget : NSObject
@end
@implementation YAForwardingTarget
static inline void forwardingTargetDynamicMethod(id self, SEL _cmd) {}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    class_addMethod(self.class, sel, (IMP)forwardingTargetDynamicMethod, "v@:");
    [super resolveInstanceMethod:sel];
    return YES;
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    class_addMethod(object_getClass(self), sel, (IMP)forwardingTargetDynamicMethod, "v@:");
    [class_getSuperclass(self) resolveClassMethod:sel];
    return YES;
}
@end



@implementation NSObject (YAResolveUnrecognizedSelector)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ya_methodSwizzle(self.class, @selector(forwardingTargetForSelector:), @selector(swizzleForwardingTargetForSelector:));
        ya_methodSwizzle(object_getClass(self), @selector(forwardingTargetForSelector:), @selector(swizzleForwardingTargetForSelector:));
    });
}

#define swizzleForwardingTargetForSelector(arg) \
arg (id)swizzleForwardingTargetForSelector:(SEL)aSelector { \
    id result = [self swizzleForwardingTargetForSelector:aSelector]; \
    if (result) return result; \
    NSString *classString = NSStringFromClass(object_getClass(self)); \
    BOOL isClsMethod = [@#arg isEqualToString:@"+"]; /* 区分类方法和实例方法 */\
    Class currCls = isClsMethod ? object_getClass(self) : self.class;\
    Class oriCls = isClsMethod ? object_getClass(NSObject.class) : NSObject.class;\
    IMP currentImp = class_getMethodImplementation(currCls, @selector(forwardInvocation:));\
    IMP originImp = class_getMethodImplementation(oriCls, @selector(forwardInvocation:));\
    /* 也可以添加白名单. */ \
    if ([classString hasPrefix:@"YA"] && currentImp == originImp) { \
        /* 避免crash. */\
        ya_recordCrashInfo(YACrashTypeUnrecognizedSelector, object_getClass(self), aSelector, nil);\
        return isClsMethod ? YAForwardingTarget.class : [YAForwardingTarget new]; \
    } else { \
        return nil; /* 抛出异常. */ \
    } \
} \

// Class method and instance method.
swizzleForwardingTargetForSelector(+)
swizzleForwardingTargetForSelector(-)
#undef swizzleForwardingTargetForSelector
@end
