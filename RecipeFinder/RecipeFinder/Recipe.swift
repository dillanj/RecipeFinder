//
//  Recipe.swift
//  RecipeFinder
//
//  Created by Dillan Johnson on 11/12/19.
//  Copyright © 2019 Dillan Johnson. All rights reserved.
//

import Foundation

class Recipe {
    
    let id: Int
    let name: String
    let instructions: String
    let photo: URL
    let ingredients: [String]
    
    init( id: Int, name: String,  instructions: String, photo: URL, ingredients: [String]) {
        self.id = id
        self.name = name
        self.instructions = instructions
        self.photo = photo
        self.ingredients = ingredients
    }
}
