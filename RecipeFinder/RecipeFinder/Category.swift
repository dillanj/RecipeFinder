//
//  Category.swift
//  RecipeFinder
//
//  Created by Dillan Johnson on 11/12/19.
//  Copyright © 2019 Dillan Johnson. All rights reserved.
//

import Foundation

class Category {
    
    let id: Int
    let photo: URL
    let name: String
    let description: String
    
    init( id: Int, photo: URL, name: String, description: String){
        self.id = id
        self.photo = photo
        self.name = name
        self.description = description
    }
    
}

extension Category: Equatable {
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        // two categories are the same if they have the same id
        return lhs.id == rhs.id
    }
}
