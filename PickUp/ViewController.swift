//
//  ViewController.swift
//  PickUp
//
//  Created by Krish Patel on 10/27/21.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue", attributes: .concurrent)
    }()
    override func viewDidLoad(){
        super.viewDidLoad()
        //view.backgroundColor = .blue
    }

    @IBAction func ButtonTest2(_ sender: Any) {
    
        self.background.async {
            var instance: DATABASE = DATABASE()
            print(instance.GetInfo("All"))
        }
        }
    @IBAction func AddPerson(_ sender: Any) {
        var instance: DATABASE = DATABASE()
       //instance.AddInfo("Yash", "5")
        instance.EditInfo("Child:268A99F8-ECCF-42E6-A579-75DF17895D64", "notHere")
    }
    /*
    @IBAction func NextPage(_ sender: Any) {
        self.performSegue(withIdentifier: "Child List", sender: self)
    }
    @IBAction func PageSegue(_ sender: Any) {
        self.performSegue(withIdentifier: "2nd", sender: self)
    }
    */
}
