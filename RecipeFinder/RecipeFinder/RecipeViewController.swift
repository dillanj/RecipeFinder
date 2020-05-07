//
//  RecipeViewController.swift
//  RecipeFinder
//
//  Created by Dillan Johnson on 11/13/19.
//  Copyright © 2019 Dillan Johnson. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {
    @IBOutlet var instructionsBox: UITextView!
    @IBOutlet var ingredientStack: UIStackView!
    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var leftStack: UIStackView!
    @IBOutlet var rightStack: UIStackView!
    
    var category: Category!
    var recipeBank: RecipeBank!
    var recipe: Recipe!
    var meal: Meal! {
        didSet{
            navigationItem.title = meal.name
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let string_id = String(meal.id)
        
        recipeBank.fetchRecipeById(for: string_id) {
            (RecipeResult) -> Void in
            
            switch RecipeResult {
            case let .success(recipe):
                self.recipe = recipe
                self.updateView(true)
                print("successfully found the recipe: \(recipe.name).")
            case let .failure(error):
                print("Error fetching all meals: \(error)")

            }
        }
    }// end of didLoad()
    
    
    func updateView(_ animated: Bool) {
        recipeBank.fetchRecipeImage(for: recipe) { (result) -> Void in
            switch result {
            case let .success(image):
                self.recipeImage.image = image
            case let .failure(error):
                print("error: \(error)")
            }
        // set the outlet properties here
            let half = self.recipe.ingredients.count / 2
            self.instructionsBox.text = self.recipe.instructions
            for i in 0...half {
                let label = UILabel()
                label.text = "\(self.recipe.ingredients[i])"
                label.font = label.font.withSize(10)
                self.leftStack.addArrangedSubview(label)
    
            }
            for i in half+1...self.recipe.ingredients.count - 1 {
                let label = UILabel()
                label.text = "\(self.recipe.ingredients[i])"
                label.font = label.font.withSize(10)
    //            label.translatesAutoresizingMaskIntoConstraints = false
                self.rightStack.addArrangedSubview(label)
            }
            
    }
}
    
    
    
    
}//end of class
