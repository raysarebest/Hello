//
//  MHPhraseViewController.swift
//  Hello
//
//  Created by Michael Hulet on 11/25/15.
//  Copyright © 2015 Michael Hulet. All rights reserved.
//

import UIKit

//MARK: - Phrase View Controller

///View controller to display phrases onscreen
class MHPhraseViewController: UIViewController{

    //MARK: View Controller Lifecycle

    override func viewDidLoad() -> Void{
        super.viewDidLoad()
        let presentationMethod: Selector = "presentSelectionViewController"
        let pull = UIScreenEdgePanGestureRecognizer(target: self, action: presentationMethod)
        pull.edges = .Bottom
        view.addGestureRecognizer(pull)
        let swipe = UISwipeGestureRecognizer(target: self, action: presentationMethod)
        swipe.direction = .Up
        view.addGestureRecognizer(swipe)
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: presentationMethod))
    }

    //MARK: Transition Handling

    ///Presents the selection view
    func presentSelectionViewController() -> Void{
        presentViewController(UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("Selection"), animated: true, completion: nil)
    }

    //MARK: System UI Delegation

    override func prefersStatusBarHidden() -> Bool{
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask{
        return .Landscape
    }
}