//
//  YAKVOTestCase.m
//  DemoTests
//
//  Created by Chen,Yalun on 2020/1/11.
//  Copyright © 2020 Chen,Yalun. All rights reserved.
//

#import <XCTest/XCTest.h>
@interface YATom : NSObject
@end
@implementation YATom
@end

@interface YAJerry : NSObject
@property (nonatomic, assign) NSUInteger age;
@end
@implementation YAJerry
@end

@interface YAKVOTestCase : XCTestCase
@property (nonatomic, strong) YATom *Tom;
@property (nonatomic, strong) YAJerry *Jerry;
@end
@implementation YAKVOTestCase
- (void)setUp {
    self.Tom = [YATom new];
    self.Jerry = [YAJerry new];
}

- (void)testRepeatAddObserverForSameArguements {
    [self.Jerry addObserver:self.Tom forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];
    [self.Jerry addObserver:self.Tom forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];
    [self.Jerry addObserver:self.Tom forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.Tom = nil;
        self.Jerry.age += 1;
    });
}

- (void)testRepeatAddObserverForDifferentArguements {
    void *context1 = &context1;
    void *context2 = &context2;
    [self.Jerry addObserver:self.Tom forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:context1];
    [self.Jerry addObserver:self.Tom forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:context2];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.Tom = nil;
        self.Jerry.age += 1;
    });
}

- (void)testRepeatRemoveObserverForSameArguements {
    void *context = &context;
    [self.Jerry addObserver:self.Tom forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:context];
    [self.Jerry removeObserver:self.Tom forKeyPath:@"age" context:context];
    [self.Jerry removeObserver:self.Tom forKeyPath:@"age" context:context];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.Tom = nil;
        self.Jerry.age += 1;
    });
}

- (void)testRepeatRemoveObserverForDifferentArguements {
    void *context = &context;
    [self.Jerry addObserver:self.Tom forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:context];
    [self.Jerry removeObserver:self.Tom forKeyPath:@"age"];
    [self.Jerry removeObserver:self.Tom forKeyPath:@"age" context:context];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.Tom = nil;
        self.Jerry.age += 1;
    });
}
@end
