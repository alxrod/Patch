//
//  ProjectDetailViewController.swift
//  MobilePatch
//
//  Created by Alex Rodriguez on 8/29/16.
//  Copyright © 2016 Antonio Rodriguez. All rights reserved.
//

import Foundation

import UIKit

class ProjectDetailViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var projectNameField: UITextView!
    
    @IBOutlet weak var projectDueDateField: UITextView!
    
    @IBOutlet weak var projectStatusField: UITextView!
    
    @IBOutlet weak var projectTaskView: UITextView!
    
    
    var projectfrMaster: [String:AnyObject]? {
        didSet {
            // Update the view.
        }
    }
//
    func configureView() {
        if let detail = self.projectfrMaster {
            if let field1 = self.projectNameField {
                field1.text = String(detail["name"]!)
            }
            if let field2 = self.projectDueDateField {
                field2.text = String(detail["due_date"]!)
            }
            if let field3 = self.projectStatusField {
                field3.text = "\(detail["status"]!)%"
            }
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            getTasksHostId(appDelegate.token!, project_id: detail["id"] as! Int, success: self.taskSuccess)
        }
    }
    
    func taskSuccess(tasks: [[String:AnyObject]]) -> Void {
        var stringList = ""
        for i in tasks {
            let min_str = "-\(i["description"]!) \n"
            stringList = stringList + min_str
        }
        print ("This shit succeeded and this is what it looms like: \(stringList)")
        if let field4 = self.projectTaskView {
            print ("Not checkin out")
            field4.text = stringList
        }
        
    }
    
//
//    Functions that manage textview delegate
//
//    func textViewDidEndEditing(textView: UITextView) {
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        if var project = self.projectfrMaster {
//            project["name"] = self.projectNameField.text
//            //          & sign just symbolizes other side of inout
//            editProjectAPI(appDelegate.token!, projec: &project, success: self.projectEditSuccess)
//        }
//    }
//    func textViewDidBeginEditing(textView: UITextView) {
//    }
    

//    
//    //  No function exists to end editing when TextView is entered. Thus I need to make my own
//    
//    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        if(text == "\n") {
//            textView.resignFirstResponder()
//            //          Call all necessary functions here which are required after ending edit
//            return false
//        }
//        return true
//    }
//    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        projectNameField.delegate = self
        projectNameField.returnKeyType = UIReturnKeyType.Done
        
        
//        //      This line here just gives the file the ability to monitor the status of the detail description field
//        detailDescriptionField.delegate = self
//        
//        // Do any additional setup after loading the view, typically from a nib.
//        detailDescriptionField.returnKeyType = UIReturnKeyType.Done
//        self.configureView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        var task = self.detailItem!
//        let curStatus = task["status"] as! Int
//        print(task["status"])
//        if curStatus == 1 {
//            self.completeButton.hidden = true
//            print("completed")
//        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "return" {
//            print("This is the right segue")
//            let controller = segue.destinationViewController as!
//            MasterViewController
//            if let detail = self.detailItem {
//                controller.projectId = detail["project"] as! Int
//            }
//            print ("Returning")
            
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func taskCompletionSuccess(task: [String:AnyObject]) {
        print("task completed")
//        self.completeButton.hidden = true
        
    }
    
    func taskEditSuccess(task: [String:AnyObject]) {
        print("task edited")
    }
}

