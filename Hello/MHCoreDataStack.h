//
//  MHCoreDataStack.h
//
//  Created by Michael Hulet on 8/26/14.
//

@import Foundation;
@import CoreData;
/*!
 @typedef MHSaveCompletionHandler
 @discussion Block that is called at the completion of saveContextWithCompletionHandler:
 @param success Boolean value to indicate if the save process was successful
 @param error Specifies the error that occured, if any
*/
typedef void(^MHSaveCompletionHandler)(BOOL success, NSError * __nullable error);
@interface MHCoreDataStack : NSObject
///@brief The managed object context for the stack
@property (readonly, strong, nonatomic, nonnull) NSManagedObjectContext *managedObjectContext;
///@brief The managed object model for the stack
@property (readonly, strong, nonatomic, nonnull) NSManagedObjectModel *managedObjectModel;
///@brief The coordinator for this stack's persistent store
@property (readonly, strong, nonatomic, nonnull) NSPersistentStoreCoordinator *persistentStoreCoordinator;
///@brief The documents directory for this framework
@property (readonly, strong, nonatomic, nonnull) NSURL *frameworkDocumentsDirectory;
///@brief The model name this stack is initialized to
@property (readonly, strong, nonatomic, nonnull) NSString *modelName;
/*!
 @discussion Returns the first CoreData stack that was created by  initWithModelName:  or  stackWithModelName: , or one set with  setDefaultToStack: 
 @warning Returns nil if initWithModelName: or stackWithModelName: hasn't been called yet, or has been reset
 @returns The singleton instance that should always be used
*/
+(nullable instancetype)defaultStack;
///@brief Resets the object returned by defaultStack to nil
+(void)resetDefault;
/*!
 @discussion Sets the stack returned by defaultStack to be the specified stack
 @param stack The stack that defaultStack will return in the future
*/
+(void)setDefaultToStack:(nullable MHCoreDataStack *)stack;
/*!
 @brief Creates a CoreData stack for the specified model name
 @param model The name of your Xcode Data Model
 @returns A new CoreData stack for the specified model name
 */
+(nonnull instancetype)stackWithModelName:(nonnull NSString *)model;
/*!
 @brief Initializes a CoreData stack for the specified model name
 @param model The name of your Xcode Data Model
 @returns A CoreData stack for the specified model name
*/
-(nonnull instancetype)initWithModelName:(nonnull NSString *)model NS_DESIGNATED_INITIALIZER;
/*!
 @brief Writes any changes to the managed object context to the disk
 @returns A boolean value indicating if the save was successful
*/
-(BOOL)saveContext;
/*!
 @discussion Writes any changes to the managed object context to the disk, and modifies the specified error if necessary
 @param error The pointer to an NSError pointer that will indicate the failure, if any
 @returns A boolean value indicating if the save was successful
*/
-(BOOL)saveContext:(NSError * __nullable __autoreleasing * __nullable)error;
/*!
 @discussion Writes any changes to the managed object context to the disk, and executes the specified block when finished
 @param completion The block that is called when saving finishes
*/
-(void)saveContextWithCompletionHandler:(nullable MHSaveCompletionHandler)completion;
/*!
 @brief Sets up a new instance of MHCoreDataStack
 @deprecated This method will always return nil. Please use initWithModelName: instead
*/
-(nullable instancetype)init DEPRECATED_ATTRIBUTE;
@end