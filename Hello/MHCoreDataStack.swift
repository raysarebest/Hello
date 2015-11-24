//
//  MHCoreDataStack.swift
//  Hello
//
//  Created by Michael Hulet on 11/15/15.
//  Copyright © 2015 Michael Hulet. All rights reserved.
//

import Foundation
import CoreData

extension MHCoreDataStack{
    func newInstanceOfType<Model: NSManagedObject>(model: Model.Type) -> Model{
        return NSEntityDescription.insertNewObjectForEntityForName(NSStringFromClass(model), inManagedObjectContext: managedObjectContext) as! Model
    }
}