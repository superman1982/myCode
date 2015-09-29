//
//  DBHelper.m
//  BaseFrameWork
//
//  Created by lin on 15/6/25.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKDBHelper.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

#define DBFileDirectory     [SKDBHelper createSqlite:@"LocalImages.sqlite"]


@implementation SKDBHelper

//获取document目录中的文件
+(NSString *)pathInDocumentDirectory:(NSString *)aFileName{
    //获取沙盒中的文档目录
    NSArray *vDocumentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *vDocumentDirectory=[vDocumentDirectories objectAtIndex:0];
    NSString *vFilePath = [vDocumentDirectory stringByAppendingPathComponent:aFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:vFilePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:vFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return vFilePath;
}

+(NSString *)createSqlite:(NSString *)aSqilteName{
    NSString *dbDirectory = [self pathInDocumentDirectory:@"DBFiles"];
    return [dbDirectory stringByAppendingPathComponent:aSqilteName];
}

-(void)createImageTable{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:DBFileDirectory];
    [queue inDatabase:^(FMDatabase *db) {
        if (db.open) {
            [db executeUpdate:@"create table if not exists  \"ImagesTable\" (\"uuID\" VARCHAR UNIQUE, \"lastModifyTime\" VARCHAR, \"type\" INTEGER, \"serverID\" VARCHAR, \"filePath\" VARCHAR)"];
        }
    }];
    
}

-(void)insertToImageTableUUID:(NSString *)uuID
               modifyTime:(NSString *)lastModifyTime
                     type:(NSNumber *) type
                 serverId:(NSString *)serverID
                 filePath:(NSString *)filePath
{
    NSLog(@"dbPath:%@",DBFileDirectory);
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:DBFileDirectory];
    [queue inDatabase:^(FMDatabase *db) {
        if (db.open) {
            NSLog(@"uuID:%@,lastModifyTime:%@,type:%@,serverID:%@,saveFilePath:%@",uuID,lastModifyTime,type,serverID,filePath);
            [db executeUpdate:@"INSERT INTO ImagesTable\
             (uuID,lastModifyTime,type,serverID,filePath)\
             VALUES (?,?,?,?,?)", uuID,lastModifyTime,type,serverID,filePath];
        }
    }];
}

-(FMResultSet *)selectImageTableUUID:(NSString *)uuID{
    NSLog(@"dbPath:%@",DBFileDirectory);
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:DBFileDirectory];
    __block FMResultSet *imageSet = nil;
    [queue inDatabase:^(FMDatabase *db) {
        if (db.open) {
            FMResultSet *result = [db executeQuery:@"select * from ImagesTable where uuID = ?",uuID];
            if ([result next]) {
                imageSet = result;
            }
        }
    }];
    
    return imageSet;
}

-(BOOL)deleteItemInImageTableWithUUID:(NSString *)uuID{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:DBFileDirectory];
    __block BOOL result = NO;
    [queue inDatabase:^(FMDatabase *db) {
        if (db.open) {
            result = [db executeUpdate:@"delete from ImagesTable where uuID = ?",uuID];
        }
    }];
    return result;
}

@end
