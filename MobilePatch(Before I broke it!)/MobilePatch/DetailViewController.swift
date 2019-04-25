//
//  DetailViewController.swift
//  MobilePatch
//
//  Created by Antonio Rodriguez on 7/2/16.
//  Copyright © 2016 Antonio Rodriguez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var detailDueDate: UILabel!
    @IBOutlet weak var detailDescriptionField: UITextView!
    @IBOutlet weak var completeButton: UIButton!


    var detailItem: [String:AnyObject]? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label1 = self.detailDescriptionField {
                label1.text = String(detail["description"]!)
            }
            if let label2 = self.detailDueDate {
                label2.text = String(detail["due_date"]!)
            }
        }
    }
    @IBAction func completeTask(sender: UIButton) {
        if let detail = self.detailItem {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let token = appDelegate.token!
            completeTaskAPI(token, task: detail, success: self.taskCompletionSuccess)
        }

        print("clicked")
    }
    
//    Functions that manage textview delegate
    
    func textViewDidEndEditing(textView: UITextView) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if var task = self.detailItem {
            task["description"] = self.detailDescriptionField.text
//          & sign just symbolizes other side of inout
            editTaskAPI(appDelegate.token!, task: &task, success: self.taskEditSuccess)
        }
    }
    func textViewDidBeginEditing(textView: UITextView) {
    }
    
//  No function exists to end editing when TextView is entered. Thus I need to make my own

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
//          Call all necessary functions here which are required after ending edit
            return false
        }
        return true
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
//      This line here just gives the file the ability to monitor the status of the detail description field
        detailDescriptionField.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        detailDescriptionField.returnKeyType = UIReturnKeyType.Done
        self.configureView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var task = self.detailItem!
        let curStatus = task["status"] as! Int
        print(task["status"])
        if curStatus == 1 {
            self.completeButton.hidden = true
            print("completed")
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func taskCompletionSuccess(task: [String:AnyObject]) {
        print("task completed")
        self.completeButton.hidden = true
        
    }
    
    func taskEditSuccess(task: [String:AnyObject]) {
        print("task edited")
    }
}

