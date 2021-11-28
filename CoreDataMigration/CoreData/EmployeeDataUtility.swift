//
//  EmployeeDataUtility.swift
//  CoreDataMigration
//
//  Created by RamaKrishna on 27/11/21.
//

import Foundation

protocol EmployeeDataUtility {
    func insertEmployee(_ emp: Employee)
    @discardableResult func updateEmployee(_ emp: Employee) -> Bool
    func getEmployees() -> [Employee]
    @discardableResult func deleteEmployee(employeeID: String) -> Bool
    func save()
}

class EmployeeDataUtilityImpl: EmployeeDataUtility {
    
    var dataManager: CoreDataManager
    
    init(dataManager: CoreDataManager = CoreDataManagerImpl.shared) {
        self.dataManager = dataManager
    }
    
    func insertEmployee(_ emp: Employee) {
        let employeeMO = dataManager.insert(CMEmployee.self)
        employeeMO.empID = emp.id
        employeeMO.name = emp.name
        employeeMO.age = emp.age
        employeeMO.salary = emp.salary
        employeeMO.organisationID = emp.organisationID
    }
    
    @discardableResult func updateEmployee(_ emp: Employee) -> Bool {
        var updateStatus = false
        if let employeeMO = getEmployee(empID: emp.id)  {
            employeeMO.salary = emp.salary
            employeeMO.age = emp.age
            employeeMO.name = emp.name
            employeeMO.organisationID = emp.organisationID
            updateStatus = true
        }
        return updateStatus
    }
    
    func getEmployees() -> [Employee] {
        let employeeMOs = dataManager.fetchResults(query: nil,
                                                   type: CMEmployee.self)
        let employees = employeeMOs.map { $0.createEmployee() }
        
        return employees
    }
    
    private func getEmployee(empID: String) -> CMEmployee? {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(CMEmployee.empID), empID)
        let employee = dataManager.fetchResults(query: predicate,
                                                type: CMEmployee.self).first
        return employee
    }
    
    @discardableResult func deleteEmployee(employeeID: String) -> Bool {
        var deleteStatus = false
        if let employeeMO = getEmployee(empID: employeeID)  {
            dataManager.delete(object: employeeMO)
            deleteStatus = true
        }
        return deleteStatus
    }
    
    func save() {
        dataManager.save()
    }
}
