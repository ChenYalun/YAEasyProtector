//
//  NSObject+YAKVC.m
//  YAEasyProtector <https://github.com/ChenYalun/YAEasyProtector>
//
//  Created by Chen,Yalun on 2019/8/2.
//  Copyright © 2019 Chen,Yalun. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>
#import "YAEasyProtector.h"

@implementation NSObject (YAKVC)
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    ya_recordCrashInfo(YACrashTypeKVC, self.class, _cmd, nil);
}

- (id)valueForUndefinedKey:(NSString *)key {
    ya_recordCrashInfo(YACrashTypeKVC, self.class, _cmd, nil);
    return nil;
}
@end
