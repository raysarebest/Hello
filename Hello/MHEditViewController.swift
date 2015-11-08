//
//  MHEditViewController.swift
//  Hello
//
//  Created by Michael Hulet on 11/8/15.
//  Copyright © 2015 Michael Hulet. All rights reserved.
//

import UIKit

class MHEditViewController: UITableViewController{
    weak var mainViewController: MHViewController?
    @IBAction func dismiss(sender: UIBarButtonItem) -> Void{
        MHCoreDataStack.defaultStack()?.saveContext()
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func edit(sender: UIBarButtonItem) -> Void{
        tableView.setEditing(true, animated: true)
    }
}
