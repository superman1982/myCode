//
//  JasonManager.h
//  iPad
//
//  Jackson
//

#import <Foundation/Foundation.h>

@interface JasonManager : NSObject {
    // Jason串的值HashMap
    NSMutableDictionary* mDataHashMap;
}

// 以一个Jason字符串作为构造函数
- (id) initWithString: (NSString *) aJasonStr;

// 解析Jason字符串
-(void) paraseJasonString: (NSString *) aJasonStr;

// 取一个Jason字符串的值
- (NSString *) getKeyValue: (NSString *) aKey;

@end
