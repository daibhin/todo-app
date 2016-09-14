//
//  ViewController.swift
//  TodoPersist
//
//  Created by David Newell on 13/09/2016.
//  Copyright © 2016 David Newell. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var todos = [NSManagedObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"Todo List\""
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.deleteItem(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func deleteItem(position: Int) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let todo = todos[position]

        managedContext.deleteObject(todo)
        todos.removeAtIndex(position)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Todo")
        
        //3
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            todos = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        let todo = todos[indexPath.row]
        
        cell!.textLabel!.text = todo.valueForKey("item") as? String
        
        return cell!
    }
    
    @IBAction func addName(sender: AnyObject) {
        
        let alert = UIAlertController(title: "New item",
                                      message: "Add a new todo item",
                                      preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .Default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        let textField = alert.textFields!.first
                                        self.saveItem(textField!.text!)
                                        self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
                              animated: true,
                              completion: nil)
    }
    
    func saveItem(item: String) {
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Todo", inManagedObjectContext:managedContext)
        
        let todo = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        //3
        todo.setValue(item, forKey: "item")
        
        //4
        do {
            try managedContext.save()
            //5
            todos.append(todo)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

