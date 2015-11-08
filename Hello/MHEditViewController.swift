//
//  MHEditViewController.swift
//  Hello
//
//  Created by Michael Hulet on 11/8/15.
//  Copyright © 2015 Michael Hulet. All rights reserved.
//

import UIKit
class MHEditViewController: UITableViewController, NSFetchedResultsControllerDelegate{
    weak var mainViewController: MHViewController?
    var fetchedResultsController: NSFetchedResultsController?
    var editButton: UIBarButtonItem?
    @IBAction func dismiss(sender: UIBarButtonItem) -> Void{
        if tableView.editing{
            tableView.setEditing(false, animated: true)
            navigationItem.leftBarButtonItem = editButton
        }
        else{
            MHCoreDataStack.defaultStack()?.saveContext()
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    @IBAction func edit(sender: UIBarButtonItem) -> Void{
        tableView.setEditing(true, animated: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addEntry")
        navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    func addEntry() -> Void{
        let new = NSEntityDescription.insertNewObjectForEntityForName("Display", inManagedObjectContext: MHCoreDataStack.defaultStack()!.managedObjectContext) as! Display
        new.phrase = "Hello"
        MHCoreDataStack.defaultStack()?.saveContextWithCompletionHandler({ (success: Bool, error: NSError?) -> Void in
            guard success && error == nil else{
                print("You're a failure. Here's why: \(error?.localizedDescription)")
                return
            }
//            let path = self.fetchedResultsController!.indexPathForObject(new)!
//            self.tableView.insertRowsAtIndexPaths([path], withRowAnimation: .Automatic)
//            let cell = self.tableView.cellForRowAtIndexPath(path) as! MHEditViewCell
//            cell.textField.text = new.phrase
//            cell.textField.becomeFirstResponder()
        })
    }
    override func viewDidLoad() -> Void{
        super.viewDidLoad()
        editButton = navigationItem.leftBarButtonItem
        tableView.backgroundColor = UIColor.blackColor()
        let request = NSFetchRequest(entityName: "Display")
        request.sortDescriptors = [NSSortDescriptor(key: "phrase", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: MHCoreDataStack.defaultStack()!.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        do{
            try fetchedResultsController!.performFetch()
        }
        catch let error as NSError{
            print("The whole damn thing crashed. Here's why: \(error.localizedDescription)")
        }
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        guard let count = fetchedResultsController?.sections?.count else{
            return 0
        }
        return count
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        guard let count = fetchedResultsController?.sections?[section] else{
            return 0
        }
        return count.numberOfObjects
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MHEditViewCell
        cell.backgroundColor = UIColor.blackColor()
        cell.textField.text = (fetchedResultsController?.objectAtIndexPath(indexPath) as! Display).phrase
        cell.textField.textColor = UIColor.whiteColor()
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void{
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        mainViewController?.phraseLabel.text = (fetchedResultsController?.objectAtIndexPath(indexPath) as! Display).phrase
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) -> Void{
        if editingStyle == .Delete{
            MHCoreDataStack.defaultStack()?.managedObjectContext.deleteObject(fetchedResultsController!.objectAtIndexPath(indexPath) as! NSManagedObject)
            MHCoreDataStack.defaultStack()?.saveContext()
        }
    }
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) -> Void{
        for cell in tableView.visibleCells{
            (cell as! MHEditViewCell).textField.resignFirstResponder()
        }
    }
    func controllerWillChangeContent(controller: NSFetchedResultsController) -> Void{
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) -> Void{
        tableView.endUpdates()
    }
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) -> Void{
        // 1
        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        default: break
        }
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) -> Void{
        // 2
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        default: break
        }
    }
}
