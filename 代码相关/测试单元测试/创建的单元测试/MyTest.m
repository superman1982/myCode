//
//  MyTest.m
//  测试单元测试
//
//  Created by lin on 14-12-23.
//  Copyright (c) 2014年 lin. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface MyTest : XCTestCase

@end

@implementation MyTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
