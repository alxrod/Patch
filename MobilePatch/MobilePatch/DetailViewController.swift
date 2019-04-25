//
//  DetailViewController.swift
//  MobilePatch
//
//  Created by Antonio Rodriguez on 7/2/16.
//  Copyright © 2016 Antonio Rodriguez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet weak var detailDueDate: UILabel!
    @IBOutlet weak var detailDescriptionField: UITextView!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var detailNoteField: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageLoading: UIActivityIndicatorView!
    
    @IBOutlet weak var pageControl: UIPageControl!
  
    var imagePicker = UIImagePickerController()
    var taskImages: [[String:AnyObject]] = []
    var currentImage = 0
    
    
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
            if let label3 = self.detailNoteField {
                label3.text = String(detail["notes"]!)
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
    @IBAction func addPhoto(sender: AnyObject) {
        self.imageLoading.startAnimating()
        self.imageLoading.hidden = false
        self.imageView.hidden = true
//      Change all this to .Camera when experimenting on Iphone
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            print("Button capture")
            
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = false
            
//          Present the image picker view controller below which will show camera roll.
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
//      Make image outlet = to selected image.
        let imageData:NSData = UIImagePNGRepresentation(image)!
        let strBase64:String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let detail = detailItem {
            createImageAPI(appDelegate.token!, strBase64: strBase64, ParentTaskId: detail["task_id"] as! Int, success: self.imageSuccess)
        }
        
        
    }
    
    func imageSuccess(images: [[String:AnyObject]]) -> Void {
        
        taskImages = images
        self.pageControl.hidden = false
        self.pageControl.numberOfPages = taskImages.count
        self.pageControl.currentPage = 0
        
        self.imageView.hidden = false
        print ("\(taskImages.count), \(currentImage)")
        let decodedNSData:NSData = NSData(base64EncodedString: taskImages[currentImage]["base64"] as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
        let decodedImg = UIImage(data: decodedNSData)
        self.imageLoading.stopAnimating()
        self.imageLoading.hidden = true
        imageView.image = decodedImg
        print("All is good, proccess 100% done.")

    }
    
    func imagesFound(images: [[String:AnyObject]]) -> Void {
        taskImages = images
        self.pageControl.hidden = false
        self.pageControl.numberOfPages = taskImages.count
        self.pageControl.currentPage = 0
        if images != [] {
            self.imageView.hidden = false
            let decodedNSData:NSData = NSData(base64EncodedString: taskImages[0]["base64"] as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
            currentImage = 0
            let decodedImg = UIImage(data: decodedNSData)
            self.imageLoading.stopAnimating()
            self.imageLoading.hidden = true
            imageView.image = decodedImg
            print("All is good, images loaded.")
        }else {
            self.imageLoading.stopAnimating()
            self.imageLoading.hidden = true
        }
        
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if taskImages != [] {
            if (sender.direction == .Right) {
                "Check up: \(currentImage)"
                if currentImage > 0 {
                    currentImage -= 1
                    self.pageControl.currentPage = currentImage
                    let decodedNSData:NSData = NSData(base64EncodedString: taskImages[currentImage]["base64"] as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
                    let decodedImg = UIImage(data: decodedNSData)
                    imageView.image = decodedImg
                }
            } else if (sender.direction == .Left) {
                print ("Check up: \(currentImage), \(taskImages.count-1)")
                if currentImage < taskImages.count-1 {
                    currentImage += 1
                    self.pageControl.currentPage = currentImage
                    let decodedNSData:NSData = NSData(base64EncodedString: taskImages[currentImage]["base64"] as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
                    let decodedImg = UIImage(data: decodedNSData)
                    imageView.image = decodedImg
                }

            }
        }
    }

    
    @IBOutlet weak var addPhoto: UIButton!
    
//    Functions that manage textview delegate
    
    func textViewDidEndEditing(textView: UITextView) {
        print("Edit Done!")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if var task = self.detailItem {
            task["description"] = self.detailDescriptionField.text
            task["notes"] = self.detailNoteField.text
//          & sign just symbolizes other side of inout
            print(task)
            editTaskAPI(appDelegate.token!, task: &task, success: self.taskEditSuccess)
        }
    }
    func textViewDidBeginEditing(textView: UITextView) {
        print("begun edit")
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
        
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
//      This line here just gives the file the ability to monitor the status of the detail description field
        detailDescriptionField.delegate = self
        detailNoteField.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        detailDescriptionField.returnKeyType = UIReturnKeyType.Done
        detailNoteField.returnKeyType = UIReturnKeyType.Done
        self.configureView()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.pageControl.hidden = true
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let task = detailItem {
            
            var task = self.detailItem!
            let curStatus = task["status"] as! Int
            if curStatus == 1 {
                self.completeButton.hidden = true
            }
            
            findImagesAPI(appDelegate.token!, ParentTaskId: task["task_id"] as! Int, success: self.imagesFound)
            

            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "return" {
            print("This is the right segue")
            let controller = segue.destinationViewController as!
            MasterViewController
            if let detail = self.detailItem {
                controller.projectId = detail["project"] as! Int
            }
            print ("Returning")
            
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

