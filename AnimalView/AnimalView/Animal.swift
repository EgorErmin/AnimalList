//
//  Animal.swift
//  AnimalView
//
//  Created by Egor on 05/11/2019.
//  Copyright © 2019 EgorErmin. All rights reserved.
//

import Foundation

//class describing the animal model
class Animal{
    var name: String
    var kingdom: String
    var family: String
    var weight: Int

    //class initializer
    init(snapshot: NSDictionary){
        self.name = snapshot.value(forKey: "name") as! String
        self.kingdom = snapshot.value(forKey: "kingdom") as! String
        self.family = snapshot.value(forKey: "family") as! String
        self.weight = snapshot.value(forKey: "weight") as! Int
    }
    
    init(){
        self.name = ""
        self.kingdom = ""
        self.family = ""
        self.weight = 0
    }
}
