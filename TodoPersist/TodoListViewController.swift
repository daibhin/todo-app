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
    var appDelegate : AppDelegate!
    var managedContext : NSManagedObjectContext!
    
    @IBOutlet weak var tableView: UITableView!
    
    var todos = [Todo]()
    var list : List!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        
        title = self.list.title
        self.todos = list.items.allObjects as! [Todo]
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        let todo = todos[indexPath.row]
        cell!.textLabel!.text = todo.item
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("ItemToDetailSegue", sender: indexPath)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ItemToDetailSegue") {
            let destination = segue.destinationViewController as! TodoItemDetailViewController
            let todo = todos[sender!.row]
            destination.todo = todo
        }
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
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func saveItem(name: String) {
        let entityTodo =  NSEntityDescription.entityForName("Todo", inManagedObjectContext:managedContext)
        let todo = Todo(entity: entityTodo!, insertIntoManagedObjectContext: managedContext)
        
        todo.item = name
        todo.setValue(self.list, forKey: "list")
        
        do {
            try self.managedContext.save()
            self.todos.append(todo)
        } catch {
            print("Could not save \(error)")
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.deleteItem(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func deleteItem(position: Int) {
        let todo = todos[position]
        self.managedContext.deleteObject(todo)
        todos.removeAtIndex(position)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

