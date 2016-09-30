//
//  List.swift
//  TodoPersist
//
//  Created by David Newell on 26/09/2016.
//  Copyright © 2016 David Newell. All rights reserved.
//

import UIKit
import CoreData

class List: NSManagedObject {
    @NSManaged var title: String
    @NSManaged var items: NSSet
    
    static func getLists() -> [List] {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "List")
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            return results as! [List]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return [List]()
    }
}
