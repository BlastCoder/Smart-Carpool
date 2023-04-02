//
//  RemainingStudents.swift
//  PickUp
//
//  Created by Krish Patel on 2/28/23.
//

import UIKit
import Firebase


class RemainingStudents: UITableViewController {
    

    var tableViewData = ["None"]
    var peopleArray: [Child] = []
    {
        didSet {
            if peopleArray.count > 1 {
                    self.peopleArray.sort { ($0.name) < ($1.name) }
            }
            self.placeholder = []
            for people in self.peopleArray {
                self.placeholder.append("\(people.name )")
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
            self.peopleArray = instance.GetInfo("notHere", "All", "")

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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewData = ["None"]
        title = "Students Remaining"
        self.updateData()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableviewCell")
        //observes the changes to the database
        ref.child(SCHOOLNAME).child("Children").observe(.childChanged, with: {(snapshot) -> Void in
            self.updateData()
          })
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
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
