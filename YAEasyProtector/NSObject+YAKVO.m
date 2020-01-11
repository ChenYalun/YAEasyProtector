//
//  NSObject+YAKVO.m
//  YAEasyProtector <https://github.com/ChenYalun/YAEasyProtector>
//
//  Created by Chen,Yalun on 2019/8/2.
//  Copyright © 2019 Chen,Yalun. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "YAEasyProtector.h"
#import "NSObject+YADeallocOperation.h"

#define DISGUISE(object) [NSString stringWithFormat:@"%p", object]
static NSMutableDictionary *gMainMap;

@implementation NSObject (YAKVO)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ya_methodSwizzle(self, @selector(addObserver:forKeyPath:options:context:), @selector(ya_addObserver:forKeyPath:options:context:));
        ya_methodSwizzle(self, @selector(removeObserver:forKeyPath:), @selector(ya_removeObserver:forKeyPath:));
    });
}

- (void)ya_addObserver:(NSObject *)observer
            forKeyPath:(NSString *)keyPath
               options:(NSKeyValueObservingOptions)options
               context:(void *)context {
    BOOL shouldAddObserver = YES;
    NSString *observerKey = DISGUISE(observer);
    if (!gMainMap) gMainMap = [NSMutableDictionary dictionary];
    
    NSMapTable *subMap = [gMainMap objectForKey:observerKey];
    if (!subMap) {
        subMap = [NSMapTable weakToWeakObjectsMapTable];
        NSMutableSet *set = [NSMutableSet setWithObject:keyPath];
        [subMap setObject:set forKey:DISGUISE(self)];
    } else {
        NSMutableSet *set = [subMap objectForKey:DISGUISE(self)];
        if ([set containsObject:keyPath]) { // O(1)
            // Repeat addObserver.
            shouldAddObserver = NO;
        }
    }
    [gMainMap setObject:subMap forKey:observerKey];
    if (shouldAddObserver) {
        [self ya_addObserver:observer forKeyPath:keyPath options:options context:context];
    } else {
        ya_recordCrashInfo(YACrashTypeKVO, self.class, _cmd, nil);
    }
    
    if (!observer.deallocOperation) return;
    observer.deallocOperation = ^(id observer) {
        NSString *observerKey = DISGUISE(observer);
        NSMapTable *subMap = [gMainMap objectForKey:observerKey];
        if (subMap) {
            [[[subMap keyEnumerator] allObjects] enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
                NSSet *set = [subMap objectForKey:object];
                [set enumerateObjectsUsingBlock:^(NSString *key, BOOL *stop) {
                    [object removeObserver:observer forKeyPath:key];
                }];
                // Remove keyPath.
                [subMap removeObjectForKey:object];
            }];
            // Remove subMap.
            [gMainMap removeObjectForKey:observerKey];
        }
    };
}

- (void)ya_removeObserver:(NSObject *)observer
               forKeyPath:(NSString *)keyPath {
    NSString *observerKey = DISGUISE(observer);
    if (!gMainMap) gMainMap = [NSMutableDictionary dictionary];
    NSMapTable *subMap = [gMainMap objectForKey:observerKey];
    if (subMap) {
        NSMutableSet *set = [subMap objectForKey:DISGUISE(self)];
        if ([set containsObject:keyPath]) { // O(1)
            [set removeObject:keyPath];
            [self ya_removeObserver:observer forKeyPath:keyPath];
            if (set.count == 0) {
                [gMainMap removeObjectForKey:observerKey];
            }
            return;
        }
    }

    ya_recordCrashInfo(YACrashTypeKVO, self.class, _cmd, nil);
}
@end
