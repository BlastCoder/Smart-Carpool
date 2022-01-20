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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "___"
    }
    @IBAction func submitButton(_ sender: Any) {
        //self.background.async {
        let childName: String = name.text!
        let childGrade: String = grade.text!
        let instance:DATABASE = DATABASE()
        //print(instance.StudentOrder())
        instance.AddInfo(childName, childGrade)
        name.text! = ""
        grade.text! = ""
        //}
    }
    
    
    
    
    
    
    
    /*
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.textLabel?.text = "test"
        return cell
    }
    
        // Do any additional setup after loading the view.
        
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
