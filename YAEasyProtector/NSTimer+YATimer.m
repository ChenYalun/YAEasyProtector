//
//  NSTimer+YATimer.m
//  YAEasyProtector <https://github.com/ChenYalun/YAEasyProtector>
//
//  Created by Chen,Yalun on 2019/8/2.
//  Copyright © 2019 Chen,Yalun. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "YAEasyProtector.h"
#import "YAProxy.h"
#import <objc/runtime.h>

@implementation NSTimer (YATimer)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ya_methodSwizzle(object_getClass(self), @selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:), @selector(ya_scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:));
        ya_methodSwizzle(object_getClass(self), @selector(timerWithTimeInterval:target:selector:userInfo:repeats:), @selector(ya_timerWithTimeInterval:target:selector:userInfo:repeats:));
    });
}

+ (NSTimer *)ya_scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
    return [self ya_scheduledTimerWithTimeInterval:ti target:[[YAProxy alloc] initWithTarget:aTarget] selector:aSelector userInfo:userInfo repeats:yesOrNo];
}

+ (NSTimer *)ya_timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo {
    return [self ya_timerWithTimeInterval:ti target:[[YAProxy alloc] initWithTarget:aTarget] selector:aSelector userInfo:userInfo repeats:yesOrNo];
}
@end
