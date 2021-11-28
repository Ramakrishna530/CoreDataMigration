//
//  CMEmployee+CoreDataClass.swift
//  CoreDataMigration
//
//  Created by RamaKrishna on 27/11/21.
//
//

import Foundation
import CoreData 

@objc(CMEmployee)
public class CMEmployee: NSManagedObject {

    func createEmployee() -> Employee {
        let employee = Employee(id: empID,
                                name: name,
                                age: age,
                                salary: salary,
                                organisationID: organisationID)
        return employee
    }
}
