//
//  NSDictionary+YAResolveNilValue.m
//  YAEasyProtector <https://github.com/ChenYalun/YAEasyProtector>
//
//  Created by Chen,Yalun on 2019/8/2.
//  Copyright © 2019 Chen,Yalun. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "YAEasyProtector.h"
#import "objc/runtime.h"

@implementation NSDictionary (YAResolveNilValue)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = object_getClass(self);
        ya_methodSwizzle(cls, @selector(dictionaryWithObjects:forKeys:count:), @selector(ya_dictionaryWithObjects:forKeys:count:));
        ya_methodSwizzle(cls, @selector(dictionaryWithObject:forKey:), @selector(ya_dictionaryWithObject:forKey:));
    });
}

+ (instancetype)ya_dictionaryWithObjects:(const id [])objects
                                 forKeys:(const id <NSCopying> [])keys
                                   count:(NSUInteger)cnt {
    if (!objects || !keys) {
        ya_recordCrashInfo(YACrashTypeDictionaryNilValue, self.class, _cmd, @"objects is nil or keys is nil");
        return nil;
    }
    for (NSUInteger i = 0; i < cnt; i++) {
        if (!objects[i] || !keys[i]) {
            id key = keys[i] ?: @"<null>";
            id value = objects[i] ?: @"<null>";
            NSString *userInfo = [NSString stringWithFormat:@"key is: %@, value is: %@", key, value];
            ya_recordCrashInfo(YACrashTypeDictionaryNilValue, self.class, _cmd, userInfo);
            return nil;
        }
    }
    return [self ya_dictionaryWithObjects:objects forKeys:keys count:cnt];
}

+ (instancetype)ya_dictionaryWithObject:(id)object forKey:(id <NSCopying>)key {
    if (!object || !key) {
        key = key ?: @"<null>";
        id value = object ?: @"<null>";
        NSString *userInfo = [NSString stringWithFormat:@"key is: %@, value is: %@", key, value];
        ya_recordCrashInfo(YACrashTypeDictionaryNilValue, self.class, _cmd, userInfo);
        return nil;
    }
    return [self ya_dictionaryWithObject:object forKey:key];
}
@end



@implementation NSMutableDictionary (YAResolveNilValue)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"__NSDictionaryM");
        ya_methodSwizzle(cls, @selector(setObject:forKey:), @selector(ya_setObject:forKey:));
        ya_methodSwizzle(cls, @selector(removeObjectForKey:), @selector(ya_removeObjectForKey:));
    });
}

- (void)ya_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!anObject || !aKey) {
        aKey = aKey ?: @"<null>";
        id value = anObject ?: @"<null>";
        NSString *userInfo = [NSString stringWithFormat:@"key is: %@, value is: %@", aKey, value];
        ya_recordCrashInfo(YACrashTypeDictionaryNilValue, self.class, _cmd, userInfo);
    } else {
        [self ya_setObject:anObject forKey:aKey];
    }
}

- (void)ya_removeObjectForKey:(id)aKey {
    if (!aKey) {
        NSString *userInfo = @"key is: <null>";
        ya_recordCrashInfo(YACrashTypeDictionaryNilValue, self.class, _cmd, userInfo);
    } else {
        [self ya_removeObjectForKey:aKey];
    }
}
@end
