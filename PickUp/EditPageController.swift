//
//  EditPageController.swift
//  PickUp
//
//  Created by Krish Patel on 3/8/22.
//

import UIKit

class EditPageController: UIViewController {

    var studentID: String = ""
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue", attributes: .concurrent)
    }()
    @IBOutlet weak var ChildName: UITextField!
    @IBOutlet weak var ChildGrade: UITextField!
    
    
    var studentValue: NSDictionary = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.background.async {
            let instance: DATABASE = DATABASE()
            self.studentValue = instance.GetInfoWithID(self.studentID)
            print(self.studentValue)
            self.addInfo()
        }
        
    }
    func addInfo() {
        DispatchQueue.main.async { [weak self] in
            self?.ChildName.text = self!.studentValue["Name"]! as? String
            self?.ChildGrade.text = self!.studentValue["Grade"]! as? String
        }
    }
   
    @IBOutlet weak var saveLabeled: UILabel!
    
    @IBAction func SaveButton(_ sender: Any) {
        let instance: DATABASE = DATABASE()
        instance.EditAllInfo(studentID, ChildName.text!, ChildGrade.text!)
        self.saveLabeled.text = "Saved Changes!"
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.saveLabeled.text = ""
        }
    }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
