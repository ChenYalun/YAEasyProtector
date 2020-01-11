//
//  YAKVCTestCase.m
//  DemoTests
//
//  Created by Chen,Yalun on 2020/1/11.
//  Copyright © 2020 Chen,Yalun. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface YADog : NSObject
@end
@implementation YADog
@end


@interface YAKVCTestCase : XCTestCase
@property (nonatomic, strong) YADog *dog;
@end
@implementation YAKVCTestCase

- (void)setUp {
    self.dog = [YADog new];
}

- (void)testKVCForSetValue {
    // [setValue:forUndefinedKey:]:
    [self.dog setValue:@"Aaron" forKeyPath:@"name.lastName"];
    [self.dog setValue:@"Aaron" forKey:@"name"];
}

- (void)testKVCForGetValue {
    self.dog = [YADog new];
    // [value:forUndefinedKey:]:
    [self.dog valueForKeyPath:@"name.lastName"];
    [self.dog valueForKey:@"name"];
}
@end
