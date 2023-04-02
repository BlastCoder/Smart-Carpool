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
    {
        didSet {
            //orders based on order
            if peopleArray.count > 1 {
                self.peopleArray.sort{(Int($0.order) ?? 100 < Int($1.order) ?? 100)}
            }
            self.placeholder = []
            var occured: [String] = []
            var number: String = ""
            for people in self.peopleArray {
                //self.placeholder.append("\(people.name) Grade: \(people.grade)")
                if occured.contains(people.grade) && (people.number != number) {
                    self.placeholder.append("(IN QUEUE) \(people.name) Position: \(people.grade)")
                }
                else {
                    self.placeholder.append("\(people.name) Position: \(people.grade)")
                    occured.append(people.grade)
                    number = people.number
                }
            }
            self.tableViewData = self.placeholder
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    var placeholder: [String] = []
    let ref = Database.database().reference(fromURL: "https://pickup-2568e-default-rtdb.firebaseio.com/")
    
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue", attributes: .concurrent)
    }()
    
    var edited: Bool = false
    
    func updateData(){
        self.tableViewData = []
        self.background.async {
            let instance: DATABASE = DATABASE()
            self.peopleArray = instance.GetInfo("here", "All", "")
            //make int and then compare
            //self.edited = !self.edited
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
            if tableViewData != [] {
                cell.textLabel?.text = self.tableViewData[indexPath.row]
                return cell
            }
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
