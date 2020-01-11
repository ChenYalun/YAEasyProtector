//
//  NSObject+YADeallocOperation.m
//  YAEasyProtector <https://github.com/ChenYalun/YAEasyProtector>
//
//  Created by Chen,Yalun on 2019/8/2.
//  Copyright © 2019 Chen,Yalun. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "NSObject+YADeallocOperation.h"
#import <objc/runtime.h>

@interface YADeallocOperationObject : NSObject
@property (nonatomic, copy) void (^deallocOperation)(id object);
@property (nonatomic, unsafe_unretained) id mainObject;
@end
@implementation YADeallocOperationObject
- (void)dealloc {
    @autoreleasepool {
        if (self.deallocOperation) {
            self.deallocOperation(self.mainObject);
        }
    }
}
@end



@implementation NSObject (YADeallocOperation)
- (void)setDeallocOperation:(void (^)(id))deallocOperation {
    YADeallocOperationObject *obj = [YADeallocOperationObject new];
    obj.deallocOperation = [deallocOperation copy];
    obj.mainObject = self;
    objc_setAssociatedObject(self, @selector(deallocOperation), obj, OBJC_ASSOCIATION_COPY);
}

- (void (^)(id))deallocOperation {
    YADeallocOperationObject *obj = objc_getAssociatedObject(self, _cmd);
    if (obj.deallocOperation) {
        return obj.deallocOperation;
    }
    return nil;
}
@end
