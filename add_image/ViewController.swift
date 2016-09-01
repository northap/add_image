//
//  ViewController.swift
//  add_image
//
//  Created by North on 9/1/2559 BE.
//  Copyright © 2559 North. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var tableView: UITableView!
    
    let imagePicker = UIImagePickerController()
    var images = [Images]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.imagePicker.delegate = self
        
        let cellNib:UINib = UINib(nibName: "ImageViewCell", bundle: nil)
        self.tableView.registerNib(cellNib, forCellReuseIdentifier: "ImageViewCell")
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.reloadCoreData()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addImageAction(sender: UIButton) {
        
        let alertController = UIAlertController(title: nil, message: "Select Source", preferredStyle: .ActionSheet)
        
        let libraryAction = UIAlertAction(title: "Image from library", style: .Default) { (alert:UIAlertAction!) in
         
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .PhotoLibrary
            
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        
        let photoAction = UIAlertAction(title: "Take a photo", style: .Default) { (alert:UIAlertAction!) in
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .Camera
            
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
        alertController.addAction(libraryAction)
        alertController.addAction(photoAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func reloadCoreData() {
        
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Images")
        
        do {
            let results = try context.executeFetchRequest(fetchRequest)
            self.images = results as! [Images]
        }
        catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    func validateDeleteImage(sender: UIButton) {
        
        let alertController = UIAlertController(title: "Confirmation", message: "Do you want to delete?", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default) { (UIAlertAction) in
            self.performDeleteImage(sender.tag)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    
    func performDeleteImage(buttonTag: Int) {
        
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        context.deleteObject(self.images[buttonTag])
        
        self.reloadCoreData()
        self.tableView.reloadData()
    }
    
    func performAddImage(pickedImage: UIImage) {
        
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let entity = NSEntityDescription.entityForName("Images", inManagedObjectContext: context)!
        
        let images = Images(entity: entity, insertIntoManagedObjectContext: context)
        images.setImage(pickedImage)
        context.insertObject(images)
        
        do {
            try context.save()
        }
        catch let error as NSError {
            print(error.debugDescription)
        }
        
        self.reloadCoreData()
        self.tableView.reloadData()
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.performAddImage(pickedImage)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.images.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:ImageViewCell = tableView.dequeueReusableCellWithIdentifier("ImageViewCell", forIndexPath: indexPath) as! ImageViewCell
        
        let image = self.images[indexPath.row]
        
        cell.setImageValue(image)
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(self.validateDeleteImage(_:)), forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let image = self.images[indexPath.row]
        let result = image.getImage()
        
        let oldWidth = result.size.width
        let scaleFactor = 115.0 / oldWidth
        
        let newHeight = result.size.height * scaleFactor
        
        return newHeight + 8
    }

}

