//
//  MarkStudentPresent.swift
//  PickUp
//
//  Created by Krish Patel on 2/21/22.
import UIKit
import Firebase
import FirebaseDatabase
import Foundation

class MarkStudentPresent: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var EditStatus: Bool = false
    
    var tableViewData = ["Loading..."]
    
    let searchController =  UISearchController()
    var peopleArray: [Child] = []
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
    
    func updateData(_ queryGrade: String, _ queryName: String){
        //change this if we refactor
        self.background.async {
            let instance: DATABASE = DATABASE()
            self.peopleArray = instance.GetInfo("notHere", queryGrade, queryName)
            self.peopleArray.sort { ($0.name) < ($1.name) }
            self.tableViewData = []
            for people in self.peopleArray {
                self.tableViewData.append("\(people.name )")
            }
            self.testVar = !self.testVar
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
            //we have to change this code if we refactor
            instance.EditInfo(self.peopleArray[indexPath.row].Id, "here")
        }
        else if EditStatus {
            EditPersonID = (self.peopleArray[indexPath.row].Id)
            performSegue(withIdentifier: "EditPage", sender: self)
        }
    }
    override func viewDidLoad() {
        let ref = Database.database().reference(fromURL: "https://pickup-2568e-default-rtdb.firebaseio.com/")
        super.viewDidLoad()
        title = "Parent Arrival"
        initSearchController()
        ref.child(SCHOOLNAME).child("Children").observe(.childChanged, with: {(snapshot) -> Void in
            self.updateData(self.queryGrade, self.queryName)
          })
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
    @IBOutlet weak var EditButton: UIButton!
    
    @IBAction func EditStudent(_ sender: Any) {
        EditStatus = !EditStatus
        if EditStatus {
            EditButton.tintColor = .red
        }
        else {
            EditButton.tintColor = .link
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let vc = segue.destination as? EditPageController {
                vc.studentID = self.EditPersonID
                }
    }
    override func viewWillAppear(_ animated: Bool) {

        var possibleTitle = ["All", "1", "2", "3", "4", "5"]
        updateData(possibleTitle[searchController.searchBar.selectedScopeButtonIndex], "")
    }
}

