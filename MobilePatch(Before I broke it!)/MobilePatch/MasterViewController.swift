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
    var objects = [AnyObject]()
    var currentTasks: [[String:AnyObject]] = []
    

    @IBAction func addTask(sender: UIBarButtonItem) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

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
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        getTasks(appDelegate.token!, success: self.taskGatheringSuccess)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let task = currentTasks[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = task
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        if segue.identifier == "showAddTask" {
            print("transitioning to Add Task View")
            let nextViewController = (segue.destinationViewController as! AddTaskViewController)
            nextViewController.simpleTest = 4
          
            

        }
    }

    // MARK: - Table View
    
    func taskGatheringSuccess(tasks: [[String:AnyObject]]) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.currentTasks = tasks
        currentTasks = appDelegate.currentTasks
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
//      The strings in the current task dict are from python thus can be empty and are marked as optionals in swift(require unwrapping)
        cell.textLabel?.text = String(currentTasks[indexPath.item]["description"]!)
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            print("Im lost here scotty...\(currentTasks[indexPath.row])")
            var deletingId = currentTasks[indexPath.row]["task_id"]
            deleteTaskAPI(appDelegate.token!, task_id: deletingId as! Int, success: self.deleteSuccess)
            
            appDelegate.currentTasks.removeAtIndex(indexPath.row)
            currentTasks.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

