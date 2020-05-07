//
// CategoriesViewDataSource.swift
//  RecipeFinder
//
//  Created by Dillan Johnson on 11/12/19.
//  Copyright © 2019 Dillan Johnson. All rights reserved.
//

import UIKit

class CategoriesDataSource: NSObject, UICollectionViewDataSource {
    
    var categories = [Category]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "CategoryCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CategoryCollectionViewCell
        
        let category = categories[indexPath.row]
        cell.nameLabel.text = category.name
        return cell
    }
}
