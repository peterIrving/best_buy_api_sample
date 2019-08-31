//
//  FetchCartItems.swift
//  best_buy_lighting
//
//  Created by Peter Irving on 8/31/19.
//  Copyright © 2019 Peter Irving. All rights reserved.
//


import UIKit
import CoreData

class FetchCartProducts{
    
    func fetch(callback: @escaping (Bool, [Product]?) -> Void) {

        var fetchedProducts: [Product] = []
        
        var wasSuccessful: Bool = false
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            callback(wasSuccessful, fetchedProducts)
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "CartItem")
        
        do {
            
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject]{
                
                print("Data to string \(data.value(forKey: "title")!)")
                let product = Product(
                    name: (data.value(forKey: "title") as? String)!,
                    salePrice: data.value(forKey: "price") as? Double,
                    description: data.value(forKey: "productDescription") as? String,
                    image: data.value(forKey: "imageUrl") as? String,
                    sku: (data.value(forKey: "sku") as? Int)!,
                    quantity: (data.value(forKey: "quantity") as? Int)!
                )
                fetchedProducts.append(product)
                
                
            }
            wasSuccessful = true
        } catch {
            print(error.localizedDescription)
        }
        
        callback(wasSuccessful, fetchedProducts)
        return
    }
    
}
