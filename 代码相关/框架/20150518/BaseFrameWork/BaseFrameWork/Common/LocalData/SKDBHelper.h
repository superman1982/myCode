//
//  DBHelper.h
//  BaseFrameWork
//
//  Created by lin on 15/6/25.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

#define UUID                @"uuID"
#define LastModifyTime      @"lastModifyTime"
#define Type                @"type"
#define ServerID            @"serverID"
#define FilePath            @"filePath"

@interface SKDBHelper : NSObject

-(void)createImageTable;

-(void)insertToImageTableUUID:(NSString *)uuID
                   modifyTime:(NSString *)lastModifyTime
                         type:(NSNumber *) type
                     serverId:(NSString *)serverID
                     filePath:(NSString *)filePath;

-(FMResultSet *)selectImageTableUUID:(NSString *)uuID;

-(BOOL)deleteItemInImageTableWithUUID:(NSString *)uuID;

@end
