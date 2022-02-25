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
    }
    @IBAction func submitButton(_ sender: Any) {
        //self.background.async {
        let childName: String = name.text!
        let childGrade: String = grade.text!
        plateNums.append(plateText.text!)
        plateText.text = ""
        print(self.plateNums)
        let instance:DATABASE = DATABASE()
        //print(instance.StudentOrder())
        instance.AddInfo(childName, childGrade)
        name.text! = ""
        grade.text! = ""
        //}
    }
    @IBAction func resetTest(_ sender: Any) {
        let instance: DATABASE = DATABASE()
        instance.ResetValues()
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
