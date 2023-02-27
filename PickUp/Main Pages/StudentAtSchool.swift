//
//  StudentAtSchool.swift
//  PickUp
//
//  Created by Krish Patel on 5/12/22.
//

import UIKit
import Firebase

class StudentAtSchool: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    
    var EditStatus: Bool = false
    var tableViewData = ["Loading..."]
    var placeholder: [String] = []
    let searchController =  UISearchController()
    var peopleArray: [Child] = [] {
        didSet {
            if peopleArray.count > 1 {
                self.peopleArray.sort {($0.name) < ($1.name)}
            }
            self.placeholder = []
            for people in self.peopleArray {
                self.placeholder.append("\(people.name )")
            }
            self.tableViewData = self.placeholder
            self.testVar = !self.testVar
            }
    }
    var queryGrade: String = "All"
    var queryName: String = ""
    var EditPersonID: String = ""
    
    var testVar: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue", attributes: .concurrent)
    }()
    //updates the data
    func updateData(_ queryGrade: String, _ queryName: String){
        self.background.async {
            let instance: DATABASE = DATABASE()
            //order them based on name, alaphbetical, queries with query fields
            self.peopleArray = instance.GetInfo("notSchool", queryGrade, queryName)
            //print(self.peopleArray)
        }
    }
    //boilder plate stuff
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
        else {
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let instance: DATABASE = DATABASE()
        instance.EditInfo(self.peopleArray[indexPath.row].Id, "notHere")
    }
    override func viewDidLoad() {
        let ref = Database.database().reference(fromURL: "https://pickup-2568e-default-rtdb.firebaseio.com/")
        super.viewDidLoad()
        title = "Attendence"
        initSearchController()
        //observer, observes changes
        ref.child(SCHOOLNAME).child("Children").observe(.childChanged, with: {(snapshot) -> Void in
            self.updateData(self.queryGrade, self.queryName)
          })
        /*
        ref.child(SCHOOLNAME).child("Children").observe(.childAdded, with: {(snapshot) -> Void in
            self.updateData(self.queryGrade, self.queryName)
          })
         */
        
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let vc = segue.destination as? EditPageController {
                vc.studentID = self.EditPersonID
            }
    }
    override func viewWillAppear(_ animated: Bool) {
        var possibleTitle = ["All", "1", "2", "3", "4", "5"]
        //if the scope buttons changes, filter
        updateData(possibleTitle[searchController.searchBar.selectedScopeButtonIndex], "")
    }
    
    @IBAction func newDay(_ sender: Any) {
        //new day reset
        let instance: DATABASE = DATABASE()
        instance.ResetValues()
    }
}

