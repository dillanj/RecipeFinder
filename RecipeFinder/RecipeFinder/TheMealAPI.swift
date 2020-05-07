//
//  TheMealAPI.swift
//  RecipeFinder
//
//  Created by Dillan Johnson on 11/12/19.
//  Copyright © 2019 Dillan Johnson. All rights reserved.
//


// This API Struct is responsible for knowing how to generate URLS that TheMealDB API expects
// as well as knowing the format of the incoming JSON and how to parse
// that  JSON into relevant model objects.
import Foundation

enum TheMealError: Error {
    case invalidJSONData
}

enum Method: String {
    case allCategories = "categories.php"
    case mealsByCategory = "filter.php?c=" // insert category name after =
    case recipeID = "lookup.php?i=" //insert recipe id after =
}

struct TheMealAPI {
    
    private static let baseURLString = "https://www.themealdb.com/api/json/v1/1/"
    
    private static func theMealURL( method: Method, parameter: String? ) -> URL {
        if method == .allCategories {
            return URL(string: baseURLString + method.rawValue)!
        }
        else if method == .mealsByCategory {
            if let categoryName = parameter{
                return URL(string: baseURLString + method.rawValue + categoryName)!
            }
        }
        else if method == .recipeID {
            if let recipeID = parameter{
                return URL(string: baseURLString + method.rawValue + recipeID)!
            }
        }
        return URL(string: "")!
    } // end of theMealURL()
    
    static func categories(fromJSON data: Data)->CategoriesResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard
                let jsonDictionary = jsonObject as? [AnyHashable:Any],
                let categoriesArray = jsonDictionary["categories"] as? [[String:Any]] else {
                    // the JSON structure doesn't match expectations
                    return .failure(TheMealError.invalidJSONData)
            }
            var finalCategories = [Category]()
            for categoryJSON in categoriesArray {
                if let category = category(fromJSON: categoryJSON){
                    finalCategories.append(category)
                }
            }
            if finalCategories.isEmpty && !categoriesArray.isEmpty {
                print("finalCategoris size: \(finalCategories.count)")
                print("categoriesArray size: \(categoriesArray.count)")
                // wasn't able to parse any of the categories
                // maybe the JSON format for categories has changed.
                return .failure(TheMealError.invalidJSONData)
            }
            return .success(finalCategories)
        } catch let error {
            return .failure(error)
        }
    } // end of categories()
    
    // this functions purpose is to parse a JSON dictionary into a Category instance
    private static func category(fromJSON json: [String: Any]) -> Category? {
        guard
            let catID = json["idCategory"] as? String,
            let catPhotoURLString = json["strCategoryThumb"] as? String,
            let catName = json["strCategory"] as? String,
            let description = json["strCategoryDescription"] as? String,
            let catPhoto = URL(string: catPhotoURLString) else{
                // Don't have neough info to construct a category
                return nil
        }
        if let intId = Int(catID) {
            return Category(id: intId, photo: catPhoto, name: catName, description: description)
        }
        return Category(id: 0, photo: catPhoto, name: catName, description: description)
        
    }
    
    static func meals(fromJSON data: Data)->MealsResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard
                let jsonDictionary = jsonObject as? [AnyHashable:Any],
                let mealsArray = jsonDictionary["meals"] as? [[String:Any]] else {
                    // the JSON structure doesn't match expectations
                    return .failure(TheMealError.invalidJSONData)
            }
            var finalMeals = [Meal]()
            for mealJSON in mealsArray {
                if let meal = meal(fromJSON: mealJSON){
                    finalMeals.append(meal)
                }
            }
            if finalMeals.isEmpty && !mealsArray.isEmpty {
                print("finalMeals size: \(finalMeals.count)")
                print("mealsArray size: \(mealsArray.count)")
                // wasn't able to parse any of the categories
                // maybe the JSON format for categories has changed.
                return .failure(TheMealError.invalidJSONData)
            }
            return .success(finalMeals)
        } catch let error {
            return .failure(error)
        }
    } // end of categories()
    
    private static func meal(fromJSON json: [String: Any]) -> Meal? {
        guard
            let mealID = json["idMeal"] as? String,
            let mealPhotoURLString = json["strMealThumb"] as? String,
            let mealName = json["strMeal"] as? String,
            let mealPhoto = URL(string: mealPhotoURLString) else{
                // Don't have neough info to construct a category
                return nil
        }
        let intId = Int(mealID)!
        return Meal(id: intId, name: mealName, photo: mealPhoto)
    }
    
    static func recipes(fromJSON data: Data)->RecipeResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard
                let jsonDictionary = jsonObject as? [AnyHashable:Any],
                let recipes = jsonDictionary["meals"] as? [[String:Any]] else {
                    return .failure(TheMealError.invalidJSONData)
            }
            var finalRecipe: Recipe!
            let r = recipe(fromJSON: recipes[0])
            finalRecipe = r
            return .success(finalRecipe)
        } catch let error {
            return .failure(error)
        }
    } // end of recipes()
    
    private static func recipe(fromJSON json: [String: Any])-> Recipe?{
        guard
            let recipeId = json["idMeal"] as? String,
            let recipePhotoString = json["strMealThumb"] as? String,
            let recipeName = json["strMeal"] as? String,
            let recipeInstrcutions = json["strInstructions"] as? String,
            let recipePhoto = URL(string: recipePhotoString) else {
                return nil
        }
        // get the ingredients and measurements
        var ingredients = [String]()
        for i in 1...20 {
            if let ingredient = json["strIngredient\(i)"] as? String,
                let measurement = json["strMeasure\(i)"] as? String {
                let concat_ingredient = measurement + " " + ingredient    
                if ( ingredient != "" && measurement != ""){
//                    print("ingredient = : \(concat_ingredient)")
                    ingredients.append(concat_ingredient)
                }
            }
        } // end of for loop
        let intId = Int(recipeId)!
        return Recipe(id: intId, name: recipeName, instructions: recipeInstrcutions, photo: recipePhoto, ingredients: ingredients)
            
    } // end of recipe()
    
    
    static var allCategoriesURL: URL {
        return theMealURL(method: .allCategories, parameter: nil)
    }
    
    static func mealsByCategoryURL(categoryName: String)-> URL {
        return theMealURL(method: .mealsByCategory, parameter: categoryName)
    }
    
    static func recipeByIdURL(recipeId: String)-> URL {
        return theMealURL(method: .recipeID, parameter: recipeId)
    }
}
