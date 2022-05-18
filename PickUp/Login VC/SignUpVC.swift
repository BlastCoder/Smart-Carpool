//
//  SignUpVC.swift
//  PickUp
//
//  Created by Krish Patel on 4/11/22.
//

import UIKit

class SignUpVC: UIViewController {
    var EmailList: [String] = []
    
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var SchoolName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Email.delegate = self
        SchoolName.delegate = self

        // Do any additional setup after loading the view.
    }
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue", attributes: .concurrent)
    }()
    
    // Allow the user to input more emails to add to a given school by clicking the More button. If the email is not valid, create an alert to ask for a valid email
    @IBAction func MoreEmail(_ sender: Any) {
        guard let email = Email.text
        else{
            let alert = createFormAlert(about: "Email Required", withInfo: "Please include a valid email for the account.")
            present(alert, animated: true)
            return
        }
        if email == "" {
            let alert = createFormAlert(about: "Email Required", withInfo: "Please include a valid email for the account.")
            present(alert, animated: true)
            return
        }
        EmailList.append(email.uppercased())
        Email.text = ""
    }
    
    // Create a new school with the given emails. If the school or email is not valid, create an alert to ask for a valid school/email
    @IBAction func Submit(_ sender: Any) {
        guard let school = SchoolName.text
        else{
            let alert = createFormAlert(about: "School Required", withInfo: "Please include a school name for the account.")
            present(alert, animated: true)
            return
        }
        if school == "" {
            let alert = createFormAlert(about: "School Required", withInfo: "Please include a school name for the account.")
            present(alert, animated: true)
            return
        }
        let instance: DATABASE = DATABASE()
        guard let email = Email.text
        else{
            let alert = createFormAlert(about: "Email Required", withInfo: "Please include a valid email for the account.")
            present(alert, animated: true)
            return
        }
        if email == "" {
            let alert = createFormAlert(about: "Email Required", withInfo: "Please include a valid email for the account.")
            present(alert, animated: true)
            return
        }
        self.EmailList.append(email.uppercased())
        
        
        self.background.async {
            if !instance.checkSchoolName(school) {
                instance.addAccount(school, self.EmailList)
                self.EmailList = []
                DispatchQueue.main.async {
                    self.Email.text = ""
                    self.SchoolName.text = ""
                }
            }
            else {
                DispatchQueue.main.async {
                    let alert = self.createFormAlert(about: "School Name in Use", withInfo: "Please make up a unique school for the account.")
                    self.present(alert, animated: true)
                    self.EmailList.remove(at: (self.EmailList.count - 1))
                }
            }
        }
    }
    
    func createFormAlert(about title: String, withInfo message: String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        return alert
    }
}
extension SignUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
}
