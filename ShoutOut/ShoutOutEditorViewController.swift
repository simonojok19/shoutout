//
//  ShoutOutEditorViewController.swift
//  ShoutOut

import UIKit
import CoreData

class ShoutOutEditorViewController: UIViewController,
                                    ManagedObjectContextDependentType,
                                    UIPickerViewDataSource,
                                    UIPickerViewDelegate {
    
    var managedObjectContext: NSManagedObjectContext!
    
	@IBOutlet weak var toEmployeePicker: UIPickerView!
	@IBOutlet weak var shoutCategoryPicker: UIPickerView!
	@IBOutlet weak var messageTextView: UITextView!
	@IBOutlet weak var fromTextField: UITextField!
    
    let shoutCategories = [
        "Great Job!",
        "Awesome Work!",
        "Well Done!",
        "Amazing Effort!"
    ]
    var employees: [Employee] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
        fetchEmployees()
        
        self.shoutCategoryPicker.dataSource = self
        self.shoutCategoryPicker.delegate = self
        self.shoutCategoryPicker.tag = 1
        
        self.toEmployeePicker.dataSource = self
        self.toEmployeePicker.delegate = self
        self.toEmployeePicker.tag = 0
		
		messageTextView.layer.borderWidth = CGFloat(0.5)
		messageTextView.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0).cgColor
		messageTextView.layer.cornerRadius = 5
		messageTextView.clipsToBounds = true
	}

	@IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
		self.dismiss(animated: true, completion: nil)
	}
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag == 0 ? self.employees.count : self.shoutCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            let employee = self.employees[row]
            return "\(employee.firstName) \(employee.lastName)"
        } else {
            return shoutCategories[row]
        }
    }
    
    func fetchEmployees() {
        let employeeFetchRequest = NSFetchRequest<Employee>(entityName: Employee.entityName)
        let primarySortDescriptor = NSSortDescriptor(key: #keyPath(Employee.lastName), ascending: true)
        let secondarySortDescription = NSSortDescriptor(key: #keyPath(Employee.firstName), ascending: true)
        
        employeeFetchRequest.sortDescriptors = [primarySortDescriptor, secondarySortDescription]
        do {
            self.employees = try self.managedObjectContext.fetch(employeeFetchRequest)
        } catch {
            print("Error occurred")
        }
    }
}
