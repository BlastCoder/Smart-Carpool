//
//  ViewController4.swift
//  PickUp
//
//  Created by Krish Mody on 1/27/22.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController4: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var tableViewData = ["Enter a grade..."]
    var peopleArray: [[String:String]] = [[:]]
    let ref = Database.database().reference(fromURL: "https://pickup-2568e-default-rtdb.firebaseio.com/")
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue", attributes: .concurrent)
    }()
    var queryGrade: String = "0"
    
    func updateData(_ queryGrade: String){
        self.background.async {
            let instance: DATABASE = DATABASE()
            self.peopleArray = instance.GetInfo("notHere")
            self.peopleArray.sort { ($0["Name"]!) < ($1["Name"]!) }
            self.tableViewData = []
            for people in self.peopleArray {
                if people["Grade"] == queryGrade{
                    self.tableViewData.append("\(people["Name"] ?? "Error")")
                }
            }
            //print(self.tableViewData)
        }
    }
    @objc func reloadData() {
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
        print(indexPath.row)
        //instance.EditInfo(self.peopleArray[indexPath.row]["Id"]!, "here")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "View Students"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        var timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: "reloadData", userInfo: nil, repeats: true)
        //not efficent but works I guess (maybe add observer on the self.peopleArray to detect change)
        ref.child("Children").observe(.childChanged, with: {(snapshot) -> Void in
            self.updateData(self.queryGrade)
          })
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
