//
//  CategoriesViewController.swift
//  RecipeFinder
//
//  Created by Dillan Johnson on 11/12/19.
//  Copyright © 2019 Dillan Johnson. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController, UICollectionViewDelegate {
    @IBOutlet var collectionView: UICollectionView!
    
    var recipeBank: RecipeBank!
    let categoriesDataSource = CategoriesDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = categoriesDataSource
        collectionView.delegate = self
        recipeBank.fetchAllCategories {
            (CategoriesResult) -> Void in
            
            switch CategoriesResult {
            case let .success(categories):
                print("successfully found \(categories.count) categories.")
                self.categoriesDataSource.categories = categories
            case let .failure(error):
                print("Error fetching all categories: \(error)")
                self.categoriesDataSource.categories.removeAll()
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }// end of didLoad()
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath){
        let category = categoriesDataSource.categories[indexPath.row]
        
        recipeBank.fetchCategoryImage(for: category) { (result) -> Void in
            
            // the index path for the category might have changed between
            // the time request started and finished, so find the most
            // recent index path
            
            guard let categoryIndex = self.categoriesDataSource.categories.firstIndex(of: category),
                case let .success(image) = result else {
                    return
            }
            let categoryIndexPath = IndexPath(item: categoryIndex, section: 0)
            
            // when the request finishes, only up the cell if its still visible
            if let cell = self.collectionView.cellForItem(at: categoryIndexPath) as? CategoryCollectionViewCell {
                cell.update(with: image)
            }
        }
    } // end of collectionView()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        switch segue.identifier {
        case "showMeals"?:
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                
                let category = categoriesDataSource.categories[selectedIndexPath.row]
                
                let destinationVC = segue.destination as! MealsViewController
                destinationVC.category = category
                destinationVC.recipeBank = recipeBank
            }
            default:
            preconditionFailure("Unexpected segue identifier")
        }
        
    }
    
   
    
    
    
} // end of class
