//
//  ViewController2.swift
//  PickUp
//
//  Created by Krish Mody on 11/4/21.
//

import UIKit
import FirebaseDatabase
import Firebase

class ViewController2: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableViewData = ["Loading..."]
    var peopleArray: [[String:String]] = [[:]]
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue", attributes: .concurrent)
    }()
        
    @objc func updateData(){
        self.background.async {
            let instance: DATABASE = DATABASE()
            self.peopleArray = instance.GetInfo("notHere")
            self.tableViewData = []
            for people in self.peopleArray {
                self.tableViewData.append("\(people["Name"] ?? "Error"):\(people["Grade"] ?? "Error")")
            }
            //print(self.tableViewData)
        }
        self.tableView.reloadData()

    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewData.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell",
                                                     for: indexPath)
            cell.textLabel?.text = self.tableViewData[indexPath.row]
            return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let instance: DATABASE = DATABASE()
        instance.EditInfo(self.peopleArray[indexPath.row]["Id"]!, "here")
        //instance.EditInfo(self.tableViewData[indexPath.row]["ID"], "here")
    }
   
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "View Students"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        var timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: "updateData", userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
