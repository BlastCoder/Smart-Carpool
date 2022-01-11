//
//  ChildList.swift
//  PickUp
//
//  Created by Krish Patel on 12/21/21.
//

import UIKit

class ChildList: UIViewController {

    @IBOutlet weak var ChildListView: UILabel!
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue", attributes: .concurrent)
    }()
    var peopleArray: [[String: String]] = [[:]]
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HEHRHE")
        var timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: Selector("getInfo"), userInfo: nil, repeats: true)
            var infoTimer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: Selector("changeScreen"), userInfo: nil, repeats: true)
    }
    @objc func getInfo() {
        self.background.async {
            var instance: DATABASE = DATABASE()
            self.peopleArray = instance.GetInfo("All")
            print(self.peopleArray)
        }
    }
    @objc func changeScreen() {
        print(self.peopleArray)
        var childString: String = ""
        var length: Int = 0
        for people in peopleArray {
            childString += "\(people["Name"]!)\n"
            length += 1
        }
        ChildListView.numberOfLines = 0
        ChildListView.text = childString
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
