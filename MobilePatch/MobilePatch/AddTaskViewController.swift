//
//  AddTaskViewController.swift
//  MobilePatch
//
//  Created by Alex Rodriguez on 7/14/16.
//  Copyright © 2016 Antonio Rodriguez. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var taskDateField: UIDatePicker!
    @IBOutlet weak var taskDescriptionField: UITextField!
    @IBOutlet weak var taskNotesField: UITextView!
    
    var project_id: Int? {
        didSet {
            self.configureView()
            // Update the view.
        }
    }
    
    var task_Added = false

    func configureView() {
        print ("Project Id passed in ass: \(project_id)")
    }
    
    
    
    @IBAction func addTasktoPatch(sender: UIButton) {
        print("Description: \(self.taskDescriptionField.text!) Date: \(self.taskDateField.date), Notes: \(self.taskNotesField.text!)")
        let dateString = String(taskDateField.date)
//      Have to make minor adjustments in time stamp so that it can conform to python API
        
        
        var pythonDateArrayV1 = dateString.componentsSeparatedByString(" ")
        pythonDateArrayV1[2] = pythonDateArrayV1[2].stringByReplacingOccurrencesOfString("+", withString: ".")
        let pythonDateStringV2 = pythonDateArrayV1[1]+pythonDateArrayV1[2]
        let pythonDateStringV3 = pythonDateArrayV1[0] + " " + pythonDateStringV2
        print(pythonDateStringV3)
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        createTaskAPI(appDelegate.token!, taskDate: pythonDateStringV3,taskNotes: taskNotesField.text!,taskDescript: self.taskDescriptionField.text!,   ParentProjectId: project_id!, success: self.taskCreatedSuccessfully)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "return_tasks" {
            print("This is the right segue")
            let controller = segue.destinationViewController as!
            MasterViewController
            if let project_id = self.project_id {
                controller.projectId = project_id
            }
            print ("Returning")
            
        }
    }
    
    override func viewDidLoad() {
        self.configureView()
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    func taskCreatedSuccessfully(createdTask: [String:AnyObject]) {
        task_Added = true
        performSegueWithIdentifier("return_tasks", sender: self)
    }
    
}


