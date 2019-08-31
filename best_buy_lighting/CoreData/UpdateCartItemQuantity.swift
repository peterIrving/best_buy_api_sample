//
//  UpdateProductQuantity.swift
//  best_buy_lighting
//
//  Created by Peter Irving on 8/31/19.
//  Copyright © 2019 Peter Irving. All rights reserved.
//

import UIKit
import CoreData

class UpdateCartItemQuantity {
    
    func updateQuantity(updatedProductSKU: Int, initialQuantity: Int, addend: Int, callback: @escaping (Bool) -> Void) {
    
        var wasSuccessful: Bool = false
        let newQuantity: Int = initialQuantity + addend
        
        if newQuantity == 0 {
            print("deleting item")
            DeleteCartItem().delete(sku: updatedProductSKU) { (success) in
                print("successfully deleted")
            }
            callback(wasSuccessful)
            return
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            callback(wasSuccessful)
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "CartItem")
        fetchRequest.predicate = NSPredicate(format: "sku = %d", updatedProductSKU)
        
        do {
            let cartItemContext = try managedContext.fetch(fetchRequest)
            let cartItem = cartItemContext[0] as! NSManagedObject
        
            cartItem.setValue(newQuantity, forKey: "quantity")

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
