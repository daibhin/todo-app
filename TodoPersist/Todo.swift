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
    @NSManaged var list: List
    @NSManaged var subItems: NSSet
}
