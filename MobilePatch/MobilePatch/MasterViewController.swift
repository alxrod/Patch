//
//  MasterViewController.swift
//  MobilePatch
//
//  Created by Antonio Rodriguez on 7/2/16.
//  Copyright © 2016 Antonio Rodriguez. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var currentTasks: [[String:AnyObject]] = []
    
    var projectId: Int? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }


    @IBAction func addTask(sender: UIBarButtonItem) {
        
    }
    
    func configureView() {
        print("Configuring View...")
        print ("This is the id of the project getting: \(projectId)")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        getTasksHostId(appDelegate.token!, project_id: projectId!, success: self.taskGatheringSuccess)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()

//        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(insertNewObject(_:)))
//        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let task = currentTasks[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = task
                
            }
        }
        if segue.identifier == "showAddTask" {
            let nextViewController = (segue.destinationViewController as! AddTaskViewController)
            nextViewController.project_id = projectId!
          
            

        }
    }

    // MARK: - Table View
    
    
    func taskGatheringSuccess(tasks: [[String:AnyObject]]) {
        currentTasks = tasks
        tableView.reloadData()
        
        
    }
    
    func bgTaskGatheringSuccess(tasks: [[String:AnyObject]]) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.currentTasks = tasks
        tableView.reloadData()
        
        
    }
    
    

    
    func deleteSuccess(){
        print("deleted successfully!")
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTasks.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TaskTableViewCell
//      The strings in the current task dict are from python thus can be empty and are marked as optionals in swift(require unwrapping)
        cell.titleLabel.text = String(currentTasks[indexPath.item]["description"]!)
        if currentTasks[indexPath.item]["is_overdue"] as! Int == 1 {
            cell.statusLabel.hidden = false
        }else{
            cell.statusLabel.hidden = true
        }
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            print("Del Info")
            print(currentTasks[indexPath.row])
            let deletingId = currentTasks[indexPath.row]["task_id"]
            print(deletingId)
            deleteTaskAPI(appDelegate.token!, task_id: deletingId as! Int, success: self.deleteSuccess)
            
            getTasks(appDelegate.token!, success: self.bgTaskGatheringSuccess)
            currentTasks.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

