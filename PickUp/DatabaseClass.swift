//
//  DatabaseTest.swift
//  PickUp
//
//  Created by Krish Patel on 11/4/21.
import UIKit
import Firebase
import FirebaseDatabase
///This has all the components of the database, can currently read and write
class DATABASE{
    var ref: DatabaseReference!
    var Children: [[String : String]]
    init(){
        self.Children = []
        self.ref = Database.database().reference(fromURL: "https://pickup-2568e-default-rtdb.firebaseio.com/")
    }
    func GetInfo(_ queryWord: String) ->  [[String: String]] {
        //enter the group for async I guess
        self.Children = []
        let group = DispatchGroup.init()
        group.enter()
        //Get info, with given query info
        self.ref.child("Children").observeSingleEvent(of: .value) { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    return
                }
                let ID = child.key
                let Name = dict["Name"]! as! String
                let Grade = dict["Grade"]! as! String
                let Status = dict["Status"] as! String
                if Status == queryWord{
                    var childInfo: [String: String] = ["Id": ID, "Name": Name, "Grade": Grade, "Status": Status]
                    self.Children.append(childInfo)
                }
                else if queryWord == "All" {
                    var childInfo: [String: String] = ["Id": ID, "Name": Name, "Grade": Grade, "Status": Status]
                    self.Children.append(childInfo)
                } 
            }
            group.leave()
        }
        //wait for competion
        group.wait()
        //Returns array of dictionaries
        return(self.Children)
    }
    func AddInfo(_ name: String, _ grade: String){
        let uuid = "Child:\(UUID().uuidString)"
        var object: [String: String] = ["Name": name, "Grade": grade, "Status": "notHere"]
        self.ref.child("Children").child(uuid).setValue(object)
    }
    func EditInfo(_ id: String, _ Status: String){
        ref.child("Children").child(id).updateChildValues(["Status": Status])
    }
}
