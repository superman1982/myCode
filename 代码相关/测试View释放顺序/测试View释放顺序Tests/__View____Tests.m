//
//  __View____Tests.m
//  测试View释放顺序Tests
//
//  Created by lin on 14-7-10.
//  Copyright (c) 2014年 lin. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface __View____Tests : XCTestCase

@end

@implementation __View____Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
