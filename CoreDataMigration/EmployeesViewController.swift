//
//  EmployeesViewController.swift
//  CoreDataMigration
//
//  Created by RamaKrishna on 27/11/21.
//

import UIKit

struct Employee {
    let id: String
    let name: String
    let age: Int64
    let salary: Int64
    let organisationID: String
}
class EmployeesViewController: UIViewController {
    var employees = [Employee]()
    var dataUtility: EmployeeDataUtility = EmployeeDataUtilityImpl()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Employees"
        self.employees = dataUtility.getEmployees()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.employees = dataUtility.getEmployees()
        self.tableView.reloadData()
    }

}

extension EmployeesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        let emp = employees[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = emp.name
        content.secondaryText = "Age - \(emp.age)"
        cell.contentConfiguration = content
        return cell
    }
    
    
}

extension EmployeesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension EmployeesViewController {
    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        let empID = UUID().uuidString
        let organisationID = "1"
        let name = "Emp - \(employees.count+1)"
        let age: Int64 = Int64.random(in: 20...60)
        let salary: Int64 = Int64.random(in: 50000...500000)
        let employee = Employee(id: empID,
                                name: name,
                                age: age,
                                salary: salary,
                                organisationID: organisationID)
        dataUtility.insertEmployee(employee)
        dataUtility.save()
        employees.append(employee)
        tableView.reloadData()
    }
}
