//
//  STDbHandle.m
//  STQuickKit
//
//  Created by yls on 13-11-21.
//
// Version 1.0.4
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "STDbHandle.h"
#import <objc/runtime.h>
#import "NSString+STExts.h"

#define DBName @"stdb.sqlite"
#define DBParentPrefix @"STDBParentID_"
#define DBChildPrefix  @"STDBChildID_"
#define kPId  @"pid__"
#define kCId  @"cid__"

#ifdef DEBUG
#ifdef STDBBUG
#define STDBLog(fmt, ...) NSLog((@"%s [Line %d]\n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define STDBLog(...)
#endif
#else
#define STDBLog(...)
#endif

enum {
    DBObjAttrInt,
    DBObjAttrFloat,
    DBObjAttrString,
    DBObjAttrData,
    DBObjAttrDate,
    DBObjAttrArray,
    DBObjAttrDictionary,
};

#define DBText  @"text"
#define DBInt   @"integer"
#define DBFloat @"real"
#define DBData  @"blob"

@interface NSDate (STDbDate)

+ (NSDate *)dateWithString:(NSString *)s;
+ (NSString *)stringWithDate:(NSDate *)date;

@end

@implementation NSDate (STDbDate)

+ (NSDate *)dateWithString:(NSString *)s;
{
    if (!s || (NSNull *)s == [NSNull null] || [s isEqual:@""]) {
        return nil;
    }
//    NSTimeInterval t = [s doubleValue];
//    return [NSDate dateWithTimeIntervalSince1970:t];
    
    return [[self dateFormatter] dateFromString:s];
}

+ (NSString *)stringWithDate:(NSDate *)date;
{
    if (!date || (NSNull *)date == [NSNull null] || [date isEqual:@""]) {
        return nil;
    }
//    NSTimeInterval t = [date timeIntervalSince1970];
//    return [NSString stringWithFormat:@"%lf", t];
    return [[self dateFormatter] stringFromDate:date];
}

+ (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return dateFormatter;
}

@end

@interface NSObject (STDbObject)

+ (id)objectWithString:(NSString *)s;
+ (NSString *)stringWithObject:(NSObject *)obj;

@end

@implementation NSObject (STDbObject)

