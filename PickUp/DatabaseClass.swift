//
//  DatabaseTest.swift
//  PickUp
//
//  Created by Krish Patel on 11/4/21.
import UIKit
import Firebase
import FirebaseDatabase
import CryptoKit

///This has all the components of the database, can  read, write, edit order and status, and edit name + grade
class DATABASE {
    var ref: DatabaseReference!
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue", attributes: .concurrent)
    }()
    var Children: [Child]
    var Order: Int
    var StudentIDInfo: NSDictionary = [:]
    var status: Bool = false
    var emails: [String] = []
    init(){
        self.Children = []
        self.ref = Database.database().reference(fromURL: "https://pickup-2568e-default-rtdb.firebaseio.com/")
        self.Order = -1
    }
    // Add a school account
    func addAccount(_ school: String, _ emails: [String]){
        /*
        let schoolName = school.uppercased()
        var success: Bool = false
        let group = DispatchGroup.init()
        group.enter()
        
        self.ref.child(schoolName).child("Teachers").getData(completion:  { error, snapshot in
            // confirms that the school name is not already in use
            guard error == nil else {
              return
            }
            guard let OrderDict = snapshot.value as? [String: [String]]
            else {
                let object: [String: [String]] = ["Emails": emails]
                self.ref.child(schoolName).child("Teachers").setValue(object)
                success = true
                return
            }
          })
        return
         */
        //adds the school account, used after checkSchoolName
        let schoolName = school.uppercased()
        let object: [String: [String]] = ["Emails": emails]
        self.ref.child(schoolName).child("Teachers").setValue(object)
        return
    }
    func checkSchoolName(_ school: String) -> Bool {
        //confirms that the school name is not already in use
        var arrayKeys: [String] = []
        let group = DispatchGroup.init()
        group.enter()
        self.ref.getData(completion:  { error, snapshot in
            guard error == nil else {
              return
            }
            guard let OrderDict = snapshot.value as? [String: Any]
            else {
                return
            }
            arrayKeys = Array(OrderDict.keys)
            group.leave()
          })
        group.wait()
        for key in arrayKeys {
            //grabs the values (keys) and then iterates through, if it finds name match then return true, else false
            if key == school.uppercased() {
                return true
            }
        }
        return false
        // Check if email is in an account
    }
    // Check if email is in an account
    func checkAccount(_ school: String, _ enterEmail: String) -> Bool {
        let group = DispatchGroup.init()
        group.enter()
        //similar code and purpose as above, checks if account in list of emails, given a school name
        self.ref.child(school.uppercased()).child("Teachers").getData(completion:  { error, snapshot in
            guard error == nil else {
                  return
                }
            guard let OrderDict = snapshot.value as? [String: [String]]
            else {
                return
            }
            self.emails = OrderDict["Emails"]!
            group.leave()
          })
        group.wait()
        for email in self.emails {
            if email == enterEmail.uppercased() {
                return true
            }
            //checks if entered email is in use
        }
        //print("HERE")
        return false
    }
    // Get information of a student
    func GetInfo(_ queryWord: String, _ queryGrade: String, _ queryName: String) ->  [Child] {
        //just for concurrency stuff
        self.Children = []
        let group = DispatchGroup.init()
        group.enter()
        //Get info, with given query info
        self.ref.child(SCHOOLNAME).child("Children").observeSingleEvent(of: .value) { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    return
                }
                var name = dict["Name"]! as! String
                var nameMatch: Bool = false
                if queryName == "" {
                        nameMatch = true
                    // if search bar is empty
                }
                else if name.lowercased().contains(queryName.lowercased()) {
                    nameMatch = true
                    //for the search bar
                }
                else {
                    nameMatch = false
                }
                
                if dict["Grade"]! as! String == queryGrade && nameMatch {
                    //checking parameters inputed, name, grade, etc.
                    let ID = child.key
                    let Name = dict["Name"]! as! String
                    let Grade = dict["Grade"]! as! String
                    let Status = dict["Status"] as! String
                    let Order = dict["Order"] as! String
                    if Status == queryWord{
                        let child = Child(Id: ID, name: Name, grade: Grade, status: Status, order: Order)
                        self.Children.append(child)
                    }
                    else if queryWord == "All" && nameMatch {
                        let child = Child(Id: ID, name: Name, grade: Grade, status: Status, order: Order)
                        self.Children.append(child)
                    }
                }
                //if grade is all, then its not filter
                else if queryGrade == "All" && nameMatch {
                    //if grade is all, then continues
                    let ID = child.key
                    let Name = dict["Name"]! as! String
                    let Grade = dict["Grade"]! as! String
                    let Status = dict["Status"] as! String
                    let Order = dict["Order"] as! String
                    if Status == queryWord {
                        let child = Child(Id: ID, name: Name, grade: Grade, status: Status, order: Order)
                        self.Children.append(child)
                    }
                    else if queryWord == "All" {
                        let child = Child(Id: ID, name: Name, grade: Grade, status: Status, order: Order)
                        self.Children.append(child)
                    }
                }
            }
            group.leave()
        }
        //wait for competion
        group.wait()
        //Returns array of children
        return(self.Children)
    }
    // Add student information with given input
    func AddInfo(_ name: String, _ grade: String, _ plates: [String]) -> String{
        let uuid = "Child:\(UUID().uuidString)"
        let object: [String: Any] = ["Name": name, "Grade": grade, "Status": "notSchool", "Order": "0", "CarPlates": plates]
        self.ref.child(SCHOOLNAME).child("Children").child(uuid).setValue(object)
        return uuid
    }
    // Edit student information, given id etc.
    func EditInfo(_ id: String, _ Status: String){
        
        ref.child(SCHOOLNAME).child("Children").child(id).updateChildValues(["Status": Status])
        //don't change check order, if the status is gone or notHere, becuase there is no need
        if Status == "gone" || Status == "notHere"
        {return}

        self.background.async{
            let order = self.StudentOrder()
            self.ref.child(SCHOOLNAME).child("Children").child(id).updateChildValues(["Order": order])
        }
    }
    // Order the students depending on arrival, looks at student order in database, and then  continues
    func StudentOrder() -> String{
        let group = DispatchGroup.init()
        group.enter()
        self.ref.child(SCHOOLNAME).child("Order").child("recentOrder").getData(completion:  { error, snapshot in
            guard error == nil else {
              return
            }
            guard let OrderDict = snapshot.value as? [String: String]
            else {return}
            self.Order = Int(OrderDict["Order"] ?? ("0")) ?? (1)
            group.leave()
          })
        group.wait()
        // Reset the value of if students have arrived, for new days
        self.ref.child(SCHOOLNAME).child("Order").child("recentOrder").updateChildValues(["Order": String(self.Order + 1)])
        return String(self.Order)
    }
    // Reset the value of if students have arrived, new day
    func ResetValues() {
        self.ref.child(SCHOOLNAME).child("Children").observeSingleEvent(of: .value) { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                self.ref.child(SCHOOLNAME).child("Children").child(child.key).updateChildValues(["Order": "0", "Status": "notSchool"])
            }
        }
        self.ref.child(SCHOOLNAME).child("Order").child("recentOrder").updateChildValues(["Order": "1"])
    }
    func FindIDWithPlate(_ plate: String) -> [String] {
        //works finds student or students with matching plate
        var StudentId: [String] = []
        let group = DispatchGroup.init()
        group.enter()
        //iterates through to find
        self.ref.child(SCHOOLNAME).child("Children").observeSingleEvent(of: .value) { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    return
                }
                let ID = child.key
                let carPlates = dict["CarPlates"] as! [String]
                for plates in carPlates {
                    if plates == plate {
                        StudentId.append(ID)
                        break
                    }
                }
            }
            group.leave()
        }
        group.wait()
        return StudentId
    }
    //gets the student's information given their id
    func GetInfoWithID(_ Id: String) -> NSDictionary {
        let group = DispatchGroup.init()
        StudentIDInfo = [:]
        group.enter()
        self.ref.child(SCHOOLNAME).child("Children").child(Id).observeSingleEvent(of: .value, with: { snapshot in
            self.StudentIDInfo = (snapshot.value as? NSDictionary)!
            group.leave()
            }) { error in
              print(error.localizedDescription)
            }
        group.wait()
    return StudentIDInfo
    }
    //edits the child's info
    func EditAllInfo(_ id: String, _ name: String, _ grade: String){
        ref.child(SCHOOLNAME).child("Children").child(id).updateChildValues(["Name": name, "Grade": grade])
    }
    func RemoveStudent(_ id: String) {
        self.ref.child(SCHOOLNAME).child("Children").child(id).removeValue()
    }
    //applies hash for liscense plate
    static func ApplyHash(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        let string = hashed.compactMap {String(format: "%02x", $0)}.joined()
        return string
    }
    //check if id exists in the database
    func checkID(_ uuid: String) -> Bool {
        var arrayKeys: [String] = []
        let group = DispatchGroup.init()
        group.enter()
        self.ref.child(SCHOOLNAME).child("Children").getData(completion:  { error, snapshot in
            guard error == nil else {
              return
            }
            guard let OrderDict = snapshot.value as? [String: Any]
            else {
                return
            }
            arrayKeys = Array(OrderDict.keys)
            group.leave()
          })
        group.wait()
        // finds the keys in the arrays
        for key in arrayKeys {
            if key == uuid {
                return true
            }
        }
        return false
    }
}
