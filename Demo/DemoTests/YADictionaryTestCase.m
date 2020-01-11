//
//  YADictionaryTestCase.m
//  DemoTests
//
//  Created by Chen,Yalun on 2020/1/11.
//  Copyright © 2020 Chen,Yalun. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface YADictionaryTestCase : XCTestCase
@end

@implementation YADictionaryTestCase

static NSString *value;
static NSString *key;

- (void)testDictionaryForSyntacticSugar {
    NSDictionary *dict = @{key : value};
    dict = @{@"name" : value};
    dict = @{key : @"Aaron"};
}

- (void)testDictionaryForClassMethod {
    [NSDictionary dictionaryWithObjects:value forKeys:key];
    [NSDictionary dictionaryWithObject:value forKey:@"name"];
    [NSDictionary dictionaryWithObject:@"value" forKey:key];
}

- (void)testDictionaryForInstanceMethod {
    [[NSDictionary alloc] initWithObjectsAndKeys:value, key, nil];
    [[NSDictionary alloc] initWithObjectsAndKeys:value, @"key", nil];
}

- (void)testMutableDictionaryForClassMethod {
    [NSMutableDictionary dictionaryWithObjects:value forKeys:key];
    [NSMutableDictionary dictionaryWithObject:value forKey:@"name"];
    [NSMutableDictionary dictionaryWithObject:@"value" forKey:key];
}

- (void)testMutableDictionaryForInstanceMethod {
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:value, key, nil];
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:value, @"key", nil];
}

- (void)testMutableDictionaryForSetObject {
    [[NSMutableDictionary dictionary] setObject:value forKey:key];
    [[NSMutableDictionary dictionary] setObject:value forKey:@"key"];
    [[NSMutableDictionary dictionary] setObject:@"value" forKey:key];
    [[NSMutableDictionary dictionary] removeObjectForKey:key];
}

- (void)testMutableDictionaryForRemoveObject {
    [[NSMutableDictionary dictionary] removeObjectForKey:key];
}
@end
