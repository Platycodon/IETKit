//
//  IETModel+Persistence.m
//  CXNT
//
//  Created by Lucifer on 16/9/20.
//  Copyright © 2016年 Lucifer. All rights reserved.
//

#import "IETModel+Persistence.h"

#import "IETDataBase.h"
#import "NSSet+IETAdd.h"
#import "IETSession.h"
#import "IETModelColumn.h"

#import "NSDictionary+IETAdd.h"


static NSMutableDictionary *m_columnHash;
//static IETDataBase *m_database;
static NSString *const kIETPKColumn = @"identifer";
static NSString *const kIETClassKey = @"class";

@interface IETModel ()
@end

@implementation IETModel (Persistence)

+ (IETDataBase *)database
{
    return [[IETSession sharedObject] database];
}

+ (NSMutableDictionary *)columnsHash
{
    if (m_columnHash == nil) {
        m_columnHash = [NSMutableDictionary new];
    }
    return m_columnHash;
}

+ (NSString *)tableName
{
    return NSStringFromClass(self);
}

+ (void)initModelColums
{
    [self setPersistencePropertyName:kIETPKColumn attributes:@"TEXT" primary:YES];
    [self setPersistencePropertyName:kIETClassKey attributes:@"TEXT" primary:NO];
}

+ (void)setPersistencePropertyName:(NSString *)propertyName attributes:(NSString *)attributes
{
    [self setPersistencePropertyName:propertyName attributes:attributes primary:NO];
}

+ (void)setPersistencePropertyName:(NSString *)propertyName attributes:(NSString *)attributes primary:(BOOL)primary
{
    NSString *className = NSStringFromClass(self);
    NSMutableSet *columnsSet = [self columnsHash][className];
    
    if (columnsSet == nil) {
        columnsSet = [[NSMutableSet alloc] init];
        [self columnsHash][className] = columnsSet;
    }
    
    IETModelColumn *column = [[IETModelColumn alloc] init];
    column.columnName = propertyName;
    column.attribute = attributes;
    column.isPrimaryKey = primary;
    
    if (![columnsSet contains:column])
        [columnsSet addObject:column];
}

+ (NSSet *)columnSetForClass:(Class)class
{
    NSSet *columnSet = [[self columnsHash] objectOrNilForKey:NSStringFromClass(self)];
    if (columnSet == nil) {
        [self initModelColums];
        columnSet = [[self columnsHash] objectOrNilForKey:NSStringFromClass(self)];
    }
    return columnSet;
}

+ (void)regiserModelClass:(Class)modelClass
{
    [modelClass createdTableIfNeeded];
    [modelClass alertColumnsIfNeeded];
}


