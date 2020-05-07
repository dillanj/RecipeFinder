//
//  RecipeBank.swift
//  RecipeFinder
//
//  Created by Dillan Johnson on 11/12/19.
//  Copyright © 2019 Dillan Johnson. All rights reserved.
//

import UIKit

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

enum PhotoError: Error {
    case imageCreationError
}

enum CategoriesResult {
    case success([Category])
    case failure(Error)
}

enum MealsResult {
    case success([Meal])
    case failure(Error)
}

enum RecipeResult {
    case success(Recipe)
    case failure(Error)
}

class RecipeBank {
//    var allCategorys = [Category]()
//    var allMeals = [Meal]()
//    var allRecipes = [Recipe]()
//
//    let categoriesArchiveURL: URL = {
//        let documentsDirectories =
//            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentDirectory = documentsDirectories.first!
//        return documentDirectory.appendingPathComponent("categories.archive")
//    }()
    
    let imageStore = ImageStore()
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchAllCategories(completion: @escaping (CategoriesResult) -> Void) {
        let url = TheMealAPI.allCategoriesURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request){
            (data, response, error)-> Void in
            
            let result = self.processCategoriesRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    } // end of fetchAllCategories()
    
    private func processCategoriesRequest(data: Data?, error: Error?)-> CategoriesResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return TheMealAPI.categories(fromJSON: jsonData)
    }
    
    func fetchCategoryImage(for category: Category, completion: @escaping (ImageResult) -> Void){
        
        let photoKey = String(category.id)
        if let image = imageStore.image(forKey: photoKey) {
            OperationQueue.main.addOperation {
                completion(.success(image))
            }
            return
        }
        
        let imageURL = category.photo
        let request = URLRequest(url: imageURL)
        
        let task = session.dataTask(with: request){
            (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data, error: error)
            
            if case let .success(image) = result {
                self.imageStore.setImage(image, forKey: photoKey)
            }
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    } // end of fetchImage()
    
    func fetchMealsByCategory(for categoryName: String, completion: @escaping (MealsResult) -> Void) {
        let url = TheMealAPI.mealsByCategoryURL(categoryName: categoryName)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request){
            (data, response, error)-> Void in
            
            let result = self.processMealsRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    } // end of fetchAllCategories()
    
    private func processMealsRequest(data: Data?, error: Error?)-> MealsResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return TheMealAPI.meals(fromJSON: jsonData)
    }
    
    func fetchMealImage(for meal: Meal, completion: @escaping (ImageResult) -> Void){
        
        let photoKey = String(meal.id)
        if let image = imageStore.image(forKey: photoKey) {
            OperationQueue.main.addOperation {
                completion(.success(image))
            }
            return
        }
        
        let imageURL = meal.photo
        let request = URLRequest(url: imageURL)
        
        let task = session.dataTask(with: request){
            (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data, error: error)
            if case let .success(image) = result {
                self.imageStore.setImage(image, forKey: photoKey)
            }
            
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    } // end of fetchImage()
    
    func fetchRecipeById(for id: String, completion: @escaping (RecipeResult) -> Void) {
        let url = TheMealAPI.recipeByIdURL(recipeId: id)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request){
            (data, response, error)-> Void in
            let result = self.processRecipeRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    } // end of fetchRecipe()
    
    private func processRecipeRequest(data: Data?, error: Error?)-> RecipeResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return TheMealAPI.recipes(fromJSON: jsonData)
    }
    
    func fetchRecipeImage(for recipe: Recipe, completion: @escaping (ImageResult) -> Void){
        let photoKey = String(recipe.id)
        if let image = imageStore.image(forKey: photoKey) {
            OperationQueue.main.addOperation {
                completion(.success(image))
            }
            return
        }
        
        let imageURL = recipe.photo
        let request = URLRequest(url: imageURL)
        
        let task = session.dataTask(with: request){
            (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data, error: error)
            if case let .success(image) = result {
                self.imageStore.setImage(image, forKey: photoKey)
            }
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    } // end of fetchImage()
    

    
    private func processImageRequest(data: Data?, error: Error?) ->ImageResult {
          guard
          let imageData = data,
              let image = UIImage(data: imageData) else {
                  // couldn't create an image
                  
                  if data == nil {
                      return .failure(error!)
                  } else {
                      return.failure(PhotoError.imageCreationError)
                  }
          }
          return .success(image)
      }
    
    
    
    
} // end of Recipe Bank class
