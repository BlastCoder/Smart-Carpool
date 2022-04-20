//
//  MarkStudentPresent.swift
//  PickUp
//
//  Created by Krish Patel on 2/21/22.
//

import UIKit
import Firebase
import FirebaseDatabase
import Foundation

class MarkStudentPresent: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var EditStatus: Bool = false
    
    var tableViewData = ["Loading..."]
    
    let searchController =  UISearchController()
    var peopleArray: [[String:String]] = [[:]]
    let ref = Database.database().reference(fromURL: "https://pickup-2568e-default-rtdb.firebaseio.com/")
    var queryGrade: String = "All"
    var queryName: String = ""
    var EditPersonID: String = ""

    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue", attributes: .concurrent)
    }()
    
    func updateData(_ queryGrade: String, _ queryName: String){
        self.background.async {
            let instance: DATABASE = DATABASE()
            self.peopleArray = instance.GetInfo("notHere", queryGrade, queryName)
            self.peopleArray.sort { ($0["Name"]!) < ($1["Name"]!) }
            self.tableViewData = []
            for people in self.peopleArray {
                self.tableViewData.append("\(people["Name"] ?? "Error")")
            }
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
        if !EditStatus {
            instance.EditInfo(self.peopleArray[indexPath.row]["Id"]!, "here")
        }
        else if EditStatus {
            EditPersonID = (self.peopleArray[indexPath.row]["Id"]!)
            performSegue(withIdentifier: "EditPage", sender: self)
        }
        //print(indexPath.row)
        //have to fix this, becuase of filter, the index does matter anymore!
        //instance.EditInfo(self.tableViewData[indexPath.row]["ID"], "here")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "View Students"
        //updateData("All", "")
        var timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: "reloadData", userInfo: nil, repeats: true)
        initSearchController()
        //not efficent but works I guess (maybe add observer on the self.peopleArray to detect change)
        ref.child(SCHOOLNAME).child("Children").observe(.childChanged, with: {(snapshot) -> Void in
            self.updateData(self.queryGrade, self.queryName)
          })
        // Do any additional setup after loading the view.
    }
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scopeButton = searchController.searchBar.scopeButtonTitles![searchController.searchBar.selectedScopeButtonIndex]
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        queryName = searchController.searchBar.text!
        updateData(queryGrade, queryName)
        
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        queryGrade = searchController.searchBar.scopeButtonTitles![selectedScope]
        updateData(queryGrade, queryName)
    }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    
    func initSearchController()
    {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.scopeButtonTitles = ["All", "1", "2", "3", "4", "5"]
        searchController.searchBar.delegate = self
    }
    @IBOutlet weak var EditButton: UIButton!
    
    @IBAction func EditStudent(_ sender: Any) {
        EditStatus = !EditStatus
        if EditStatus {
            EditButton.tintColor = .red
        }
        else {
            EditButton.tintColor = .link
        }
        //performSegue(withIdentifier: "EditPage", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let vc = segue.destination as? EditPageController {
                vc.studentID = self.EditPersonID
                }
    }
    override func viewWillAppear(_ animated: Bool) {
        updateData("All", "")
    }
}

    // MARK: - Table view data source
    

        // Pass the selected object to the new view controller.



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
            // Create a new instance of the appropriate class, insert it into the array, a a new row to the table view
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

