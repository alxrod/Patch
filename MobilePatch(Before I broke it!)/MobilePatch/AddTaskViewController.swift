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
    
    var simpleTest: Int? {
        didSet {
            self.configureView()
            // Update the view.
        }
    }

    func configureView() {
    }
    
    
    
    @IBAction func addTasktoPatch(sender: UIButton) {
        print("Description: \(self.taskDescriptionField.text!) Date: \(self.taskDateField.date)")
        let dateString = String(taskDateField.date)
//      Have to make minor adjustments in time stamp so that it can conform to python API
        
        
        var pythonDateArrayV1 = dateString.componentsSeparatedByString(" ")
        pythonDateArrayV1[2] = pythonDateArrayV1[2].stringByReplacingOccurrencesOfString("+", withString: ".")
        let pythonDateStringV2 = pythonDateArrayV1[1]+pythonDateArrayV1[2]
        let pythonDateStringV3 = pythonDateArrayV1[0] + " " + pythonDateStringV2
        print(pythonDateStringV3)
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        createTaskAPI(appDelegate.token!, taskDate: pythonDateStringV3,taskDescript: self.taskDescriptionField.text!,  ParentProjectId: 1, success: self.taskCreatedSuccessfully)
    }
    override func viewDidLoad() {
        self.configureView()
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    func taskCreatedSuccessfully(createdTask: [String:AnyObject]) {
        print("task cleared")
    }
    
}


