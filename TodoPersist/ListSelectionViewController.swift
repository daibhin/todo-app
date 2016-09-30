//
//  ListSelectionViewController.swift
//  TodoPersist
//
//  Created by David Newell on 29/09/2016.
//  Copyright © 2016 David Newell. All rights reserved.
//

import UIKit
import CoreData

class ListSelectionViewController: UIViewController  {
    var appDelegate : AppDelegate!
    var managedContext : NSManagedObjectContext!
    
    @IBOutlet weak var tableView: UITableView!
    
    var todo : Todo!
    var lists = [List]()
    
    var onModalDismissed : (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        lists = List.getLists()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        let list = lists[indexPath.row]
        cell!.textLabel!.text = list.title
        if (todo.isInList(list)) {
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell!.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tappedList = lists[indexPath.row]
        
        let isInList = todo.isInList(tappedList)
        if (isInList) {
            todo.removeListsObject(tappedList)
        } else {
            todo.addListsObject(tappedList)
        }
        
        do {
            try self.managedContext.save()
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    @IBAction func saveUpdatedListSelection(sender: AnyObject) {
        if (todo.lists.count == 0) {
            let alertController = UIAlertController(title: "List Selection", message: "A todo item must be part of at least one list", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        self.onModalDismissed!()
        self.dismissViewControllerAnimated(true) {}
    }
    
}
