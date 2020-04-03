//
//  AddNewItemViewController.swift
//  AnimalView
//
//  Created by Egor on 17/11/2019.
//  Copyright © 2019 EgorErmin. All rights reserved.
//

import UIKit
import Firebase

class AddNewItemViewController: UIViewController {

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
    
    var animal: Animal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.black
        guard let animal = animal else { return }
        nameTextField.text = animal.name
        kingdomTextField.text = animal.kingdom
        familyTextField.text = animal.family
        weightTextField.text = String(animal.weight)
        
        let date = DateFormatter()
        date.dateFormat = "MM-dd-yyyy HH:mm"
        status.text = "Was create \(date.string(from: animal.date!))"
        
        if flag {
            navigationItem.title = "Update Animal"
            rightBarButtonItem.title = "Update"
        }
    }
    
    //function for processing saving and updates item (with validaton)
    @IBAction func saveAnimal(sender: AnyObject) {
        guard let animal = animal else { return }
        animal.name = (nameTextField.text ?? "")
        animal.kingdom = (kingdomTextField.text ?? "")
        animal.family = (familyTextField.text ?? "")
        //check for empty fields
        if animal.name.isEmpty || animal.kingdom.isEmpty || animal.family.isEmpty {
            status.text = "You havn`t input some information!"
            status.textColor = UIColor.red
            return
        }
        //check for coorectness input weight
        if weightTextField.text!.count <= 6, let intWeight = Int(weightTextField.text!){
            if flag{
                updateItem(weight: intWeight)
            } else {
                createNewItem(weight: intWeight)
                status.text = "Your animal add!"
                status.textColor = UIColor.green
            }
        } else {
            status.text = "Weight input incorrect"
            status.textColor = UIColor.red
        }
    }
    
    //function to update selection item
    private func updateItem(weight: Int) {
        guard let animal = animal else { return }
        Database.database().reference().child(animal.name).observe(.value , with: { (snapshot) in
            guard snapshot.childrenCount >= 1 else {
                self.status.text = "The animal not found!"
                self.status.textColor = UIColor.red
                return
            }
            let information = ["name": animal.name, "kingdom": animal.kingdom, "family": animal.family, "weight": weight, "createdAt": Date().timeIntervalSince1970] as [String : Any]
            let updates = ["\(animal.name)": information]
            Database.database().reference().updateChildValues(updates)
            self.status.text = "Information about animal update!"
            self.status.textColor = UIColor.green
            return
        })
    }
    
    //function to create a new item
    private func createNewItem(weight: Int) {
        guard let animal = animal else { return }
        let newAnimal: NSDictionary = ["kingdom": animal.kingdom, "family": animal.family, "name": animal.name, "weight": weight, "createdAt": Date().timeIntervalSince1970]
        Database.database().reference().child(animal.name).setValue(newAnimal)
    }
}
