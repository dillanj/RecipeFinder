//
//  RecipesViewController.swift
//  RecipeFinder
//
//  Created by Dillan Johnson on 11/13/19.
//  Copyright © 2019 Dillan Johnson. All rights reserved.
//

import UIKit

class MealsViewController: UIViewController, UICollectionViewDelegate {
    @IBOutlet var collectionView: UICollectionView!
    
    var category: Category! {
        didSet {
            navigationItem.title = category.name
        }
    }
   var recipeBank: RecipeBank!
   let mealsDataSource = MealsDataSource()
   
   override func viewDidLoad() {
        super.viewDidLoad()
       
        collectionView.dataSource = mealsDataSource
        collectionView.delegate = self
        recipeBank.fetchMealsByCategory(for: category.name) {
           (MealsResult) -> Void in
           
           switch MealsResult {
           case let .success(meals):
               print("successfully found \(meals.count) meals.")
               self.mealsDataSource.meals = meals
           case let .failure(error):
               print("Error fetching all meals: \(error)")
               self.mealsDataSource.meals.removeAll()
           }
           self.collectionView.reloadSections(IndexSet(integer: 0))
       }
   }// end of didLoad()
   
   func collectionView(_ collectionView: UICollectionView,
                       willDisplay cell: UICollectionViewCell,
                       forItemAt indexPath: IndexPath){
       
       let meal = mealsDataSource.meals[indexPath.row]
       
       recipeBank.fetchMealImage(for: meal) { (result) -> Void in
           
           // the index path for the category might have changed between
           // the time request started and finished, so find the most
           // recent index path
           
        guard let mealIndex = self.mealsDataSource.meals.firstIndex(of: meal),
               case let .success(image) = result else {
                   return
           }
           let mealIndexPath = IndexPath(item: mealIndex, section: 0)
           
           // when the request finishes, only up the cell if its still visible
           if let cell = self.collectionView.cellForItem(at: mealIndexPath) as? CategoryCollectionViewCell {
               cell.update(with: image)
           }
       }
   }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        switch segue.identifier {
        case "showRecipe"?:
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                
                let meal = mealsDataSource.meals[selectedIndexPath.row]
                
                let destinationVC = segue.destination as! RecipeViewController
                destinationVC.category = category
                destinationVC.recipeBank = recipeBank
                destinationVC.meal = meal
                
            }
            default:
            preconditionFailure("Unexpected segue identifier")
        }
        
    }

}
