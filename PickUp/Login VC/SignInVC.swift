//
//  SignInVC.swift
//  PickUp
//
//  Created by Krish Patel on 4/13/22.
//

import UIKit
import GoogleSignIn

class SignInVC: UIViewController {
    var email = ""
    /*
    {
        didSet {
            self.doneButton.isEnabled = true
        }
    }
     */
    @IBOutlet weak var schoolName: UITextField!
    //google sign in stuff
    let signInConfig = GIDConfiguration.init(clientID: "715022030244-s446uchablfua5v8prif7c33ft2a18va.apps.googleusercontent.com")
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue", attributes: .concurrent)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        schoolName.delegate = self
        //self.doneButton.isEnabled = false
        // Do any additional setup after loading the view.
    }
   
    @IBOutlet weak var doneButton: UIButton!
    @IBAction func SignIn(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            let user = GIDSignIn.sharedInstance.currentUser
            self.email = (user?.profile?.email)!
            
            self.doneButton.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.doneButton.isEnabled = true
            }
          }
    }
    
    @IBAction func submitButton(_ sender: Any) {
        print("at top")
        //checks fields
        guard var sName = schoolName.text
        else{
            let alert = createFormAlert(about: "School Required", withInfo: "Please include a valid school for the account.")
            present(alert, animated: true)
            return
        }
        if sName == "" {
            let alert = createFormAlert(about: "School Required", withInfo: "Please include a valid school for the account.")
            present(alert, animated: true)
            return
        }
        sName = sName.uppercased()
        if email == "" {
            let alert = createFormAlert(about: "Sign in with Google", withInfo: "Please add a valid email.")
            present(alert, animated: true)
            return
        }
        //logins in if matches records, else gives alert
        var testBool: Bool = false {
            didSet {
                if !testBool{
                    return
                }
                SCHOOLNAME = sName.uppercased()
                print(SCHOOLNAME)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "MainPageSegue", sender: self)
                }
            }
        }
        self.background.async {
            let instance = DATABASE()
            testBool = instance.checkAccount(sName, self.email)
        }
}
    //create alerts
    func createFormAlert(about title: String, withInfo message: String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        return alert
    }
}
//for the return for text fields
extension SignInVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
}
