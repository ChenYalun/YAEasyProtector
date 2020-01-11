//
//  NSObject+YADeallocOperation.h
//  YAEasyProtector <https://github.com/ChenYalun/YAEasyProtector>
//
//  Created by Chen,Yalun on 2019/8/2.
//  Copyright © 2019 Chen,Yalun. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

@interface NSObject (YADeallocOperation)
// A block can be executed before the object released.
@property (nonatomic, copy) void (^deallocOperation)(id object);
@end

