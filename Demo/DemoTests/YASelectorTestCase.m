//
//  YASelectorTestCase.m
//  DemoTests
//
//  Created by Chen,Yalun on 2020/1/11.
//  Copyright © 2020 Chen,Yalun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>

@interface YASecretary : NSObject
@end
@implementation YASecretary
- (void)report {
    NSLog(@"I can report.");
}
@end


@interface YABoss : NSObject
@property (nonatomic, strong) YASecretary *secretary;
@end
@implementation YABoss
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if (sel_isEqual(anInvocation.selector, NSSelectorFromString(@"report"))) {
        [anInvocation invokeWithTarget:self.secretary];
    } else {
        return [super forwardInvocation:anInvocation];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (sel_isEqual(aSelector, NSSelectorFromString(@"report"))) {
        // I can't report~~
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}
@end

@interface YASelectorTestCase : XCTestCase
@property (nonatomic, strong) YABoss *boss;
@property (nonatomic, strong) YASecretary *secretary;
@end

@implementation YASelectorTestCase

- (void)setUp {
    self.boss = [YABoss new];
    self.secretary = [YASecretary new];
    self.boss.secretary = self.secretary;
}

- (void)testClassMethod {
    [YASecretary performSelector:NSSelectorFromString(@"sing")];
}

- (void)testInstanceMethod {
    [self.secretary performSelector:@selector(shadowColor)];
}

- (void)testInstanceMethodForForwardInvocation{
    [self.boss performSelector:@selector(report)];
}
@end