+ (void)createdTableIfNeeded
{
    NSString *sql = [NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' AND name='%@'", [[self class] tableName]];
    __block BOOL exists = NO;
    
    [[[self class] database] executeQuery:sql arguments:nil async:NO handleBlock:^NSArray *(FMResultSet *resultSet) {
        NSArray *array = nil;
        if ([resultSet next]) {
            array = @[resultSet.resultDictionary];
        }
        return array;
    } completion:^(NSArray *result) {
        exists = (result.count > 0);
    } errorBlock:nil];
    if (!exists) {
        //create table
        NSSet *columnSet = [self columnSetForClass:self];
        NSMutableString *creationString = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(", [self tableName]];
        [columnSet enumerateObjectsUsingBlock:^(IETModelColumn *column, BOOL *stop){
            NSMutableString *columnString = [self _columnStringWithColumn:column];
            
            if (columnString.length > 0) {
                [columnString appendString:@","];
                [creationString appendString:columnString];
            }
        }];
        
        NSRange lastCommaRange;
        lastCommaRange.location = creationString.length - 1, lastCommaRange.length = 1;
        [creationString deleteCharactersInRange:lastCommaRange];
        [creationString appendString:@")"];
        
        [[self database] excuteUpdate:creationString arguments:nil async:NO completion:nil errorBlock:nil];
    }
}

+ (void)alertColumnsIfNeeded
{
    NSMutableDictionary *existsColumns = [NSMutableDictionary new];
    NSString *sql = [NSString stringWithFormat:@"PRAGMA table_info(%@)", [self tableName]];
    [[self database] executeQuery:sql arguments:nil async:NO handleBlock:^NSArray *(FMResultSet *resultSet) {
        while ([resultSet next]) {
            NSString *name = [resultSet stringForColumn:@"name"];
            if (name && ![name isEqualToString:@"(null)"])
                existsColumns[name] = @YES;
        }
        return nil;
    } completion:nil errorBlock:nil];
    
    NSSet *columnSet = [self columnSetForClass:self];
    for (IETModelColumn *column in columnSet) {
        if (existsColumns[column.columnName] == nil) {
            NSString *columnString = [self _columnStringWithColumn:column];
            if (columnString.length > 0) {
                NSString *alterString = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@", [self tableName], columnString];
                [[self database] excuteUpdate:alterString arguments:nil async:NO completion:nil errorBlock:nil];
            }
        }
    }
}

+ (NSMutableString *)_columnStringWithColumn:(IETModelColumn *)column
{
    if (column == nil) return nil;
    
    NSMutableString *columnString = [[NSMutableString alloc] init];
    if (column.columnName) [columnString appendString:column.columnName];
    if (column.attribute) [columnString appendFormat:@" %@", column.attribute];
    if (column.isPrimaryKey) [columnString appendString:@" PRIMARY KEY"];
    
    return columnString;
}



- (void)autoGenerateSaveSQL:(NSString **)sql arguments:(NSArray **)args
{
    NSSet *set = [[self class] columnSetForClass:[self class]];
    
    if (self.class.tableName.length == 0 || set.count < 2) {
        NSLog(@"Table name or columns are set incorrectly! Failed to save! BTW, make sure to register you custom subclass to XIMModelManager");
        return;
    }
    
    NSMutableString *columnNames = [[NSMutableString alloc] init];
    NSMutableString *questMarks = [[NSMutableString alloc] init];
    NSMutableArray *mutableArgs = [[NSMutableArray alloc] init];
    
    [set enumerateObjectsUsingBlock:^(IETModelColumn *col, BOOL *stop){
        id arg = [self encodedObjectForColumnName:col.columnName];
        if (arg) {
            if ([col.columnName isEqualToString:kIETClassKey] && ([NSStringFromClass(self.class) isEqualToString:@"XBFenceWarning"] || [NSStringFromClass(self.class) isEqualToString:@"XIMInfoMessage"])) {
                
            }
            [columnNames appendFormat:@"%@,", col.columnName];
            [questMarks appendString:@"?,"];
            [mutableArgs addObject:arg];
        }
    }];
    
    /** delete last comma. */
    [columnNames deleteCharactersInRange:NSMakeRange(columnNames.length - 1, 1)];
    [questMarks deleteCharactersInRange:NSMakeRange(questMarks.length - 1, 1)];
    
    *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(%@) VALUES(%@)", self.class.tableName, columnNames, questMarks];
    *args = mutableArgs;
}


-(void)saveModel
{
    
    NSString *sql;
    NSArray *args;
    [self autoGenerateSaveSQL:&sql arguments:&args];
    
    if (sql&&args) {
        [[[self class] database] excuteUpdate:sql arguments:args async:YES completion:^{
            
        } errorBlock:^(NSError *error) {
            
        }];
    }
    
}

+ (instancetype)persistencedModelForKey:(NSString *)identifer
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?", [self tableName], kIETPKColumn];
    
    NSMutableArray *models = [NSMutableArray new];
    
    [[self database] executeQuery:sql arguments:@[identifer] async:NO handleBlock:^NSArray *(FMResultSet *resultSet) {
        while ([resultSet next]) {
            [models addObject:[self instanceWithResultset:resultSet]];
        }
        return models;
    } completion:^(NSArray *result) {
        
    } errorBlock:^(NSError *error) {
        
    }];
    
    return models.count>0 ? models[0]:nil;
}

-(void)deleteModel
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@=?", self.class.tableName, kIETPKColumn];
    
    [[[self class] database] excuteUpdate:sql arguments:@[self.identifer] async:YES completion:nil errorBlock:nil];
}

+ (void)deleteAllModels
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM  %@", self.class.tableName];
    
    [[[self class] database] excuteUpdate:sql arguments:nil async:NO completion:nil errorBlock:nil];
}

+(NSArray *)allModels
{
    return [self allModelsOrderBy:@"rowid" sortWay:@"DESC"];
}

+ (NSArray *)allModelsOrderBy:(NSString *)key sortWay:(NSString *)way
{
    return [self allModelsOrderBy:key sortWay:way limit:0];
}

