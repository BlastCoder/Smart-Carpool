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
    @IBOutlet weak var schoolName: UITextField!
    
    let signInConfig = GIDConfiguration.init(clientID: "715022030244-s446uchablfua5v8prif7c33ft2a18va.apps.googleusercontent.com")
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue", attributes: .concurrent)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
   
    @IBAction func SignIn(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            let user = GIDSignIn.sharedInstance.currentUser
            self.email = (user?.profile?.email)!
            // If sign in succeeded, display the app's main content View.
          }
    }
    
    @IBAction func submitButton(_ sender: Any) {
        guard var sName = schoolName.text
        else{return}
        sName = sName.uppercased()
        if email == "" {
            return
        }
        self.background.async {
            let instance = DATABASE()
            if !instance.checkAccount(sName, self.email) {
                return
            }
        }
        SCHOOLNAME = sName.uppercased()
        print(SCHOOLNAME)
        performSegue(withIdentifier: "MainPageSegue", sender: self)
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let vc = segue.destination as? MainPage
    }
    */
}
