//
//  ViewController3.swift
//  PickUp
//
//  Created by Krish Mody on 11/4/21.
//

import UIKit

class AddStudentPage: UIViewController{
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue", attributes: .concurrent)
    }()
    //set up vars, for text fields
    @IBOutlet weak var grade: UITextField!
    @IBOutlet weak var name: UITextField!
    var UUID: String = ""
    @IBOutlet weak var plateText: UITextField!
    var plateNums: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Student"
        grade.delegate = self
        name.delegate = self
        plateText.delegate = self
    }
    @IBOutlet weak var addedLabel: UILabel!
    //confirms that all fields are filled, before adding record
    @IBAction func submitButton(_ sender: Any) {
        guard let childName: String = name.text
        else {
            let alert = createFormAlert(about: "Name Required", withInfo: "Please include a valid name for the student.")
            present(alert, animated: true)
            return
        }
        if childName == "" {
            let alert = createFormAlert(about: "Name Required", withInfo: "Please include a valid name for the student.")
            present(alert, animated: true)
            return
        }
        guard let childGrade: String = grade.text
        else {
            let alert = createFormAlert(about: "Grade Required", withInfo: "Please include a valid grade for the student.")
            present(alert, animated: true)
            return
        }
        if childGrade == "" {
            let alert = createFormAlert(about: "Grade Required", withInfo: "Please include a valid grade for the student.")
            present(alert, animated: true)
            return
        }
        //gives info to database class
        plateNums.append(plateText.text!)
        plateText.text = ""
        
        let instance:DATABASE = DATABASE()
        
        for (index, plate) in plateNums.enumerated() {
            plateNums[index] = DATABASE.ApplyHash(plate)
        }
        
        self.UUID = instance.AddInfo(childName, childGrade, self.plateNums)
        name.text! = ""
        grade.text! = ""
        plateNums = []
        self.addedLabel.text = "Student Added Succesfully!"
        //self.addedLabel.isHidden = false
        performSegue(withIdentifier: "QRsegue", sender: self)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.addedLabel.text = ""
            //self.addedLabel.isHidden = true
        }

    }
    
    @IBAction func morePlates(_ sender: Any) {
        //for the more number plates, cycles through
        guard let plateNum: String = plateText.text
        else {
            let alert = createFormAlert(about: "Please enter valid Plate", withInfo: "Please include a plate for the student.")
            present(alert, animated: true)
            return
        }
        if plateNum == ""
        {
            let alert = createFormAlert(about: "Please enter valid Plate", withInfo: "Please include a plate for the student.")
            present(alert, animated: true)
            return
        }
        plateNums.append(plateNum)
        plateText.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let vc = segue.destination as? QRGenerator {
                vc.qrText = self.UUID
                }
    }

    func createFormAlert(about title: String, withInfo message: String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        return alert
    }
    
}

extension AddStudentPage: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
}