+ (id)objectWithString:(NSString *)s;
{
    if (!s || (NSNull *)s == [NSNull null] || [s isEqual:@""]) {
        return nil;
    }
    return [NSJSONSerialization JSONObjectWithData:[s dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
}
+ (NSString *)stringWithObject:(NSObject *)obj;
{
    if (!obj || (NSNull *)obj == [NSNull null] || [obj isEqual:@""]) {
        return nil;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end

@interface STDbHandle()

@property (nonatomic) sqlite3 *sqlite3DB;
@property (nonatomic, assign) BOOL isOpened;

@end

@implementation STDbHandle

/**
 *	@brief	单例数据库
 *
 *	@return	单例
 */
+ (instancetype)shareDb
{
    static STDbHandle *stdb;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stdb = [[STDbHandle alloc] init];
        #ifdef STDb_EncryptEnable
        stdb.encryptEnable = YES;
        #endif
    });
    return stdb;
}

/**
 *	@brief	从外部导入数据库
 *
 *	@param 	dbName 	数据库名称（dbName.db）
 */
+ (void)importDb:(NSString *)dbName
{
    NSString *dbPath = [STDbHandle dbPath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dbPath]) {
        NSString *ext = [dbName pathExtension];
        NSString *extDbName = [dbName stringByDeletingPathExtension];
        NSString *extDbPath = [[NSBundle mainBundle] pathForResource:extDbName ofType:ext];
        if (extDbPath) {
            NSError *error;
            BOOL rc = [[NSFileManager defaultManager] copyItemAtPath:extDbPath toPath:dbPath error:&error];
            if (rc) {
                NSArray *tables = [STDbHandle sqlite_tablename];
                for (NSString *table in tables) {
                    NSMutableString *sql;
                    
                    sqlite3_stmt *stmt = NULL;
                    NSString *str = [NSString stringWithFormat:@"select sql from sqlite_master where type='table' and tbl_name='%@'", table];
                    STDbHandle *stdb = [STDbHandle shareDb];
                    [STDbHandle openDb];
                    if (sqlite3_prepare_v2(stdb->_sqlite3DB, [str UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
                        while (SQLITE_ROW == sqlite3_step(stmt)) {
                            const unsigned char *text = sqlite3_column_text(stmt, 0);
                            sql = [NSMutableString stringWithUTF8String:(const char *)text];
                        }
                    }
                    sqlite3_finalize(stmt);
                    stmt = NULL;
                    
                    NSRange r = [sql rangeOfString:@"("];
                    
                    // 备份数据库
                    
                    // 错误信息
                    char *errmsg = NULL;
                    
                    // 创建临时表
                    NSString *createTempDb = [NSString stringWithFormat:@"create temporary table t_backup%@", [sql substringFromIndex:r.location]];
                    int ret = sqlite3_exec(stdb.sqlite3DB, [createTempDb UTF8String], NULL, NULL, &errmsg);
                    if (ret != SQLITE_OK) {
                        NSLog(@"%s", errmsg);
                    }
                    
                    //导入数据
                    NSString *importDb = [NSString stringWithFormat:@"insert into t_backup select * from %@", table];
                    ret = sqlite3_exec(stdb.sqlite3DB, [importDb UTF8String], NULL, NULL, &errmsg);
                    if (ret != SQLITE_OK) {
                        NSLog(@"%s", errmsg);
                    }
                    // 删除旧表
                    NSString *dropDb = [NSString stringWithFormat:@"drop table %@", table];
                    ret = sqlite3_exec(stdb.sqlite3DB, [dropDb UTF8String], NULL, NULL, &errmsg);
                    if (ret != SQLITE_OK) {
                        NSLog(@"%s", errmsg);
                    }
                    // 创建新表
                    NSMutableString *createNewTl = [NSMutableString stringWithString:sql];
                    if (r.location != NSNotFound) {
                        NSString *insertStr = [NSString stringWithFormat:@"\n\t%@ %@ primary key,", kDbId, DBInt];
                        [createNewTl insertString:insertStr atIndex:r.location + 1];
                    } else {
                        return;
                    }
                    NSString *createDb = [NSString stringWithFormat:@"%@", createNewTl];
                    ret = sqlite3_exec(stdb.sqlite3DB, [createDb UTF8String], NULL, NULL, &errmsg);
                    if (ret != SQLITE_OK) {
                        NSLog(@"%s", errmsg);
                    }
                    
                    // 从临时表导入数据到新表
                    
                    NSString *cols = [[NSString alloc] init];
                    
                    NSString *t_str = [sql substringWithRange:NSMakeRange(r.location + 1, [sql length] - r.location - 2)];
                    t_str = [t_str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    t_str = [t_str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                    t_str = [t_str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    NSMutableArray *colsArr = [NSMutableArray arrayWithCapacity:0];
                    for (NSString *s in [t_str componentsSeparatedByString:@","]) {
                        NSString *s0 = [NSString stringWithString:s];
                        s0 = [s0 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        NSArray *a = [s0 componentsSeparatedByString:@" "];
                        NSString *s1 = a[0];
                        s1 = [s1 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                        [colsArr addObject:s1];
                    }
                    cols = [colsArr componentsJoinedByString:@", "];
                    
                    importDb = [NSString stringWithFormat:@"insert into %@ select (rowid-1) as %@, %@ from t_backup", table, kDbId, cols];
                    
                    ret = sqlite3_exec(stdb.sqlite3DB, [importDb UTF8String], NULL, NULL, &errmsg);
                    if (ret != SQLITE_OK) {
                        NSLog(@"%s", errmsg);
                    }
                    
                    // 删除临时表
                    dropDb = [NSString stringWithFormat:@"drop table t_backup"];
                    ret = sqlite3_exec(stdb.sqlite3DB, [dropDb UTF8String], NULL, NULL, &errmsg);
                    if (ret != SQLITE_OK) {
                        NSLog(@"%s", errmsg);
                    }
                    
                    // 加密数据库
                    if ([[self shareDb] encryptEnable]) {
                        NSMutableArray *results = [NSClassFromString(table) allDbObjects];
                        for (STDbObject *obj in results) {
                            
                            [self openDb];
                            
                            NSMutableArray *keys = [NSMutableArray arrayWithCapacity:0];
                            [STDbHandle class:obj.class getPropertyKeyList:keys];
                            
                            NSMutableArray *types = [NSMutableArray arrayWithCapacity:0];
                            [STDbHandle class:obj.class getPropertyTypeList:types];
                            
                            for (NSInteger i = 0; i < keys.count; i++) {
                                NSString *type = types[i];
                                NSString *key = keys[i];
                                
                                if ([type isEqualToString:@"text"]) {
                                    NSString *value = [[NSString alloc] initWithFormat:@"%@", [obj valueForKey:key]];
                                    if ([[self shareDb] encryptEnable]) {
                                        value = [value encryptWithKey:[self encryptKey]];
                                    }
                                    [obj setValue:value forKey:key];
                                }
                            }
                            
                            [obj updatetoDb];
                        }
                    }
                }
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
            
        } else {
            
        }
    }
}

/**
 *	@brief	打开数据库
 *
 *	@return	成功标志
 */
+ (BOOL)openDb
{
    NSString *dbPath = [STDbHandle dbPath];
    STDbHandle *db = [STDbHandle shareDb];
    
    int flags = SQLITE_OPEN_READWRITE;
    if ([[NSFileManager defaultManager] fileExistsAtPath:dbPath]) {
        flags = SQLITE_OPEN_READWRITE;
    } else {
        flags = SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE;
    }
    
    if ([STDbHandle isOpened]) {
//        STDBLog(@"数据库已打开");
        return YES;
    }

    int rc = sqlite3_open_v2([dbPath UTF8String], &db->_sqlite3DB, flags, NULL);
    if (rc == SQLITE_OK) {
//        STDBLog(@"打开数据库%@成功!", dbPath);
        
        db.isOpened = YES;
        return YES;
    } else {
        STDBLog(@"打开数据库%@失败!", dbPath);
        return NO;
    }

    return NO;
}

/*
 * 关闭数据库
 */
+ (BOOL)closeDb {
    
#ifdef STDBBUG
    NSString *dbPath = [STDb dbPath];
#endif
    
    STDbHandle *db = [STDbHandle shareDb];
    
    if (![db isOpened]) {
//        STDBLog(@"数据库已关闭");
        return YES;
    }
    
    int rc = sqlite3_close(db.sqlite3DB);
    if (rc == SQLITE_OK) {
//        STDBLog(@"关闭数据库%@成功!", dbPath);
        db.isOpened = NO;
        db.sqlite3DB = NULL;
        return YES;
    } else {
        STDBLog(@"关闭数据库%@失败!", dbPath);
        return NO;
    }
    return YES;
}

/**
 *	@brief	数据库路径
 *
 *	@return	数据库路径
 */
+ (NSString *)dbPath
{
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [NSString stringWithFormat:@"%@/%@", document, DBName];
    return path;
}

/**
 *	@brief	根据aClass表 添加一列
 *
 *	@param 	aClass 	表相关类
 *	@param 	columnName 	列名
 */
+ (void)dbTable:(Class)aClass addColumn:(NSString *)columnName
{
    if (![STDbHandle isOpened]) {
        [STDbHandle openDb];
    }
    
    NSMutableString *sql = [NSMutableString stringWithCapacity:0];
    [sql appendString:@"alter table "];
    [sql appendString:NSStringFromClass(aClass)];
    if ([columnName isEqualToString:kDbId]) {
        NSString *colStr = [NSString stringWithFormat:@"%@ %@ primary key", kDbId, DBInt];
        [sql appendFormat:@" add column %@;", colStr];
    } else {
        [sql appendFormat:@" add column %@ %@;", columnName, DBText];
    }

    char *errmsg = 0;
    STDbHandle *db = [STDbHandle shareDb];
    
    int ret = sqlite3_exec(db.sqlite3DB, [sql UTF8String], NULL, NULL, &errmsg);
    
    if(ret != SQLITE_OK){
        fprintf(stderr,"table add column fail: %s\n", errmsg);
    }
    sqlite3_free(errmsg);
    
    [STDbHandle closeDb];
}

/**
 *	@brief	根据aClass创建表
 *
 *	@param 	aClass 	表相关类
 */
+ (void)createDbTable:(Class)aClass
{
    if (![STDbHandle isOpened]) {
        [STDbHandle openDb];
    }
    
    if ([STDbHandle sqlite_tableExist:aClass]) {
        STDBLog(@"数据库表%@已存在!", NSStringFromClass(aClass));
        return;
    }
    
    if (![STDbHandle isOpened]) {
        [STDbHandle openDb];
    }
    
    NSMutableString *sql = [NSMutableString stringWithCapacity:0];
    [sql appendString:@"create table "];
    [sql appendString:NSStringFromClass(aClass)];
    [sql appendString:@"("];
    
    NSMutableArray *propertyArr = [NSMutableArray arrayWithCapacity:0];
    
    [STDbHandle class:aClass getPropertyNameList:propertyArr];
    
    NSString *propertyStr = [propertyArr componentsJoinedByString:@","];
    
    [sql appendString:propertyStr];
    
    [sql appendString:@");"];
    
    char *errmsg = 0;
    STDbHandle *db = [STDbHandle shareDb];
    sqlite3 *sqlite3DB = db.sqlite3DB;
    int ret = sqlite3_exec(sqlite3DB,[sql UTF8String], NULL, NULL, &errmsg);
    if(ret != SQLITE_OK){
//        fprintf(stderr,"create table fail: %s\n",errmsg);
    }
    sqlite3_free(errmsg);
    
    [STDbHandle closeDb];
}

/**
 *	@brief	插入一条数据
 *
 *	@param 	obj 	数据对象
 */
- (BOOL)insertDbObject:(STDbObject *)obj
{
    
    if (![STDbHandle isOpened]) {
        [STDbHandle openDb];
    }
    
    NSString *tableName = NSStringFromClass(obj.class);
    
    if (![STDbHandle sqlite_tableExist:obj.class]) {
        [STDbHandle createDbTable:obj.class];
    }
    
    if (![STDbHandle isOpened]) {
        [STDbHandle openDb];
    }
    
    NSMutableArray *propertyArr = [NSMutableArray arrayWithCapacity:0];
    propertyArr = [NSMutableArray arrayWithArray:[STDbHandle sqlite_columns:obj.class]];
    
    unsigned int argNum = [propertyArr count];
    
    NSMutableString *sql_NSString = [[NSMutableString alloc] initWithFormat:@"insert into %@ values(?)", tableName];
    NSRange range = [sql_NSString rangeOfString:@"?"];
    for (int i = 0; i < argNum - 1; i++) {
        [sql_NSString insertString:@",?" atIndex:range.location + 1];
    }
    
    sqlite3_stmt *stmt = NULL;
    STDbHandle *db = [STDbHandle shareDb];
    sqlite3 *sqlite3DB = db.sqlite3DB;
    
    // obj包含的STDbObject对象
//    NSMutableArray *subDbObjects = [NSMutableArray arrayWithCapacity:0];
    
    const char *errmsg = NULL;
    if (sqlite3_prepare_v2(sqlite3DB, [sql_NSString UTF8String], -1, &stmt, &errmsg) == SQLITE_OK) {
        for (int i = 1; i <= argNum; i++) {
            NSString * key = propertyArr[i - 1][@"title"];
            
            if ([key isEqualToString:kDbId]) {
                continue;
            }
            
            NSString *column_type_string = propertyArr[i - 1][@"type"];
            
            id value;
            NSInteger rowId = [STDbHandle lastRowIdWithClass:obj.class];
            
            if ([key hasPrefix:DBParentPrefix]) {
                key = [key stringByReplacingOccurrencesOfString:DBParentPrefix withString:@""];
                
                value = [[NSString alloc] initWithFormat:@"%d", rowId+1];
            } else {
                value = [obj valueForKey:key];
                NSObject *object = (NSObject *)value;
                if ([object isKindOfClass:[STDbObject class]]) {
                    NSInteger subDbRowId = [STDbHandle lastRowIdWithClass:object.class];
                    value = [[NSString alloc] initWithFormat:@"%d", subDbRowId+1];
                    
                    STDbObject *dbObj = (STDbObject *)object;
                    [dbObj setValue:@(rowId+1) forKey:kPId];
                    [dbObj insertToDb];
                }
            }

            if ([column_type_string isEqualToString:@"blob"]) {
                if (!value || value == [NSNull null] || [value isEqual:@""]) {
                    sqlite3_bind_null(stmt, i);
                } else {
                    NSData *data = [NSData dataWithData:value];
                    long len = [data length];
                    const void *bytes = [data bytes];
                    sqlite3_bind_blob(stmt, i, bytes, len, NULL);
                }
                
            } else if ([column_type_string isEqualToString:@"text"]) {
                if (!value || value == [NSNull null] || [value isEqual:@""]) {
                    sqlite3_bind_null(stmt, i);
                } else {
                    objc_property_t property_t = class_getProperty(obj.class, [key UTF8String]);
                    
                    value = [STDbHandle valueForDbObjc_property_t:property_t dbValue:value id:rowId];
                    NSString *column_value = [NSString stringWithFormat:@"%@", value];
                    sqlite3_bind_text(stmt, i, [column_value UTF8String], -1, SQLITE_STATIC);
                }
                
            } else if ([column_type_string isEqualToString:@"real"]) {
                if (!value || value == [NSNull null] || [value isEqual:@""]) {
                    sqlite3_bind_null(stmt, i);
                } else {
                    id column_value = value;
                    sqlite3_bind_double(stmt, i, [column_value doubleValue]);
                }
            }
            else if ([column_type_string isEqualToString:@"integer"]) {
                if (!value || value == [NSNull null] || [value isEqual:@""]) {
                    sqlite3_bind_null(stmt, i);
                } else {
                    id column_value = value;
                    sqlite3_bind_int(stmt, i, [column_value intValue]);
                }
            }
        }
        int rc = sqlite3_step(stmt);
        
        if ((rc != SQLITE_DONE) && (rc != SQLITE_ROW)) {
            fprintf(stderr,"insert dbObject fail: %s\n",errmsg);
            sqlite3_finalize(stmt);
            stmt = NULL;
            [STDbHandle closeDb];
            
            return NO;
        }
    }
    sqlite3_finalize(stmt);
    stmt = NULL;
    [STDbHandle closeDb];
    
    return YES;
}

/**
 *	@brief	根据条件查询数据
 *
 *	@param 	aClass 	表相关类
 *	@param 	condition 	条件（nil或空或all为无条件），例 id=5 and name='yls'
 *                      带条数限制条件:id=5 and name='yls' limit 5
 *	@param 	orderby 	排序（nil或空或no为不排序）, 例 id,name
 *
 *	@return	数据对象数组
 */
- (NSMutableArray *)selectDbObjects:(Class)aClass condition:(NSString *)condition orderby:(NSString *)orderby
{
    if (![STDbHandle isOpened]) {
        [STDbHandle openDb];
    }
    
    // 清除过期数据
    [STDbHandle cleanExpireDbObject:aClass];
    
    sqlite3_stmt *stmt = NULL;
    NSMutableArray *array = nil;
    NSMutableString *selectstring = nil;
    NSString *tableName = NSStringFromClass(aClass);
    
    selectstring = [[NSMutableString alloc] initWithFormat:@"select %@ from %@", @"*", tableName];
    if (condition != nil || [condition length] != 0) {
        if (![[condition lowercaseString] isEqualToString:@"all"]) {
            [selectstring appendFormat:@" where %@", condition];
        }
    }
    
    if (orderby != nil || [orderby length] != 0) {
        if (![[orderby lowercaseString] isEqualToString:@"no"]) {
            [selectstring appendFormat:@" order by %@", orderby];
        }
    }
    
    STDbHandle *db = [STDbHandle shareDb];
    sqlite3 *sqlite3DB = db.sqlite3DB;
    
    if (sqlite3_prepare_v2(sqlite3DB, [selectstring UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
        int column_count = sqlite3_column_count(stmt);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            STDbObject *obj = [[NSClassFromString(tableName) alloc] init];
            
            for (int i = 0; i < column_count; i++) {
                const char *column_name = sqlite3_column_name(stmt, i);
                const char * column_decltype = sqlite3_column_decltype(stmt, i);

                id column_value = nil;
                NSData *column_data = nil;
                
                NSString* key = [NSString stringWithFormat:@"%s", column_name];
                key = [key stringByReplacingOccurrencesOfString:DBParentPrefix withString:@""];
                
                objc_property_t property_t = class_getProperty(obj.class, [key UTF8String]);
                
                NSString *obj_column_decltype = [[NSString stringWithUTF8String:column_decltype] lowercaseString];
                if ([obj_column_decltype isEqualToString:@"text"]) {
                    const unsigned char *value = sqlite3_column_text(stmt, i);
                    if (value != NULL) {
                        column_value = [NSString stringWithUTF8String: (const char *)value];
                        id objValue = [STDbHandle valueForObjc_property_t:property_t dbValue:column_value];
                        if (objValue) {
                            [obj setValue:objValue forKey:key];
                        }
                    }
                } else if ([obj_column_decltype isEqualToString:@"integer"]) {
                    int value = sqlite3_column_int(stmt, i);
                    if (&value != NULL) {
                        column_value = [NSNumber numberWithInt: value];
                        id objValue = [STDbHandle valueForObjc_property_t:property_t dbValue:column_value];
                        [obj setValue:objValue forKey:key];
                    }
                } else if ([obj_column_decltype isEqualToString:@"real"]) {
                    double value = sqlite3_column_double(stmt, i);
                    if (&value != NULL) {
                        column_value = [NSNumber numberWithDouble:value];
                        id objValue = [STDbHandle valueForObjc_property_t:property_t dbValue:column_value];
                        [obj setValue:objValue forKey:key];
                    }
                } else if ([obj_column_decltype isEqualToString:@"blob"]) {
                    const void *databyte = sqlite3_column_blob(stmt, i);
                    if (databyte != NULL) {
                        int dataLenth = sqlite3_column_bytes(stmt, i);
                        column_data = [NSData dataWithBytes:databyte length:dataLenth];
                        id objValue = [STDbHandle valueForObjc_property_t:property_t dbValue:column_data];
                        [obj setValue:objValue forKey:key];
                    }
                } else {
                    const unsigned char *value = sqlite3_column_text(stmt, i);
                    if (value != NULL) {
                        column_value = [NSString stringWithUTF8String: (const char *)value];
                        id objValue = [STDbHandle valueForObjc_property_t:property_t dbValue:column_value];
                        [obj setValue:objValue forKey:key];
                    }
                }
            }
            if (array == nil) {
                array = [[NSMutableArray alloc] initWithObjects:obj, nil];
            } else {
                [array addObject:obj];
            }
        }
    }
    
    sqlite3_finalize(stmt);
    stmt = NULL;
    [STDbHandle closeDb];
    
    return array;
}

/**
 *	@brief	根据条件删除类
 *
 *	@param 	aClass      表相关类
 *	@param 	condition   条件（nil或空为无条件），例 id=5 and name='yls'
 *                      无条件或者all时删除所有.
 *
 *	@return	删除是否成功
 */
- (BOOL)removeDbObjects:(Class)aClass condition:(NSString *)condition
{
    if (![STDbHandle isOpened]) {
        [STDbHandle openDb];
    }
    
    sqlite3_stmt *stmt = NULL;
    int rc = -1;
    
    sqlite3 *sqlite3DB = [[STDbHandle shareDb] sqlite3DB];
    
    NSString *tableName = NSStringFromClass(aClass);
    
    // 删掉表
    if (!condition || [[condition lowercaseString] isEqualToString:@"all"]) {
        return [STDbHandle removeDbTable:aClass];
    }
    
    NSMutableString *createStr;
    
    if ([condition length] > 0) {
        createStr = [NSMutableString stringWithFormat:@"delete from %@ where %@", tableName, condition];
    } else {
        createStr = [NSMutableString stringWithFormat:@"delete from %@", tableName];
    }

    const char *errmsg = 0;
    if (sqlite3_prepare_v2(sqlite3DB, [createStr UTF8String], -1, &stmt, &errmsg) == SQLITE_OK) {
        rc = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    stmt = NULL;
    [STDbHandle closeDb];
    if ((rc != SQLITE_DONE) && (rc != SQLITE_ROW)) {
//        fprintf(stderr,"remove dbObject fail: %s\n",errmsg);
        return NO;
    }
    return YES;
}

/**
 *	@brief	根据条件修改一条数据
 *
 *	@param 	obj 	修改的数据对象（属性中有值的修改，为nil的不处理）
 *	@param 	condition 	条件（nil或空为无条件），例 id=5 and name='yls'
 *
 *	@return	修改是否成功
 */
- (BOOL)updateDbObject:(STDbObject *)obj condition:(NSString *)condition
{
    if (![STDbHandle isOpened]) {
        [STDbHandle openDb];
    }
    
    NSMutableArray *propertyTypeArr = [NSMutableArray arrayWithArray:[STDbHandle sqlite_columns:obj.class]];
    
    sqlite3_stmt *stmt = NULL;
    int rc = -1;
    NSString *tableName = NSStringFromClass(obj.class);
    NSMutableArray *propertyArr = [NSMutableArray arrayWithCapacity:0];
    sqlite3 *sqlite3DB = [[STDbHandle shareDb] sqlite3DB];
    
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(obj.class, &count);
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString * key = [[NSString alloc]initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        id objValue = [obj valueForKey:key];
        id value = [STDbHandle valueForDbObjc_property_t:property dbValue:objValue id:-1];

        if (value && (NSNull *)value != [NSNull null]) {
            NSString *bindValue = [NSString stringWithFormat:@"%@=?", key];
            [propertyArr addObject:bindValue];
            [keys addObject:key];
        }
    }
    
    NSString *newValue = [propertyArr componentsJoinedByString:@","];
    
    NSMutableString *createStr = [NSMutableString stringWithFormat:@"update %@ set %@ where %@", tableName, newValue, condition];
    
    const char *errmsg = 0;
    if (sqlite3_prepare_v2(sqlite3DB, [createStr UTF8String], -1, &stmt, &errmsg) == SQLITE_OK) {
        
        NSInteger i = 1;
        for (NSString *key in keys) {
            
            if ([key isEqualToString:kDbId]) {
                continue;
            }
            
            NSString *column_type_string = propertyTypeArr[i - 1][@"type"];
            
            id value = [obj valueForKey:key];
            
            if ([column_type_string isEqualToString:@"blob"]) {
                if (!value || value == [NSNull null] || [value isEqual:@""]) {
                    sqlite3_bind_null(stmt, i);
                } else {
                    NSData *data = [NSData dataWithData:value];
                    long len = [data length];
                    const void *bytes = [data bytes];
                    sqlite3_bind_blob(stmt, i, bytes, len, NULL);
                }
                
            } else if ([column_type_string isEqualToString:@"text"]) {
                if (!value || value == [NSNull null] || [value isEqual:@""]) {
                    sqlite3_bind_null(stmt, i);
                } else {
                    objc_property_t property_t = class_getProperty(obj.class, [key UTF8String]);
                    
                    value = [STDbHandle valueForDbObjc_property_t:property_t dbValue:value id:obj.id__];
                    NSString *column_value = [NSString stringWithFormat:@"%@", value];
        
                    sqlite3_bind_text(stmt, i, [column_value UTF8String], -1, SQLITE_STATIC);
                }
                
            } else if ([column_type_string isEqualToString:@"real"]) {
                if (!value || value == [NSNull null] || [value isEqual:@""]) {
                    sqlite3_bind_null(stmt, i);
                } else {
                    id column_value = value;
                    sqlite3_bind_double(stmt, i, [column_value doubleValue]);
                }
            }
            else if ([column_type_string isEqualToString:@"integer"]) {
                if (!value || value == [NSNull null] || [value isEqual:@""]) {
                    sqlite3_bind_null(stmt, i);
                } else {
                    id column_value = value;
                    sqlite3_bind_int(stmt, i, [column_value intValue]);
                }
            }
            i++;
        }
        
        rc = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    stmt = NULL;
    [STDbHandle closeDb];
    if ((rc != SQLITE_DONE) && (rc != SQLITE_ROW)) {
        fprintf(stderr,"update table fail: %s\n",errmsg);
        return NO;
    }
    return YES;
}

/**
 *	@brief	根据aClass删除表
 *
 *	@param 	aClass 	表相关类
 *
 *	@return	删除表是否成功
 */
+ (BOOL)removeDbTable:(Class)aClass
{
    if (![STDbHandle isOpened]) {
        [STDbHandle openDb];
    }
    
    NSMutableString *sql = [NSMutableString stringWithCapacity:0];
    [sql appendString:@"drop table if exists "];
    [sql appendString:NSStringFromClass(aClass)];

    char *errmsg = 0;
    STDbHandle *db = [STDbHandle shareDb];
    sqlite3 *sqlite3DB = db.sqlite3DB;
    int ret = sqlite3_exec(sqlite3DB,[sql UTF8String], NULL, NULL, &errmsg);
    if(ret != SQLITE_OK){
        fprintf(stderr,"drop table fail: %s\n",errmsg);
    }
    sqlite3_free(errmsg);
    
    [STDbHandle closeDb];
    
    return YES;
}

/**
 *	@brief	根据aClass清除过期数据
 *
 *	@param 	aClass 	表相关类
 *
 *	@return	清除过期表是否成功
 */
+ (BOOL)cleanExpireDbObject:(Class)aClass
{
    if (![STDbHandle isOpened]) {
        [STDbHandle openDb];
    }

    NSString *dateStr = [NSDate stringWithDate:[NSDate date]];
    NSString *condition = [NSString stringWithFormat:@"expireDate<'%@'", dateStr];
    [[[STDbHandle alloc] init] removeDbObjects:aClass condition:condition];
    
    if (![STDbHandle isOpened]) {
        [STDbHandle openDb];
    }
    
    return YES;
}

#pragma mark - other method

/*
 * 查看所有表名
 */
+ (NSArray *)sqlite_tablename {
    
    if (![STDbHandle isOpened]) {
        [STDbHandle openDb];
    }
    
    sqlite3_stmt *stmt = NULL;
    NSMutableArray *tablenameArray = [[NSMutableArray alloc] init];
    NSString *str = [NSString stringWithFormat:@"select tbl_name from sqlite_master where type='table'"];
    sqlite3 *sqlite3DB = [[STDbHandle shareDb] sqlite3DB];
    if (sqlite3_prepare_v2(sqlite3DB, [str UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
        while (SQLITE_ROW == sqlite3_step(stmt)) {
            const unsigned char *text = sqlite3_column_text(stmt, 0);
            [tablenameArray addObject:[NSString stringWithUTF8String:(const char *)text]];
        }
    }
    sqlite3_finalize(stmt);
    stmt = NULL;
    
    [STDbHandle closeDb];
    
    return tablenameArray;
}

/*
 * 判断一个表是否存在；
 */
+ (BOOL)sqlite_tableExist:(Class)aClass {
    NSArray *tableArray = [self sqlite_tablename];
    NSString *tableName = NSStringFromClass(aClass);
    for (NSString *tablename in tableArray) {
        if ([tablename isEqualToString:tableName]) {
            return YES;
        }
    }
    return NO;
}

+ (NSArray *)sqlite_columns:(Class)cls
{
    NSString *table = NSStringFromClass(cls);
    NSMutableString *sql;
    
    sqlite3_stmt *stmt = NULL;
    NSString *str = [NSString stringWithFormat:@"select sql from sqlite_master where type='table' and tbl_name='%@'", table];
    STDbHandle *stdb = [STDbHandle shareDb];
    [STDbHandle openDb];
    if (sqlite3_prepare_v2(stdb->_sqlite3DB, [str UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
        while (SQLITE_ROW == sqlite3_step(stmt)) {
            const unsigned char *text = sqlite3_column_text(stmt, 0);
            sql = [NSMutableString stringWithUTF8String:(const char *)text];
        }
    }
    sqlite3_finalize(stmt);
    stmt = NULL;
    
    NSRange r = [sql rangeOfString:@"("];
    
    NSString *t_str = [sql substringWithRange:NSMakeRange(r.location + 1, [sql length] - r.location - 2)];
    t_str = [t_str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    t_str = [t_str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    t_str = [t_str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableArray *colsArr = [NSMutableArray arrayWithCapacity:0];
    for (NSString *s in [t_str componentsSeparatedByString:@","]) {
        NSString *s0 = [NSString stringWithString:s];
        s0 = [s0 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSArray *a = [s0 componentsSeparatedByString:@" "];
        NSString *s1 = a[0];
        NSString *type = a.count >= 2 ? a[1] : @"blob";
        type = [type stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        type = [type stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        s1 = [s1 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        [colsArr addObject:@{@"type": type, @"title": s1}];
    }
    return colsArr;
}

+ (NSString *)dbTypeConvertFromObjc_property_t:(objc_property_t)property
{
    char * type = property_copyAttributeValue(property, "T");
    
    switch(type[0]) {
        case 'f' : //float
        case 'd' : //double
        {
            return DBFloat;
        }
            break;
        
        case 'c':   // char
        case 's' : //short
        case 'i':   // int
        case 'l':   // long
        {
            return DBInt;
        }
            break;

        case '*':   // char *
            break;
            
        case '@' : //ObjC object
            //Handle different clases in here
        {
            NSString *cls = [NSString stringWithUTF8String:type];
            cls = [cls stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cls = [cls stringByReplacingOccurrencesOfString:@"@" withString:@""];
            cls = [cls stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSString class]]) {
                return DBText;
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSNumber class]]) {
                return DBText;
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSDictionary class]]) {
                return DBText;
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSArray class]]) {
                return DBText;
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSDate class]]) {
                return DBText;
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSData class]]) {
                return DBData;
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[STDbObject class]]) {
                return DBText;
            }
        }
            break;
    }

    return DBText;
}

+ (NSString *)dbNameConvertFromObjc_property_t:(objc_property_t)property
{
    NSString *key = [[NSString alloc]initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
    char * type = property_copyAttributeValue(property, "T");
    
    switch(type[0]) {
        case '@' : //ObjC object
            //Handle different clases in here
        {
            NSString *cls = [NSString stringWithUTF8String:type];
            cls = [cls stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cls = [cls stringByReplacingOccurrencesOfString:@"@" withString:@""];
            cls = [cls stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            
            if ([NSClassFromString(cls) isSubclassOfClass:[STDbObject class]]) {
//                NSString *retKey = [DBParentPrefix stringByAppendingString:key];
                NSString *retKey = key;
                return retKey;
            }
        }
            break;
    }
    
    return key;
}

+ (id)valueForObjc_property_t:(objc_property_t)property dbValue:(id)dbValue
{
    char * type = property_copyAttributeValue(property, "T");
//    NSString *key = [[NSString alloc]initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
    
    switch(type[0]) {
        case 'f' : //float
        {
            return [NSNumber numberWithDouble:[dbValue floatValue]];
        }
            break;
        case 'd' : //double
        {
            return [NSNumber numberWithDouble:[dbValue doubleValue]];
        }
            break;
            
        case 'c':   // char
        {
            return [NSNumber numberWithDouble:[dbValue charValue]];
        }
            break;
        case 's' : //short
        {
            return [NSNumber numberWithDouble:[dbValue shortValue]];
        }
            break;
        case 'i':   // int
        {
            return [NSNumber numberWithDouble:[dbValue longValue]];
        }
            break;
        case 'l':   // long
        {
            return [NSNumber numberWithDouble:[dbValue longValue]];
        }
            break;
            
        case '*':   // char *
            break;
            
        case '@' : //ObjC object
            //Handle different clases in here
        {
            NSString *cls = [NSString stringWithUTF8String:type];
            cls = [cls stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cls = [cls stringByReplacingOccurrencesOfString:@"@" withString:@""];
            cls = [cls stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSString class]]) {
                NSString *retStr = [dbValue copy];
                if ([[self shareDb] encryptEnable]) {
                    retStr = [retStr decryptWithKey:[self encryptKey]];
                }
                return retStr;
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSNumber class]]) {
                return [NSNumber numberWithDouble:[dbValue doubleValue]];
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSDictionary class]]) {
                NSString *retStr = [dbValue copy];
                if ([[self shareDb] encryptEnable]) {
                    retStr = [retStr decryptWithKey:[self encryptKey]];
                }
                NSDictionary *dict = [NSDictionary objectWithString:[NSString stringWithFormat:@"%@", retStr]];
                NSMutableDictionary *results = [NSMutableDictionary dictionaryWithDictionary:dict];
                
                for (NSString *key in dict) {
                    NSObject *obj = dict[key];
                    if ([obj isKindOfClass:[NSString class]]) {
                        NSString *dbObj = [obj copy];
                        if ([dbObj hasPrefix:DBChildPrefix]) {
                            NSString *rowidStr = [dbObj stringByReplacingOccurrencesOfString:DBChildPrefix withString:@""];
                            NSArray *arr = [rowidStr componentsSeparatedByString:@","];
                            NSString *clsName = arr[0];
                            NSInteger rowid = [arr[1] integerValue];
                            
                            NSString *where = [NSString stringWithFormat:@"%@=%d", kDbId, rowid];
                            
                            STDbObject *child = (STDbObject *)[NSClassFromString(clsName) dbObjectsWhere:where orderby:nil][0];
                            [results setObject:child forKey:key];
                            
                            continue;
                        }
                    }
                    [results setObject:obj forKey:key];
                }
                return results;
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSArray class]]) {
                
                NSMutableArray *results = [NSMutableArray arrayWithCapacity:0];

                NSString *retStr = [dbValue copy];
                if ([[self shareDb] encryptEnable]) {
                    retStr = [retStr decryptWithKey:[self encryptKey]];
                }
                NSArray *dbArr = [NSArray objectWithString:[NSString stringWithFormat:@"%@", retStr]];
                
                for (NSObject *obj in dbArr) {
                    
                    if ([obj isKindOfClass:[NSString class]]) {
                        NSString *dbObj = [obj copy];
                        if ([dbObj hasPrefix:DBChildPrefix]) {
                            NSString *rowidStr = [dbObj stringByReplacingOccurrencesOfString:DBChildPrefix withString:@""];
                            NSArray *arr = [rowidStr componentsSeparatedByString:@","];
                            NSString *clsName = arr[0];
                            NSInteger rowid = [arr[1] integerValue];
                            
                            NSString *where = [NSString stringWithFormat:@"%@=%d", kDbId, rowid];
                            
                            STDbObject *child = (STDbObject *)[NSClassFromString(clsName) dbObjectsWhere:where orderby:nil][0];
                            [results addObject:child];
                            
                            continue;
                        }
                    }
                    
                    [results addObject:obj];
                }
                
                return results;
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSDate class]]) {
                NSString *retStr = [dbValue copy];
                if ([[self shareDb] encryptEnable]) {
                    retStr = [retStr decryptWithKey:[self encryptKey]];
                }
                return [NSDate dateWithString:[NSString stringWithFormat:@"%@", retStr]];
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSValue class]]) {
                return [NSData dataWithData:dbValue];
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[STDbObject class]]) {
                
                NSString *where = [[NSString alloc] initWithFormat:@"%@=%@", kDbId, dbValue];
                
                NSMutableArray *results = [NSClassFromString(cls) dbObjectsWhere:where orderby:nil];
                
                if (results.count > 0) {
                    STDbObject *obj = results[0];
                    return obj;
                } else {
                    return nil;
                }
            }
        }
            break;
    }
    
    return dbValue;
}

+ (id)valueForDbObjc_property_t:(objc_property_t)property dbValue:(id)dbValue id:(NSInteger)_id
{
    char * type = property_copyAttributeValue(property, "T");
    
    switch(type[0]) {
        case 'f' : //float
        {
            return [NSNumber numberWithDouble:[dbValue floatValue]];
        }
            break;
        case 'd' : //double
        {
            return [NSNumber numberWithDouble:[dbValue doubleValue]];
        }
            break;
            
        case 'c':   // char
        {
            return [NSNumber numberWithDouble:[dbValue charValue]];
        }
            break;
        case 's' : //short
        {
            return [NSNumber numberWithDouble:[dbValue shortValue]];
        }
            break;
        case 'i':   // int
        {
            return [NSNumber numberWithDouble:[dbValue longValue]];
        }
            break;
        case 'l':   // long
        {
            return [NSNumber numberWithDouble:[dbValue longValue]];
        }
            break;
            
        case '*':   // char *
            break;
            
        case '@' : //ObjC object
            //Handle different clases in here
        {
            NSString *cls = [NSString stringWithUTF8String:type];
            cls = [cls stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cls = [cls stringByReplacingOccurrencesOfString:@"@" withString:@""];
            cls = [cls stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSString class]]) {
                NSString *retStr = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", dbValue]];
                if ([[self shareDb] encryptEnable]) {
                    retStr = [retStr encryptWithKey:[self encryptKey]];
                }
                return retStr;
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSNumber class]]) {
                return [NSNumber numberWithDouble:[dbValue doubleValue]];
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSDictionary class]]) {
                NSMutableDictionary *results = [NSMutableDictionary dictionaryWithCapacity:0];
                
                for (NSString *key in dbValue) {
                    NSObject *obj = dbValue[key];

                    if ([obj isKindOfClass:[STDbObject class]]) {
                        STDbObject *dbObject = (STDbObject *)obj;
                        
                        [dbObject setValue:@(_id) forKey:kPId];
                        [dbObject insertToDb];
                        
                        NSInteger rowid = [dbObject.class lastRowId];
                        
                        [results setObject:[NSString stringWithFormat:@"%@%@,%d", DBChildPrefix, NSStringFromClass(obj.class),rowid]  forKey:key];
                    } else {
                        [results setObject:obj forKey:key];
                    }
                }
                
                NSString *retStr = [NSString stringWithFormat:@"%@", [NSDictionary stringWithObject:results]];
                if ([[self shareDb] encryptEnable]) {
                    retStr = [retStr encryptWithKey:[self encryptKey]];
                }
                return retStr;
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSArray class]]) {
                
                NSMutableArray *results = [NSMutableArray arrayWithCapacity:0];
                for (NSObject *obj in (NSArray *)dbValue) {
                    if ([obj isKindOfClass:[STDbObject class]]) {
                        STDbObject *dbObject = (STDbObject *)obj;
      
                        [dbObject setValue:@(_id) forKey:kPId];
                        [dbObject insertToDb];
                        
                        NSInteger rowid = [dbObject.class lastRowId];
                        
                        [results addObject:[NSString stringWithFormat:@"%@%@,%d", DBChildPrefix, NSStringFromClass(obj.class),rowid]];
                    } else {
                        [results addObject:obj];
                    }
                }
                NSString *retStr = [NSString stringWithFormat:@"%@", [NSArray stringWithObject:results]];
                if ([[self shareDb] encryptEnable]) {
                    retStr = [retStr encryptWithKey:[self encryptKey]];
                }
                return retStr;
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSDate class]]) {
                if ([dbValue isKindOfClass:[NSDate class]]) {
                    NSString *retStr = [NSString stringWithFormat:@"%@", [NSDate stringWithDate:dbValue]];
                    if ([[self shareDb] encryptEnable]) {
                        retStr = [retStr encryptWithKey:[self encryptKey]];
                    }
                    return retStr;
                } else {
                    return @"";
                }
                
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSValue class]]) {
                return [NSData dataWithData:dbValue];
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[STDbObject class]]) {
                return dbValue;
            }
        }
            break;
    }
    
    return dbValue;
}

