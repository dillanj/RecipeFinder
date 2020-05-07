//
//  RecipesDataSource.swift
//  RecipeFinder
//
//  Created by Dillan Johnson on 11/13/19.
//  Copyright © 2019 Dillan Johnson. All rights reserved.
//

import UIKit

class MealsDataSource: NSObject, UICollectionViewDataSource {
    
    var meals = [Meal]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "MealCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CategoryCollectionViewCell
        
        let meal = meals[indexPath.row]
        cell.nameLabel.text = meal.name
        return cell
    }
}

