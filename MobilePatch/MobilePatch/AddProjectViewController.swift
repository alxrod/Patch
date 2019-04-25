//
//  AddProjectkViewController.swift
//  MobilePatch
//
//  Created by Alex Rodriguez on 8/28/16.
//  Copyright © 2016 Antonio Rodriguez. All rights reserved.
//

import UIKit

class AddProjectViewController: UIViewController {
    
    
    @IBOutlet weak var projectDescriptionField: UITextField!
    
    @IBOutlet weak var projectDateField: UIDatePicker!
    
    var family_id: Int? {
        didSet {
            self.configureView()
            // Update the view.
        }
    }
    
    var task_Added = false
    
    func configureView() {
        print ("Family Id passed in as: \(family_id)")
    }
    
    
    @IBAction func addProject(sender: AnyObject) {
        print("Description: \(self.projectDescriptionField.text!) Date: \(self.projectDateField.date)")
        let dateString = String(projectDateField.date)
        //      Have to make minor adjustments in time stamp so that it can conform to python API
        
        
        var pythonDateArrayV1 = dateString.componentsSeparatedByString(" ")
        pythonDateArrayV1[2] = pythonDateArrayV1[2].stringByReplacingOccurrencesOfString("+", withString: ".")
        let pythonDateStringV2 = pythonDateArrayV1[1]+pythonDateArrayV1[2]
        let pythonDateStringV3 = pythonDateArrayV1[0] + " " + pythonDateStringV2
        print(pythonDateStringV3)
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        createProjectAPI(appDelegate.token!, projectDate: pythonDateStringV3, projectDescript: self.projectDescriptionField.text!,  FamilyId: family_id!, success: self.projectCreatedSuccessfully)

        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "return_tasks" {
//            print("This is the right segue")
//            let controller = segue.destinationViewController as!
//            MasterViewController
//            if let family_id = self.family_id {
//                controller.projectId = family_id
//            }
//            print ("Returning")
//            
//        }
    }
    
    override func viewDidLoad() {
        self.configureView()
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    func projectCreatedSuccessfully(createdProject: [String:AnyObject]) {
        task_Added = true
        performSegueWithIdentifier("return_projects", sender: self)
    }
    
}



