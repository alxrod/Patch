//
//  ProjectMasterViewController.swift
//  MobilePatch
//
//  Created by Alex Rodriguez on 7/24/16.
//  Copyright © 2016 Antonio Rodriguez. All rights reserved.
//
//

import UIKit

class ProjectMasterViewController: UITableViewController {

    
    var projectMasterViewController: ProjectMasterViewController? = nil
    var currentProjects: [[String:AnyObject]] = []
    var currentTasks: [[String:AnyObject]] = []
    var curFam = 0
    var project_for_detail: [String:AnyObject] = [:]
    
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBAction func AddProject(sender: UIBarButtonItem) {
    }
    
    override func viewDidLoad() {
        print ("Loaded!")
        super.viewDidLoad()
        
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
         print ("Attempting to Call API!")
        
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        getProjects(appDelegate.token!, success: self.bgprojectGatheringSuccess)
        getProjectsByFam(appDelegate.token!, fam_id: appDelegate.currentFamily, success: self.projectGatheringSuccess)
        
//     // Grab the tasks:
        getTasks(appDelegate.token!, success: self.taskGatheringSuccess)
        curFam = appDelegate.currentFamily
        
        getFambyId(appDelegate.token!, fam_id: curFam, success: self.familyFound)
        
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Right) {
            print("Swipe Left")
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if appDelegate.user["families"]![curFam-1] === appDelegate.user["families"]![0] {
                print("There are no more families to the left.")
                
            } else {
                appDelegate.currentFamily -= 1
                curFam -= 1
                print ("CURRENT FAM: \(curFam)")
            }
            
            getProjects(appDelegate.token!, success: self.bgprojectGatheringSuccess)
            getProjectsByFam(appDelegate.token!, fam_id: appDelegate.currentFamily, success: self.projectGatheringSuccess)
            getTasks(appDelegate.token!, success: self.taskGatheringSuccess)
            getFambyId(appDelegate.token!, fam_id: curFam, success: self.familyFound)
            
            tableView.reloadData()
        }
        
        if (sender.direction == .Left) {
            print("Swipe Right")
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            let last_elm = appDelegate.user["families"]!.count - 1
            if appDelegate.user["families"]![curFam-1] === appDelegate.user["families"]![last_elm] {
                print("There are no more families to the right.")
                
            } else {
                appDelegate.currentFamily += 1
                curFam += 1
                print ("CURRENT FAM: \(curFam)")
            }
            
            getProjects(appDelegate.token!, success: self.bgprojectGatheringSuccess)
            getProjectsByFam(appDelegate.token!, fam_id: appDelegate.currentFamily, success: self.projectGatheringSuccess)
            getTasks(appDelegate.token!, success: self.taskGatheringSuccess)
            getFambyId(appDelegate.token!, fam_id: curFam, success: self.familyFound)
            tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showProject" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let project = currentProjects[indexPath.row]
                let controller = segue.destinationViewController as!
                MasterViewController
                controller.projectId = project["id"] as? Int
                print ("This is the project id! \(project["id"])")
            }
        } else if segue.identifier == "showAddProject" {
            print("transitioning to Add Project View")
            let nextViewController = (segue.destinationViewController as! AddProjectViewController)
            nextViewController.family_id = curFam
        
        } else if segue.identifier == "showProjectInfo" {
            print("tranitionting to Project Info")
            let nextViewController = (segue.destinationViewController as! ProjectDetailViewController)
            print (project_for_detail)
            nextViewController.projectfrMaster = project_for_detail
        }
    }
    
    // MARK: - Table View
    
    func bgprojectGatheringSuccess(projects: [[String:AnyObject]]) {
        tableView.reloadData()
        
        
    }
    
    func familyFound(fam: [String:AnyObject]) {
        print("Fam is found!")
        navTitle.title = fam["name"] as! String
        
        
    }
    
    func projectGatheringSuccess(projects: [[String:AnyObject]]) {
        print ("Heyyo")
        print(projects)
        currentProjects = projects
        tableView.reloadData()
        
        
    }
    
    func taskGatheringSuccess(tasks: [[String:AnyObject]]) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.currentProjects = tasks
        currentTasks = appDelegate.currentProjects
        tableView.reloadData()
        
        
    }

    
    func deleteSuccess(){
        print("deleted successfully!")
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentProjects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("Current Status of Tasks \(currentProjects)")
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ProjectTableViewCell
        //      The strings in the current task dict are from python thus can be empty and are marked as optionals in swift(require unwrapping)
//        cell.button.addTarget(self, action: "segueToInfo", forControlEvents: .TouchUpInside)
        cell.titleLabel.text = String(currentProjects[indexPath.item]["name"]!)
        cell.statusLabel.text = "\(currentProjects[indexPath.item]["status"]!)%"
        
        print("Ok somins funky here \(currentProjects[indexPath.item]["has_overdue"])")
        if currentProjects[indexPath.item]["has_overdue"]! as! Int == 1 {
            cell.overdueLabel.hidden = false
        }else{
            cell.overdueLabel.hidden = true
        }

        
        cell.buttonOutlet.tag = indexPath.row
        
        cell.buttonOutlet.addTarget(self, action: "infoAction:", forControlEvents: .TouchUpInside)
        return cell
    }
    
    @IBAction func infoAction(sender: UIButton) {
        
        let spefTask = currentProjects[sender.tag]
        project_for_detail = spefTask
        performSegueWithIdentifier("showProjectInfo", sender: self)
        print (spefTask)

    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            print("Del Info")
            print(currentProjects[indexPath.row])
            let deletingId = currentProjects[indexPath.row]["project_id"]
            print(deletingId)
            deleteProjectAPI(appDelegate.token!, project_id: deletingId as! Int, success: self.deleteSuccess)
            
            getProjects(appDelegate.token!, success: self.bgProjectGatheringSuccess)
            currentProjects.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func bgTaskGatheringSuccess(tasks: [[String:AnyObject]]) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.currentTasks = tasks
        tableView.reloadData()
        
        
    }
    
    func bgProjectGatheringSuccess(tasks: [[String:AnyObject]]) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.currentProjects = tasks
        tableView.reloadData()
        
        
    }
    
    
}


