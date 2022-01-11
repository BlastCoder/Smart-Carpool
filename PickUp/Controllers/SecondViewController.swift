//
//  SecondViewController.swift
//  PickUp
//
//  Created by Krish Patel on 12/16/21.
//

import UIKit

class SecondViewController: UIViewController {
///code for entering a new child
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var grade: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.layer.cornerRadius = 22
        grade.layer.cornerRadius = 22
        submitButton.layer.cornerRadius = 22
        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        self.name.resignFirstResponder()
        self.grade.resignFirstResponder()
        return true
    }
    @IBAction func formButton(_ sender: Any) {
        let childName: String = name.text!
        let childGrade: String = grade.text!
        let instance:DATABASE = DATABASE()
        instance.AddInfo(childName, childGrade)
        name.text! = ""
        grade.text! = ""
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
