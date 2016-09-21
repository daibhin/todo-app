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
}
