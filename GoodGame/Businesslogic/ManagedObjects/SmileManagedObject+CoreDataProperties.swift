//
//  SmileManagedObject+CoreDataProperties.swift
//  
//
//  Created by Alexey Pak on 29/05/2018.
//
//

import Foundation
import CoreData


extension SmileManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SmileManagedObject> {
        return NSFetchRequest<SmileManagedObject>(entityName: "Smile")
    }

    @NSManaged public var id: Int32

}
