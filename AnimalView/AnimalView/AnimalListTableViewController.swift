//
//  AnimalListTableViewController.swift
//  AnimalView
//
//  Created by Egor on 05/11/2019.
//  Copyright © 2019 EgorErmin. All rights reserved.
//

import UIKit
import Firebase

class AnimalListTableViewController: UITableViewController {
    
    @IBOutlet var indicator: UIActivityIndicatorView?

    var animals = [Animal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loading data from database
        loadDataFromFirebase()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animals.count
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //transition to an editing scene with the setting in the values of the chosen item
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showWindow"){
            if let indexPath = tableView.indexPathForSelectedRow{
                let destinationController = segue.destination as! AddAnimalTableViewController
                destinationController.animal = animals[indexPath.row]
                destinationController.flag = true
            }
        }
    }
    
    //deleting a list item
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let animalList = animals[indexPath.row]
            Database.database().reference().child(animalList.name).removeValue()
            animals.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    //setting the received values
    private func configureCell(cell: UITableViewCell, indexPath: IndexPath){
        let animalList = animals[indexPath.row]
        cell.textLabel?.text = animalList.name
        cell.detailTextLabel?.text = animalList.family
    }
    
    //getting data
    private func loadDataFromFirebase(){
        //start of the indicator
        indicator?.startAnimating()
        indicator?.hidesWhenStopped = true
        
        //loading data in list
        Database.database().reference().observe(.value, with: { (snapshot) in
            guard let value = snapshot.value, snapshot.exists() else{
                self.indicator?.stopAnimating()
                return
            }
            var listAnimal = [Animal]()
            var list: NSDictionary = value as! NSDictionary
            for child in list{
                let animal = Animal(snapshot: child.value as! NSDictionary)
                listAnimal.append(animal)
            }
            self.animals = listAnimal
            self.indicator?.stopAnimating()
            self.tableView.reloadData()
        })
    }
    
    //transition to the scene of creating a new item
    @IBAction func openCreatNewAnimal(){
        performSegue(withIdentifier: "showWindow", sender: nil)
    }
}
