//
//  AddAnimalTableViewController.swift
//  AnimalView
//
//  Created by Egor on 05/11/2019.
//  Copyright © 2019 EgorErmin. All rights reserved.
//

import UIKit
import Firebase

class AddAnimalTableViewController: UITableViewController {
    
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    
    //fields for entering information about the animal
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var kingdomTextField: UITextField!
    @IBOutlet weak var familyTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    //field for output of response and validation errors
    @IBOutlet weak var status: UILabel!
    
    //if flag values false, the scene will load in new animal creation mode
    var flag = false
    
    var name = ""
    var kingdom = ""
    var family = ""
    var weight = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.black
        nameTextField.text = name
        kingdomTextField.text = kingdom
        familyTextField.text = family
        weightTextField.text = weight
        
        if flag {
            rightBarButtonItem.title = "Update"
        }
    }
    
    //function for processing saving and updates item
    @IBAction func saveAnimal(sender: AnyObject){
        name = nameTextField.text!
        kingdom = kingdomTextField.text!
        family = familyTextField.text!
        //check for empty fields
        if family == "" || kingdom == "" || family == "" {
            status.text = "You havn`t input some information!"
            status.textColor = UIColor.red
            return
        }
        //check for coorectness input weight
        if weightTextField.text!.count <= 6, let intWeight = Int(weightTextField.text!){
            if flag{
                //update item
                Database.database().reference().child(name).observe(.value , with: { (snapshot) in
                    guard snapshot.childrenCount >= 1 else {
                        self.status.text = "The animal not found!"
                        self.status.textColor = UIColor.red
                        return
                    }
                    let information = ["name": self.name, "kingdom": self.kingdom, "family": self.family, "weight": intWeight] as [String : Any]
                    let updates = ["\(self.name)": information]
                    Database.database().reference().updateChildValues(updates)
                    self.status.text = "Information about animal update!"
                    self.status.textColor = UIColor.green
                    return
                })
            } else {
                //create new item
                let newAnimal: NSDictionary = ["kingdom": kingdom, "family": family, "name": name, "weight": intWeight]
                Database.database().reference().child(name).setValue(newAnimal)
                status.text = "Your animal add!"
                status.textColor = UIColor.green
            }
        } else {
            status.text = "Weight input incorrect"
            status.textColor = UIColor.red
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    //limit excessive character input
    /*
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let combinedString = nameTextField.attributedText!.mutableCopy() as! NSMutableAttributedString
        combinedString.replaceCharacters(in: range, with: string)
        return combinedString.size().width > nameTextField.bounds.size.width
    }*/
}
