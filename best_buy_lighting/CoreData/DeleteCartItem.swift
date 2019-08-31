//
//  DeleteCartItem.swift
//  best_buy_lighting
//
//  Created by Peter Irving on 8/31/19.
//  Copyright © 2019 Peter Irving. All rights reserved.
//

import UIKit
import CoreData

class DeleteCartItem{
    
    func delete(sku: Int, callback: @escaping (Bool) -> Void) {
        
        var wasSuccessful: Bool = false
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            callback(wasSuccessful)
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "CartItem")
        fetchRequest.predicate = NSPredicate(format: "sku = %d", sku)
        
        do {
            
            let cartItemEntity = try managedContext.fetch(fetchRequest)
            let cartItem = cartItemEntity[0] as! NSManagedObject
            managedContext.delete(cartItem)
            do {
                try managedContext.save()
                wasSuccessful = true
            }catch {
                print(error.localizedDescription)
            }
            
            wasSuccessful = true
        } catch {
            print(error.localizedDescription)
        }
        
        callback(wasSuccessful)
        return
    }
    
}
