//
//  CreateEditEmployeeViewController.swift
//  CoreDataMigration
//
//  Created by RamaKrishna on 27/11/21.
//

import UIKit

class CreateEditEmployeeViewController: UIViewController {
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var salaryTF: UITextField!
    @IBOutlet weak var organisationTF: UITextField!
    
    var employeeToUpdate: Employee?
    
    var dataUtility: EmployeeDataUtility = EmployeeDataUtilityImpl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Employee"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveBtnAction(_ sender: UIButton) {
        if let employeeToUpdate = employeeToUpdate {
            updateEmployee(employeeID: employeeToUpdate.id)
        } else {
            createEmployee()
        }
        dataUtility.save()
        self.dismiss(animated: true, completion: nil)
    }
    
    func createEmployee() {
        let empID = UUID().uuidString
        let age = Int64(ageTF.text ?? "0") ?? 0
        let salary = Int64(salaryTF.text ?? "0") ?? 0
        let organisationID = organisationTF.text ?? ""
        let name = nameTF.text ?? ""
        let employee = Employee(id: empID,
                                name: name,
                                age: age,
                                salary: salary,
                                organisationID: organisationID)
        dataUtility.insertEmployee(employee)
    }
    
    func updateEmployee(employeeID: String) {
        let empID = employeeID
        let age = Int64(ageTF.text ?? "0") ?? 0
        let salary = Int64(salaryTF.text ?? "0") ?? 0
        let organisationID = organisationTF.text ?? ""
        let name = nameTF.text ?? ""
        
        let employee = Employee(id: empID,
                                name: name,
                                age: age,
                                salary: salary,
                                organisationID: organisationID)
        dataUtility.updateEmployee(employee)
    }
}

extension CreateEditEmployeeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
