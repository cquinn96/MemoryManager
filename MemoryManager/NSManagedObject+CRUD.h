//
//  NSManagedObject+CRUD.h
//  MemoryManager
//
//  Created by Cormac Quinn on 19/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSManagedObject(CRUD)

+ (NSString *)entityName;
+ (NSManagedObjectContext *)database;
+ (id)createObject;
+ (id)readOrCreateObjectWithParamterName:(NSString *)parameterName andValue:(id)parameterValue;
+ (id)readObjectWithParamterName:(NSString *)parameterName andValue:(id)parameterValue;
+ (NSArray*)readObjectsWithPredicate:(NSPredicate*)pred andSortKey:(NSString*)sortKey;
+ (NSArray *)readAllObjects;
+ (void)removeAllObjects;
+ (void)deleteObject:(NSObject *)object;
+ (BOOL)saveDatabase;

@end