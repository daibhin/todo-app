//
//  TodoListViewController.swift
//  TodoPersist
//
//  Created by David Newell on 14/09/2016.
//  Copyright © 2016 David Newell. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var todos = [NSManagedObject]()
    var list : NSManagedObject!
    var appDelegate : AppDelegate!
    var managedContext : NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        
        title = self.list.valueForKey("title") as? String
        self.todos = list.valueForKey("items")?.allObjects as! [NSManagedObject]
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.deleteItem(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func deleteItem(position: Int) {
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let managedContext = appDelegate.managedObjectContext
        
        let todo = todos[position]
        
        self.managedContext.deleteObject(todo)
        todos.removeAtIndex(position)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        let todo = todos[indexPath.row]
        
        cell!.textLabel!.text = todo.valueForKey("item") as? String
        
        return cell!
    }
    
    @IBAction func addItem(sender: AnyObject) {
        
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
    
    func saveItem(name: String) {

//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let managedContext = appDelegate.managedObjectContext
        
        let entityTodo =  NSEntityDescription.entityForName("Todo", inManagedObjectContext:managedContext)
        let todo = NSManagedObject(entity: entityTodo!, insertIntoManagedObjectContext: managedContext)
        
        todo.setValue(name, forKey: "item")
        todo.setValue(self.list, forKey: "list")
        
        do {
            try self.managedContext.save()
            self.todos.append(todo)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

