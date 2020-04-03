//
//  Animal.swift
//  AnimalView
//
//  Created by Egor on 05/11/2019.
//  Copyright © 2019 EgorErmin. All rights reserved.
//

import Foundation

// Протокол для модели животного
protocol AnimalModel {
    var name: String { get }
    var kingdom: String { get }
    var family: String { get }
    var weight: Int { get }
    var date: Date? { get }
}

//class describing the animal model
class Animal {
    var name: String
    var kingdom: String
    var family: String
    var weight: Int
    var createdAt: TimeInterval?

    //class initializer
    init(snapshot: NSDictionary) {
        self.name = snapshot.value(forKey: "name") as! String
        self.kingdom = snapshot.value(forKey: "kingdom") as! String
        self.family = snapshot.value(forKey: "family") as! String
        self.weight = snapshot.value(forKey: "weight") as! Int
        self.createdAt = snapshot.value(forKey: "createdAt") as? TimeInterval
    }
}

// Данное расширение выполняет функцию фасада, подстраивая класс под протокол AnimalModel
// Конкретно адаптирует временной интервал с сервера в формат даты
extension Animal: AnimalModel {
    var date: Date? { return  Date(timeIntervalSince1970: createdAt ?? 0)}
}
