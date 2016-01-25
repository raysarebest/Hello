//
//  MHCoreDataStack.swift
//  Hello
//
//  Created by Michael Hulet on 11/25/15.
//  Copyright © 2015 Michael Hulet. All rights reserved.
//

import Foundation
import CoreData

//MARK: - Class Declaration

///Easy interface to Core Data
class MHCoreDataStack: CustomStringConvertible{

    //MARK: Typealiasing

    /**
     Block called at the completion of a Core Data save operation (namely, the `saveWithCompletionHandler` method)
     
     - Parameter success: Indicates if the save was successful
     - Parameter error: An NSError object containing information as to why the save failed, or `nil` if it succeeded
    */

    typealias MHSaveCompletionHandler = (success: Bool, error: NSError?) -> (Void)

    //MARK: Properties

    ///The name of the model this stack represents
    let modelName: String

    ///The `NSManagedObjectContext` for the stack
    private(set) lazy var context: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator
        moc.undoManager = NSUndoManager()
        return moc
    }()

    ///The `NSManagedObjectModel` the stack represents
    let model: NSManagedObjectModel

    ///The Documents directory of the current bundle
    let documentsDirectory: NSURL = {
        do{
            return try NSFileManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        }
        catch{
            let error = error as NSError
            NSException(name: "MHCoreDataException", reason: error.localizedDescription, userInfo: error.userInfo).raise()
        }
        return NSURL()
    }()

    ///The `NSPersistentStoreCoordinator` for the stack
    private(set) lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model)
        do{
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.documentsDirectory.URLByAppendingPathComponent("\(self.modelName).sqlite"), options: nil)
        }
        catch{
            let error = error as NSError
            NSException(name: "MHCoreDataException", reason: error.localizedDescription, userInfo: error.userInfo).raise()
        }
        return coordinator
    }()

    ///The first Core Data stack that was created, unless manually overridden, or nil if a stack hasn't been created or set
    static var defaultStack: MHCoreDataStack?

    //MARK: Initializers

    /**
     The designated initializer for the stack
     
     - Parameter modelName: The name of the `.xcdatamodeld` file this stack manages, without the file extension
     - Returns: A newly-created stack configured for the specified model
    */

    init?(modelName: String){
        let modelName = modelName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        self.modelName = modelName
        self.model = NSManagedObjectModel(contentsOfURL: NSBundle(forClass: self.dynamicType).URLForResource(modelName, withExtension: "momd")!)!
        guard modelName != "" else{
            return nil
        }
        if MHCoreDataStack.defaultStack == nil{
            MHCoreDataStack.defaultStack = self
        }
    }

    //MARK: Object Management

    /**
     Creates and returns a new `NSManagedObject` (or subclass) for the specified class, and inserts it into the stack's `NSManagedObjectContext`
    
     - Parameter model: The type of the object that should be created
     - Returns: New `NSManagedObject` (or subclass thereof) configured to the specified class
    */

    func newInstanceOfType<Model: NSManagedObject>(model: Model.Type) -> Model{
        return NSEntityDescription.insertNewObjectForEntityForName(NSStringFromClass(model), inManagedObjectContext: context) as! Model
    }

    /**
     Creates and returns a new `NSManagedObject` (or subclass) for the specified class, and inserts it into the stack's `NSManagedObjectContext`

     - Parameter model: The String representation of the type of the object that should be created
     - Returns: New `NSManagedObject` (or subclass thereof) configured to the specified class
     */

    func newInstanceOfType(model: String) -> NSManagedObject{
        return NSEntityDescription.insertNewObjectForEntityForName(model, inManagedObjectContext: context)
    }

    ///Writes all changes to the `NSManagedObjectContext` to the disk, if there are any

    func save() throws -> Void{
        if context.hasChanges{
            do{
                try context.save()
            }
            catch{
                throw error
            }
        }
    }

    /**
     Writes all changes to the `NSManagedObjectContext` to the disk, if there are any
     
     - Returns: A boolean value indicating if the save was successful
    */

    func save() -> Bool{
        if context.hasChanges{
            do{
                try context.save()
                return true
            }
            catch{
                return false
            }
        }
        else{
            return true
        }
    }

    /**
     Writes all changes to the `NSManagedObjectContext` to the disk, if there are any, and runs the specified closure when the save completes
     
     * NOTE:
     
     This method is the safest way to save, as it makes active attempts to prevent database corruption that the other methods in this class cannot

     - Parameter completion: The closure to be called at the finish of the save operation
     */

    func save(completion: MHSaveCompletionHandler) -> Void{
        context.performBlock{() -> Void in
            if self.context.hasChanges{
                do{
                    try self.context.save()
                    completion(success: true, error: nil)
                }
                catch{
                    completion(success: false, error: error as NSError)
                }
            }
        }
    }

    /**
     Removes the specified object from the stack's `NSManagedObjectContext` and the corresponding persistent store
     
     - Parameter object: The object to delete
     - Parameter async: Boolean value indicating if the deletion should be performed asynchronously
    */

    func delete(object: NSManagedObject, async: Bool = false) -> Void{
        if async{
            context.performBlock({() -> Void in
                self.context.deleteObject(object)
            })
        }
        else{
            context.performBlockAndWait({() -> Void in
                self.context.deleteObject(object)
            })
        }
    }

    //MARK: CustomStringConvertible Conformance

    var description: String{
        get{
            return modelName
        }
    }
}