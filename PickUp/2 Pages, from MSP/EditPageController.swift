//
//  EditPageController.swift
//  PickUp
//
//  Created by Krish Patel on 3/8/22.
//

import UIKit

class EditPageController: UIViewController {

    var studentID: String = ""
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue", attributes: .concurrent)
    }()
    @IBOutlet weak var ChildName: UITextField!
    @IBOutlet weak var ChildGrade: UITextField!
    
    
    var studentValue: NSDictionary = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        ChildName.delegate = self
        ChildGrade.delegate = self
        
        self.background.async {
            let instance: DATABASE = DATABASE()
            self.studentValue = instance.GetInfoWithID(self.studentID)
            print(self.studentValue)
            self.addInfo()
        }
        
    }
    func addInfo() {
        DispatchQueue.main.async { [weak self] in
            //confirms that the fields are filled before submits
            self?.ChildName.text = self!.studentValue["Name"]! as? String
            self?.ChildGrade.text = self!.studentValue["Grade"]! as? String
        }
    }
   
    @IBOutlet weak var saveLabeled: UILabel!

    @IBAction func SaveButton(_ sender: Any) {
        //saves the fields
        let instance: DATABASE = DATABASE()
        instance.EditAllInfo(studentID, ChildName.text!, ChildGrade.text!)
        self.saveLabeled.text = "Saved Changes!"
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.saveLabeled.text = ""
        }
    }
        // Uncomment the following line to preserve selection between presentations
    @IBAction func deleteRecord(_ sender: Any) {
        //for delete record field
        let instance: DATABASE = DATABASE()
        instance.RemoveStudent(self.studentID)
        self.ChildName.text = ""
        self.ChildGrade.text = ""
        self.saveLabeled.text = "Deleted Student!"
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.saveLabeled.text = ""
        }
    }
    
    func createFormAlert(about title: String, withInfo message: String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        return alert
    }

}
extension EditPageController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
}

