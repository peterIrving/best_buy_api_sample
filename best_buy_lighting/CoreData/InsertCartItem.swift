//
//  InsertCartItem.swift
//  best_buy_lighting
//
//  Created by Peter Irving on 8/31/19.
//  Copyright © 2019 Peter Irving. All rights reserved.
//

import UIKit
import CoreData

class InsertCartItem {
    
    func insert(addedProduct: Product, callback: @escaping (Bool) -> Void) {
        
        var wasSuccessful: Bool = false
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            callback(wasSuccessful)
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let cartItemEntity = NSEntityDescription.entity(forEntityName: "CartItem", in: managedContext)!
        
        let cartItem = NSManagedObject(entity: cartItemEntity, insertInto: managedContext)
        
        cartItem.setValue(addedProduct.name, forKey: "title")
        cartItem.setValue(addedProduct.sku, forKey: "sku")
        cartItem.setValue(1, forKey: "quantity")
        cartItem.setValue(addedProduct.shortDescription, forKey: "productDescription")
        cartItem.setValue(addedProduct.salePrice, forKey: "price")
        cartItem.setValue(addedProduct.image, forKey: "imageUrl")
        
        do {
            try managedContext.save()
            print("saved to core data")
            wasSuccessful = true
        } catch {
            print("could not save recording: \(error.localizedDescription)")
            wasSuccessful = false
        }
        callback(wasSuccessful)
        return
    }
    
}
