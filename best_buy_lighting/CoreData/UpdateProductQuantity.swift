//
//  UpdateProductQuantity.swift
//  best_buy_lighting
//
//  Created by Peter Irving on 8/31/19.
//  Copyright © 2019 Peter Irving. All rights reserved.
//

import UIKit
import CoreData

class UpdateProductQuantity {
    
    func updateQuantity(updatedProductSKU: Int, initialQuantity: Int,  newQuantity: Int, callback: @escaping (Bool) -> Void) {
        
        // if updateProducts
        
        var wasSuccessful: Bool = false
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            callback(wasSuccessful)
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "CartItem")
        fetchRequest.predicate = NSPredicate(format: "sku = %@", updatedProductSKU)
        
        do {
            let cartItemContext = try managedContext.fetch(fetchRequest)
            let cartItemUpdate = cartItemContext[0] as! NSManagedObject
            cartItemUpdate.setValue(initialQuantity, forKey: "quantity")
            do {
                try managedContext.save()
                wasSuccessful = true
            }catch {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }

        callback(wasSuccessful)
        return
    }
    
}
