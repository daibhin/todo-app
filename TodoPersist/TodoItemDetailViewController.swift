//
//  TodoItemDetailViewController.swift
//  TodoPersist
//
//  Created by David Newell on 18/09/2016.
//  Copyright © 2016 David Newell. All rights reserved.
//

import UIKit
import CoreData

class TodoItemDetailViewController: UIViewController, UITableViewDataSource {
    var appDelegate : AppDelegate!
    var managedContext : NSManagedObjectContext!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    var todo : Todo!
    var todoSubItems = [SubItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        
        title = self.todo.item
        
        self.textView.text = self.todo.information
        self.todoSubItems = todo.subItems.allObjects as! [SubItem]
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        addToolbarToKeyboard()
    }
    
    func addToolbarToKeyboard() {
        let toolbar = UIToolbar.init()
        toolbar.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(saveDescription))
        toolbar.setItems([spacer, doneButton], animated: false)
        textView.inputAccessoryView = toolbar
    }
    
    func saveDescription(sender: AnyObject) {
        todo.information = textView.text
        do {
            try self.managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        view.endEditing(true)
    }
    
    @IBAction func addSubItem(sender: AnyObject) {
        let alert = UIAlertController(title: "New sub item",
                                      message: "Add a new todo sub item",
                                      preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .Default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        let textField = alert.textFields!.first
                                        self.saveSubItem(textField!.text!)
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
    
    func saveSubItem(name: String) {
        let entitySubItem = NSEntityDescription.entityForName("SubItem", inManagedObjectContext:managedContext)
        let subItem = SubItem(entity: entitySubItem!, insertIntoManagedObjectContext: managedContext)
        
        subItem.name = name
        subItem.item = self.todo
        
        do {
            try self.managedContext.save()
            self.todoSubItems.append(subItem)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoSubItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        let subItem = todoSubItems[indexPath.row]
        
        if (subItem.isCompleted()) {
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell!.accessoryType = UITableViewCellAccessoryType.None
        }
        cell!.textLabel!.text = subItem.name
        
        return cell!
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.deleteItem(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tappedItem = todoSubItems[indexPath.row]
        
        let completed = tappedItem.isCompleted()
        tappedItem.completed = !completed

        do {
            try self.managedContext.save()
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func deleteItem(position: Int) {
        let todo = todoSubItems[position]
        self.managedContext.deleteObject(todo)
        todoSubItems.removeAtIndex(position)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
