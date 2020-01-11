//
//  YAArrayTestCase.m
//  Demo
//
//  Created by Chen,Yalun on 2020/1/11.
//  Copyright © 2020 Chen,Yalun. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface YAArrayTestCase : XCTestCase
@end

@implementation YAArrayTestCase

static NSString *key;
static NSString *value;

- (void)testArrayForSyntacticSugar {
    NSArray *array = @[@"", value];
    [array class];
}

- (void)testArrayForObjectAtIndex {
    [@[] objectAtIndex:3];
}

- (void)testMutableArrayForAddObject {
    [[NSMutableArray array] addObject:value];
    [[NSMutableArray arrayWithObjects:@"place", nil] addObject:value];
}

- (void)testMutableArrayForInsertObject {
    [[NSMutableArray array] insertObject:value atIndex:0];
    [[NSMutableArray array] insertObject:@"" atIndex:5];
}

- (void)testMutableArrayForObjectAtIndex {
    [[NSMutableArray arrayWithObjects:@"", nil] objectAtIndex:3];
}

- (void)testArrayForReplaceObject {
    [[NSMutableArray arrayWithObjects:@"place", nil] replaceObjectAtIndex:0 withObject:value];
}
@end
