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
    @IBAction func dismiss(sender: UIBarButtonItem) -> Void{
        MHCoreDataStack.defaultStack()?.saveContext()
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func edit(sender: UIBarButtonItem) -> Void{
        tableView.setEditing(true, animated: true)
    }
    override func viewDidLoad() -> Void{
        super.viewDidLoad()
        fetchedResultsController = NSFetchedResultsController(fetchRequest: NSFetchRequest(entityName: "Display"), managedObjectContext: MHCoreDataStack.defaultStack()!.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "phrase", ascending: true)]
        fetchedResultsController?.delegate = self
        do{
            try fetchedResultsController?.performFetch()
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
}
