//
//  NewMarkViewController.swift
//  PickUp
//
//  Created by Krish Patel on 2/27/23.
//

import UIKit
import Firebase
import FirebaseDatabase
import Foundation

class NewMarkViewController: UIViewController {
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue", attributes: .concurrent)
    }()
    let ref = Database.database().reference(fromURL: "https://pickup-2568e-default-rtdb.firebaseio.com/")

    var remaining: Int = 0
    {
        didSet {
            //for the count of students remaining at the top
            DispatchQueue.main.async {
                self.studentLabel.text = "Students Remaining: \(self.remaining)"
            }
            print(remaining)
        }
    }
    var peopleArray: [Child] = []
    {
        didSet {
            remaining = peopleArray.count

        }
    }
    
    @IBOutlet weak var studentLabel: UILabel!
    @IBOutlet weak var studentNumber: UITextField!
    
    var Number: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        title = "Parent Arrival"
        studentNumber.delegate = self
        studentNumber.text = ""
        ref.child(SCHOOLNAME).child("Children").observe(.childChanged, with: {(snapshot) -> Void in self.getData()
          })
        getData()
    }
    
    @IBAction func sumbitButton(_ sender: Any) {
        guard var number: String = studentNumber.text
        else {
            let alert = createFormAlert(about: "Number Required", withInfo: "Please include a valid Number for the student.")
            present(alert, animated: true)
            return
        }
        if number == "" {
            let alert = createFormAlert(about: "Number Required", withInfo: "Please include a valid Number for the student.")
            present(alert, animated: true)
            return
        }
        self.Number = number
        self.background.async {
            let instance: DATABASE = DATABASE()
            let idNum = instance.FindIDWithNumber(DATABASE.ApplyHash(self.Number))
            if idNum != "" {
                self.background.async {
                    let instance: DATABASE = DATABASE()
                    instance.EditInfo(idNum, "here")
                }
            }
        }
        studentNumber.text! = ""
        return
    }
    
    func createFormAlert(about title: String, withInfo message: String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        return alert
    }
    
    func getData(){
        self.background.async {
            let instance: DATABASE = DATABASE()
            self.peopleArray = instance.GetInfo("notHere", "All", "")
        }
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let vc = segue.destination as? EditPageController {
                vc.studentID = self.peopl
            }
    }
    */
    
   
    
}



extension NewMarkViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
}
