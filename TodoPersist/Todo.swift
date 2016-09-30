//
//  Todo.swift
//  TodoPersist
//
//  Created by David Newell on 26/09/2016.
//  Copyright © 2016 David Newell. All rights reserved.
//

import UIKit
import CoreData

class Todo: NSManagedObject {
    @NSManaged var item: String
    @NSManaged var information: String
    @NSManaged var lists: NSSet
    @NSManaged var subItems: NSSet
    
    @NSManaged func addListsObject(list: List)
    @NSManaged func removeListsObject(list: List)
    
    func isInList(list: List) -> Bool {
        return self.lists.containsObject(list)
    }
}
