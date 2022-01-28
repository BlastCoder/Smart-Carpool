//
//  ViewController4.swift
//  PickUp
//
//  Created by Krish Mody on 1/27/22.
//

import UIKit

class ViewController4: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var tableViewData: [[String:String]] = [["Name" : "No one has arrived", "Grade" : "0"]]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewData.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell",
                                                     for: indexPath)
            cell.textLabel?.text = self.tableViewData[indexPath.row]["Name"]
            return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           print("section: \(indexPath.section)")
           print("row: \(indexPath.row)")
    }
    
    func getStudents() {
        let instance:DATABASE = DATABASE()
        tableViewData = instance.GetInfo("here")
    }
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "See Students"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
