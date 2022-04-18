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
        // Do any additional setup after loading the view.
    }
    
    @IBAction func MoreEmail(_ sender: Any) {
        guard let email = Email.text
        else{return}
        EmailList.append(email.uppercased())
        Email.text = ""
    }
    
    @IBAction func Submit(_ sender: Any) {
        guard let school = SchoolName.text else{return}
        let instance: DATABASE = DATABASE()
        guard let email = Email.text
        else{return}
        self.EmailList.append(email.uppercased())
        
        Email.text = ""
        SchoolName.text = ""
        instance.addAccount(school, self.EmailList)
        self.EmailList = []
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
