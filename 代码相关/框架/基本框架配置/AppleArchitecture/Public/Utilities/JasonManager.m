//
//  JasonManager.m
//  iPad
//
//  Jackosn.He
//

#import "JasonManager.h"
#import "ARCMacros.h"

@interface JasonManager()
// 分解一对Jason串
- (void) paraseKeyAndValue: (NSString *) aJasonStr;
@end

@implementation JasonManager

#pragma mark -
#pragma mark 自定义类方法
// 以一个Jason字符串作为构造函数
- (id) initWithString: (NSString *) aJasonStr {
    self = [super init];
    if (self != nil) {
        [self paraseJasonString: aJasonStr];
    } 
    return self;
}

// 分解一对Jason串
- (void) paraseKeyAndValue: (NSString *) aJasonStr {
    // Jason串中分隔的符号:
    NSString *vFlag = @"\":";
    // 取vFlag的范围
    NSRange vRange = [aJasonStr rangeOfString: vFlag];
    // 将vFlag的位置和长度赋值
    int vLocation = vRange.location; 
    // vRange.length = 0，则不存在,
    if (vRange.length > 0) {
        NSString *vKey = [aJasonStr substringToIndex: vLocation + 1];
        // 需要去掉前后的"
        vKey = [vKey substringFromIndex: 1];
        vKey = [vKey substringToIndex: [vKey length] - 1];
        
        NSString *vValue = [aJasonStr substringFromIndex: vLocation + [vFlag length]];
        if ([vValue hasPrefix: @"\""]) {
            // 需要去掉前后的"
            vValue = [vValue substringFromIndex: 1];
            vValue = [vValue substringToIndex: [vValue length] - 1];
        }
        
        [mDataHashMap setObject: vValue forKey: [vKey lowercaseString]];
    }
}

// 解析Jason字符串
-(void) paraseJasonString: (NSString *) aJasonStr {
    if (mDataHashMap == nil) {
        mDataHashMap = [[NSMutableDictionary alloc] initWithDictionary: [NSMutableDictionary dictionary]]; 
    }
    
    [mDataHashMap removeAllObjects];
    
    // 需要首先把两边的{}去掉
    aJasonStr = [aJasonStr substringFromIndex: 1];
    aJasonStr = [aJasonStr substringToIndex: [aJasonStr length] - 1];
    
    // 内部用到的临时字符串
    NSMutableString *vTmpStr1 = [[NSMutableString alloc] init];
    @try {
        // Jason串中分隔的符号,
        NSString *vFlag = @",\"";
        // 在aURL中找到vFlag的位置
        NSRange vRange = [aJasonStr rangeOfString: vFlag]; 
        // 先把aJasonStr赋值给vTmpStr1，vTmpStr1中始终放最后一个需要解析的字符串
        [vTmpStr1 setString: aJasonStr];        
        while (vRange.length > 0) {
            // 将vFlag的位置和长度赋值
            int vLocation = vRange.location; 
            // vTmpStr2为vFlag1前面的字符串内部用到的临时字符串
            NSMutableString* vTmpStr2 = [[NSMutableString alloc] init];
            @try {
                // vTmpStr2为第一个需要解析的字符串
                NSString *vTmpStr = [vTmpStr1 substringToIndex: vLocation];
                [vTmpStr2 setString: vTmpStr];
                // 解析vTmpStr2字符串
                [self paraseKeyAndValue: vTmpStr2];
                
                // vTmpStr1中始终放最后一个需要解析的字符串
                vTmpStr = [vTmpStr1 substringFromIndex: vLocation + [vFlag length] - 1];
                // 设置vTmpStr1为vFlag1后面的字符串
                [vTmpStr1 setString: vTmpStr];
                
                // 取vFlag1的范围
                vRange = [vTmpStr1 rangeOfString: vFlag];
            } @finally {
                SAFE_ARC_RELEASE(vTmpStr2);
            }
        }
        
        // 这样就表示只有一个关键串
        [self paraseKeyAndValue: vTmpStr1];
    } @finally {
        SAFE_ARC_RELEASE(vTmpStr1);
    }
}

// 取一个Jason字符串的值
- (NSString *) getKeyValue: (NSString *) aKey {
    id vTmpObject = [mDataHashMap objectForKey: aKey];
    if (vTmpObject != nil && [vTmpObject isKindOfClass: [NSString class]]) {
        return (NSString*) vTmpObject;    
    }
    return nil;
}

#pragma mark -
#pragma mark 系统方法
// dealloc函数 
- (void) dealloc {
    if (mDataHashMap != nil) {
        SAFE_ARC_RELEASE(mDataHashMap);
		mDataHashMap = nil;
    }
    
    SAFE_ARC_SUPER_DEALLOC();
}

@end
