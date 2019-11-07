//
//  ViewController.swift
//  AnimalView
//
//  Created by Egor on 05/11/2019.
//  Copyright © 2019 EgorErmin. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    Database.database().reference().child("Lion").child("Kingdom")
    Database.database().reference().child("Lion").child("Type")
    Database.database().reference().child("Lion").child("Squad")
        
    Database.database().reference().child("Lion").child("Family")
        
        Database.database().reference().child("Lion").child("View").setValue("Lion")
    }
}