+ (NSArray *)searchedModelsWithSearchKeyWord:(NSString *)keyWord key:(NSString *)key
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM  %@ WHERE %@ LIKE \'%%%@%%\' ", self.class.tableName, key, keyWord];
    
    NSMutableArray *models = [NSMutableArray new];
    
    [[[self class] database] executeQuery:sql arguments:nil async:NO handleBlock:^NSArray *(FMResultSet *resultSet) {
        while ([resultSet next]) {
            [models addObject:[self instanceWithResultset:resultSet]];
        }
        return nil;
    } completion:nil errorBlock:nil];
    
    return models;
}

+(NSArray *)getLimitModelsWith:(NSInteger)limit {
    return [self allModelsOrderBy:@"rowid" sortWay:@"DESC" limit:limit];
}


+ (NSArray *)allModelsOrderBy:(NSString *)key sortWay:(NSString *)way limit:(NSInteger)limit
{
    NSString *sql = nil;
    if (limit>0) {
        sql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ %@ LIMIT %@", self.class.tableName,key,way,@(limit)];
    }else{
        sql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ %@", self.class.tableName,key,way];
    }
    
    NSMutableArray *models = [NSMutableArray new];
    
    [[[self class] database] executeQuery:sql arguments:nil async:NO handleBlock:^NSArray *(FMResultSet *resultSet) {
        while ([resultSet next]) {
            [models addObject:[self instanceWithResultset:resultSet]];
        }
        return nil;
    } completion:nil errorBlock:nil];
    
    return models;
}


#pragma mark -

+ (instancetype)instanceWithResultset:(FMResultSet *)set
{
    IETModel *model = [self new];
    [set .resultDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [model decodeWithObject:obj columnName:key];
    }];
    return model;
}
- (void)decodeWithObject:(id)obj columnName:(NSString *)columnName
{
    if (obj == [NSNull null]) obj = nil;
    
    objc_property_t property = class_getProperty(self.class, [columnName UTF8String]);
    if (property) {
        const char *attrs = property_getAttributes(property);
        if (attrs[0] == 'T' && attrs[1] == '@' && attrs[2] == '"') attrs = &(attrs[3]);
        
        if (obj && strncmp(attrs, "NSURL", 5) == 0) {
            obj = [NSURL URLWithString:obj]; // if the url is invalid, obj will be nil.
        } else if (obj && strncmp(attrs, "NSDate", 6) == 0) {
            obj = [NSDate dateWithTimeIntervalSince1970:[obj doubleValue]];
        } else if (obj && strncmp(attrs, "NSDecimalNumber", 15) == 0) {
            obj = [NSDecimalNumber decimalNumberWithString:[obj stringValue]];
        } else if ([obj isKindOfClass:[NSData class]]) {
            if (strncmp(attrs, "NSDictionary", 12) == 0 ||
                strncmp(attrs, "NSArray", 7) == 0) {
                obj = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
            }
            else if (strncmp(attrs, "NSMutableDictionary", 19) == 0 ||
                     strncmp(attrs, "NSMutableArray", 14) == 0) {
                obj = [[NSKeyedUnarchiver unarchiveObjectWithData:obj] mutableCopy];
            }
            else {
                NSString *attr = [NSString stringWithCString:attrs encoding:NSUTF8StringEncoding];
                NSArray *attributes = [attr componentsSeparatedByString:@","];
                NSString *typeAttribute = [attributes objectAtIndex:0];
                if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1) {
                    NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length] - 4)];
                    Class typeClass = NSClassFromString(typeClassName);
                    if ([typeClass isSubclassOfClass:[IETModel class]]) {
                        obj = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
                    }
                }
            }
        }
        
        if (obj) [self setValue:obj forKey:columnName];
    }
}

- (id)encodedObjectForColumnName:(NSString *)columnName
{
    id obj = [self valueForKey:columnName];
    
    if ([obj isKindOfClass:[NSURL class]])
        obj = [obj absoluteString];
    else if ([obj isKindOfClass:[NSDate class]])
        obj = [NSNumber numberWithDouble:[obj timeIntervalSince1970]];
    else if ([obj isKindOfClass:[NSDictionary class]] ||
             [obj isKindOfClass:[NSArray class]] ||
             [obj isKindOfClass:[IETModel class]])
        obj = [NSKeyedArchiver archivedDataWithRootObject:obj];
    
    return obj;
}



@end











