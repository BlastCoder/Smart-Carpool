//
//  ViewController3.swift
//  PickUp
//
//  Created by Krish Mody on 11/4/21.
//

import UIKit

class ViewController3: UIViewController{
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue", attributes: .concurrent)
    }()
    @IBOutlet weak var grade: UITextField!
    @IBOutlet weak var name: UITextField!

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
    
    @IBAction func submitButton(_ sender: Any) {
        let childName: String = name.text!
        let childGrade: String = grade.text!
        plateNums.append(plateText.text!)
        plateText.text = ""
        print(self.plateNums)
        let instance:DATABASE = DATABASE()
        //print(instance.StudentOrder())
        instance.AddInfo(childName, childGrade, self.plateNums)
        name.text! = ""
        grade.text! = ""
        plateNums = []
        self.addedLabel.text = "Student Added Succesfully!"
        //self.addedLabel.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.addedLabel.text = ""
            //self.addedLabel.isHidden = true
        }

        //Testing Purpose, to find Student with plate, it works
        //self.background.async {
          //  print(instance.FindIDWithPlate("111AAA"))
        //}
        
    }
    @IBAction func resetTest(_ sender: Any) {
        let instance: DATABASE = DATABASE()
        instance.ResetValues()
        //not going to be in final app!
    }
    
    @IBAction func morePlates(_ sender: Any) {
        plateNums.append(plateText.text!)
        plateText.text = ""
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ViewController3: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
}