+ (BOOL)isOpened
{
    return [[self shareDb] isOpened];
}

+ (void)class:(Class)aClass getPropertyNameList:(NSMutableArray *)proName
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(aClass, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString * key = [STDbHandle dbNameConvertFromObjc_property_t:property];
        NSString *type = [STDbHandle dbTypeConvertFromObjc_property_t:property];
        
        NSString *proStr;
        if ([key isEqualToString:kDbId]) {
            proStr = [NSString stringWithFormat:@"%@ %@ primary key", kDbId, DBInt];
        } else {
            proStr = [NSString stringWithFormat:@"%@ %@", key, type];
        }

        [proName addObject:proStr];
    }
    
    if (aClass == [STDbObject class]) {
        return;
    }
    [STDbHandle class:[aClass superclass] getPropertyNameList:proName];
}

+ (void)class:(Class)aClass getPropertyKeyList:(NSMutableArray *)proName
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(aClass, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        [proName addObject:key];
    }
    
    if (aClass == [STDbObject class]) {
        return;
    }
    [STDbHandle class:[aClass superclass] getPropertyKeyList:proName];
}

+ (void)class:(Class)aClass getPropertyTypeList:(NSMutableArray *)proName
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(aClass, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *type = [STDbHandle dbTypeConvertFromObjc_property_t:property];
        [proName addObject:type];
    }
    
    if (aClass == [STDbObject class]) {
        return;
    }
    [STDbHandle class:[aClass superclass] getPropertyTypeList:proName];
}

+ (NSInteger)lastRowIdWithClass:(Class)aClass;
{
    NSInteger rowId = 0;
    [self openDb];
    
    sqlite3_stmt *stmt = NULL;
    
    NSMutableString *sql = [NSMutableString stringWithCapacity:0];
    [sql appendString:@"select max(rowid) as rowId from "];
    [sql appendString:NSStringFromClass(aClass)];
    [sql appendString:@";"];
    
    if (sqlite3_prepare_v2([[self shareDb] sqlite3DB], [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_step(stmt);
        int value = sqlite3_column_int(stmt, 0);
        rowId = value;
    }
    sqlite3_finalize(stmt);
    stmt = NULL;
    
    return rowId;
}

+ (NSString *)encryptKey
{
    return @"stlwtr";
}

#pragma mark - 


@end




