//
//  main.m
//  测试View释放顺序
//
//  Created by lin on 14-7-10.
//  Copyright (c) 2014年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
