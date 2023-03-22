//
//  GoogleSignIn.swift
//  PickUp
//
//  Created by Krish Patel on 3/22/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn


class GoogleSignIn: UIViewController {
    let signInConfig = GIDConfiguration.init(clientID: "715022030244-s446uchablfua5v8prif7c33ft2a18va.apps.googleusercontent.com")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func GoogleSignIn(_ sender: Any) {
        print("here")
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) {result, error in guard error == nil else { return }
            
            guard let auth = result?.authentication else { return }
            
            let currentUser = GIDSignIn.sharedInstance.currentUser
            
            let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken!, accessToken: auth.accessToken)

            Auth.auth().signIn(with: credentials) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    print("Login Successful.")
                    EMAIL = (currentUser?.profile!.email)!
                    self.performSegue(withIdentifier: "SignInSegue", sender: self)
                }
            }
        }
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
