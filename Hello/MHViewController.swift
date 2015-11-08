//
//  MHViewController.swift
//  Hello
//
//  Created by Michael Hulet on 11/7/15.
//  Copyright © 2015 Michael Hulet. All rights reserved.
//

import UIKit
class MHViewController: UIViewController{
    @IBOutlet weak var phraseLabel: UILabel!
    var display: Display?
    override func viewWillAppear(animated: Bool) -> Void{
        super.viewWillAppear(animated)
        let edit = UILongPressGestureRecognizer(target: self, action: "presentEditViewController")
        view.addGestureRecognizer(edit)
    }
    override func viewDidAppear(animated: Bool) -> Void{
        super.viewDidAppear(animated)
        if display == nil{
            presentEditViewController()
        }
    }
    override func didReceiveMemoryWarning() -> Void{
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask{
        return .Landscape
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    func presentEditViewController() -> Void{
        let next = storyboard!.instantiateViewControllerWithIdentifier("Edit") as! UINavigationController
        (next.viewControllers.first as! MHEditViewController).mainViewController = self
        presentViewController(next, animated: true, completion: nil)
        view.removeGestureRecognizer(view.gestureRecognizers!.first!)
    }
}