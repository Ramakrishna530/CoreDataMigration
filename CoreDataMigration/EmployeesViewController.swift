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
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Archive action
        let updateAction = UIContextualAction(style: .normal,
                                              title: "Update") {(action, view, completionHandler) in
            let employee = self.employees[indexPath.row]
            self.updateEmployee(employee)
            completionHandler(true)
        }
        updateAction.backgroundColor = .systemGreen
        
        // Trash action
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "Delete") {(action, view, completionHandler) in
            self.deleteEmployee(at: indexPath)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
        
        return configuration
    }
    
    func updateEmployee(_ employee: Employee) {
        presentCreateEditEmployeeViewController(emp: employee)
    }
    
    func deleteEmployee(at indextPath: IndexPath) {
        let employee = self.employees[indextPath.row]
        dataUtility.deleteEmployee(employeeID: employee.id)
        employees.remove(at: indextPath.row)
        tableView.reloadData()
    }
}

extension EmployeesViewController {
    
    @IBAction func addBtnAction(_ sender: UIBarButtonItem) {
        presentCreateEditEmployeeViewController(emp: nil)
    }
    func presentCreateEditEmployeeViewController(emp: Employee?) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "CreateEditEmployeeViewController") as! CreateEditEmployeeViewController
        viewController.employeeToUpdate = emp
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.barTintColor = UIColor.orange
        navigationController.navigationBar.backgroundColor = UIColor.orange
        navigationController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(navigationController, animated: true, completion: nil)
    }
}
