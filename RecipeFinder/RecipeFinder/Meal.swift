//
//  Meal.swift
//  RecipeFinder
//
//  Created by Dillan Johnson on 11/13/19.
//  Copyright © 2019 Dillan Johnson. All rights reserved.
//

import Foundation

class Meal {
    
    let id: Int
    let name: String
    let photo: URL

    init( id: Int, name: String, photo: URL) {
        self.id = id
        self.name = name
        self.photo = photo
    }
}

extension Meal: Equatable {
    
    static func == (lhs: Meal, rhs: Meal) -> Bool {
        // two categories are the same if they have the same id
        return lhs.id == rhs.id
    }
}
