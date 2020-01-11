//
//  NSArray+YAResolveNilValue.m
//  YAEasyProtector <https://github.com/ChenYalun/YAEasyProtector>
//
//  Created by Chen,Yalun on 2019/8/2.
//  Copyright © 2019 Chen,Yalun. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "YAEasyProtector.h"

@implementation NSArray (YAResolveNilValue)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ya_methodSwizzle(NSClassFromString(@"__NSPlaceholderArray"), @selector(initWithObjects:count:), @selector(ya_initWithObjects:count:));
        ya_methodSwizzle(NSClassFromString(@"__NSArray0"), @selector(objectAtIndex:), @selector(ya_objectAtIndex:));
    });
}

- (instancetype)ya_initWithObjects:(id const [])objects count:(NSUInteger)cnt {
    for (NSUInteger i = 0; i < cnt; i++) {
        if (!objects[i]) {
            ya_recordCrashInfo(YACrashTypeArrayNilValue, self.class, _cmd, nil);
            return nil;
        }
    }
    return [self ya_initWithObjects:objects count:cnt];
}

- (id)ya_objectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self ya_objectAtIndex:index];
    } else {
        ya_recordCrashInfo(YACrashTypeArrayBeyondBounds, self.class, _cmd, nil);
        return nil;
    }
}
@end


@implementation NSMutableArray (YAResolveNilValue)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"__NSArrayM");
        ya_methodSwizzle(cls, @selector(insertObject:atIndex:), @selector(ya_insertObject:atIndex:));
        ya_methodSwizzle(cls, @selector(replaceObjectAtIndex:withObject:), @selector(ya_replaceObjectAtIndex:withObject:));
        ya_methodSwizzle(cls, @selector(objectAtIndex:), @selector(ya_objectAtIndex:));
    });
}

- (void)ya_insertObject:(id)anObject atIndex:(NSUInteger)index {
    static NSLock *lock;
    if (!lock) lock = [NSLock new];
    [lock lock];
    if (!anObject) {
        ya_recordCrashInfo(YACrashTypeArrayNilValue, self.class, _cmd, nil);
    } else {
        [self ya_insertObject:anObject atIndex:index];
    }
    [lock unlock];
}


- (void)ya_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (!anObject) {
        ya_recordCrashInfo(YACrashTypeArrayNilValue, self.class, _cmd, nil);
    } else {
        [self ya_replaceObjectAtIndex:index withObject:anObject];
    }
}

- (id)ya_objectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self ya_objectAtIndex:index];
    } else {
        ya_recordCrashInfo(YACrashTypeArrayBeyondBounds, self.class, _cmd, nil);
        return nil;
    }
}
@end
