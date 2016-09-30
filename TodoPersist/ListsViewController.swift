//
//  ListsViewController.swift
//  TodoPersist
//
//  Created by David Newell on 14/09/2016.
//  Copyright © 2016 David Newell. All rights reserved.
//

import UIKit
import CoreData

class ListsViewController: UIViewController {
    var appDelegate : AppDelegate!
    var managedContext : NSManagedObjectContext!

    @IBOutlet weak var tableView: UITableView!

    var todoLists = [List]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
    
        title = "Todo Lists"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        todoLists = List.getLists()
    }
    
    @IBAction func addList(sender: AnyObject) {
        let alert = UIAlertController(title: "New list",
                                      message: "Add a new todo list",
                                      preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .Default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        let textField = alert.textFields!.first
                                        self.saveList(textField!.text!)
                                        self.tableView.reloadData()
                                        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) { (action: UIAlertAction) -> Void in }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func saveList(name: String) {
        let entity =  NSEntityDescription.entityForName("List", inManagedObjectContext: self.managedContext)
        let list = List(entity: entity!, insertIntoManagedObjectContext: self.managedContext)
        
        list.setValue(name, forKey: "title")
        do {
            try self.managedContext.save()
            todoLists.append(list)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        let list = todoLists[indexPath.row]
        cell!.textLabel!.text = list.title
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoLists.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("ListToItemsSegue", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ListToItemsSegue") {
            let destination = segue.destinationViewController as! TodoListViewController
            
            let list = todoLists[sender!.row]
            destination.list = (list)
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.deleteList(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func deleteList(position: Int) {
        let list = todoLists[position]
        self.managedContext.deleteObject(list)
        todoLists.removeAtIndex(position)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
