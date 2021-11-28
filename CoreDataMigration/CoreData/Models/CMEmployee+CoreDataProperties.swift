//
//  CMEmployee+CoreDataProperties.swift
//  CoreDataMigration
//
//  Created by RamaKrishna on 27/11/21.
//
//

import Foundation
import CoreData


extension CMEmployee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CMEmployee> {
        return NSFetchRequest<CMEmployee>(entityName: "CMEmployee")
    }

    @NSManaged public var empID: String
    @NSManaged public var name: String
    @NSManaged public var age: Int64
    @NSManaged public var salary: Int64
    @NSManaged public var organisationID: String
}

extension CMEmployee : Identifiable {

}
