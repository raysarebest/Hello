//
//  MHCoreDataStack.m
//
//  Created by Michael Hulet on 8/26/14.
//

#import "MHCoreDataStack.h"

static id cache = nil;
@interface MHCoreDataStack()
@property (readwrite, strong, nonatomic, nonnull) NSString *modelName;
@end
@implementation MHCoreDataStack
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
#pragma mark - Core Data Methods
-(BOOL)saveContext{
    return [self saveContext:nil];
}
-(BOOL)saveContext:(NSError * __autoreleasing  __nullable *)error{
    return self.managedObjectContext.hasChanges ? [self.managedObjectContext save:error] : YES;
}
-(void)saveContextWithCompletionHandler:(MHSaveCompletionHandler)completion{
    NSError *error = nil;
    completion([self saveContext:&error], error);
}
#pragma mark - Core Data Stack
-(NSManagedObjectContext *)managedObjectContext{
    if(!_managedObjectContext && self.persistentStoreCoordinator){
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
        _managedObjectContext.undoManager = [NSUndoManager new];
    }
    return _managedObjectContext;
}
-(NSManagedObjectModel *)managedObjectModel{
    if(!_managedObjectModel){
        NSURL *bundleURL = [[NSBundle bundleForClass:[self class]] URLForResource:self.modelName withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:bundleURL];
    }
    return _managedObjectModel;
}
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    if(!_persistentStoreCoordinator){
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self.frameworkDocumentsDirectory URLByAppendingPathComponent:[self.modelName stringByAppendingString:@".sqlite"]] options:nil error:&error]){
            //Replace this implementation with code to handle the error appropriately.
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            [[NSException exceptionWithName:@"MHCoreDataException" reason:error.localizedDescription userInfo:error.userInfo] raise];
        }
    }
    return _persistentStoreCoordinator;
}
#pragma mark - Helper Methods
-(NSURL *)frameworkDocumentsDirectory{
    NSError *error = nil;
    NSURL *directory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
    if(!directory && error){
        [[NSException exceptionWithName:@"MHCoreDataException" reason:error.localizedDescription userInfo:error.userInfo] raise];
    }
    else{
        return directory;
    }
    return nil;
}
+(instancetype)defaultStack{
    return cache;
}
+(void)resetDefault{
    [[self class] setDefaultToStack:nil];
}
+(void)setDefaultToStack:(MHCoreDataStack *)stack{
    cache = stack;
}
-(NSString *)description{
    return self.modelName;
}
#pragma mark - Intitializers
+(instancetype)stackWithModelName:(NSString *)model{
    return [[self alloc] initWithModelName:model];
}
-(instancetype)initWithModelName:(NSString *)model{
    BOOL initialized = NO;
    if(model && ![model isEqualToString:[NSString string]] && (self = [super init])){
        self.modelName = model;
        if(!cache){
            [[self class] setDefaultToStack:self];
        }
        initialized = YES;
    }
    return initialized ? self : nil;
}
-(instancetype)init{
    return [self initWithModelName:[NSString string]];
}
@end