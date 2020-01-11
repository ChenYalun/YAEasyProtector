//
//  YATimerTestCase.m
//  DemoTests
//
//  Created by Chen,Yalun on 2020/1/11.
//  Copyright © 2020 Chen,Yalun. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface YADancer : NSObject
@end
@implementation YADancer
- (void)dance {
    NSLog(@"I'm singing");
}
@end


@interface YATimerTestCase : XCTestCase
@property (nonatomic, strong) YADancer *dancer;
@end
@implementation YATimerTestCase
- (void)setUp {
    self.dancer = [YADancer new];
}

- (void)testScheduledTimer {
    [NSTimer scheduledTimerWithTimeInterval:1 target:self.dancer selector:@selector(dance) userInfo:nil repeats:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.dancer = nil;
    });
}

- (void)testTimer {
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self.dancer selector:@selector(dance) userInfo:nil repeats:YES];
    [NSRunLoop.currentRunLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.dancer = nil;
    });
}
@end
