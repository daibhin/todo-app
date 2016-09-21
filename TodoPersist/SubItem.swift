//
//  SubItem.swift
//  TodoPersist
//
//  Created by David Newell on 19/09/2016.
//  Copyright © 2016 David Newell. All rights reserved.
//

import UIKit
import CoreData

class SubItem: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var completed: NSNumber
    @NSManaged var item: Todo
    
    func isCompleted() -> Bool {
        return self.completed as Bool
    }
}
