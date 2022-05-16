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
        
        Email.text = ""
        SchoolName.text = ""
        instance.addAccount(school, self.EmailList)
        self.EmailList = []
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
