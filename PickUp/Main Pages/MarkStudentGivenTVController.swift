//
//  MarkStudentGivenTVController.swift
//  PickUp
//
//  Created by Krish Patel on 2/23/22.
//

import UIKit
import Firebase
import FirebaseDatabase

class MarkStudentGivenTVController: UITableViewController {

    var tableViewData = ["None"]
    var peopleArray: [Child] = []
    let ref = Database.database().reference(fromURL: "https://pickup-2568e-default-rtdb.firebaseio.com/")
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue", attributes: .concurrent)
    }()
    
    
    var edited: Bool = false {
        didSet {
            self.tableViewData = []
            print(self.peopleArray)
            for people in self.peopleArray {
                self.tableViewData.append("\(people.name) Grade: \(people.grade)")
            }   
            //print(self.tableViewData)
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    func updateData(){
        self.tableViewData = []
        self.background.async {
            let instance: DATABASE = DATABASE()
            //orders based on order
            self.peopleArray = instance.GetInfo("here", "All", "")
            self.peopleArray.sort{($0.order) < ($1.order)}
            self.edited = !self.edited
        }

    }
    
    @objc func reloadData() {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableviewCell",
                                                         for: indexPath)
            cell.textLabel?.text = self.tableViewData[indexPath.row]
            return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let instance: DATABASE = DATABASE()
        //edits the status to gone
        instance.EditInfo(self.peopleArray[indexPath.row].Id, "gone")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewData = ["None"]
        title = "Students to Send"
        self.updateData()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableviewCell")
        //observes the changes to the database
        ref.child(SCHOOLNAME).child("Children").observe(.childChanged, with: {(snapshot) -> Void in
            self.updateData()
          })
    }

}
