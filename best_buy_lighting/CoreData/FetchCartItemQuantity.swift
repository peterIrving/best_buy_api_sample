//
//  FetchCartItemQuantity.swift
//  best_buy_lighting
//
//  Created by Peter Irving on 8/31/19.
//  Copyright © 2019 Peter Irving. All rights reserved.
//

import UIKit
import CoreData

class FetchCartItemQuantity {
    
    func cartItemCount(sku: Int) -> Int {
        var itemCount = 0
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return itemCount
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItem")
        fetchRequest.predicate = NSPredicate(format: "sku = %d", sku)
        
        fetchRequest.includesSubentities = false
        
        
        do {
            
            let cartItemContext = try managedContext.fetch(fetchRequest)
            print(cartItemContext)
            if cartItemContext.isEmpty {
                return itemCount
            }
            
            let cartItem = cartItemContext[0] as! NSManagedObject
            itemCount = cartItem.value(forKey: "quantity") as! Int
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return itemCount
    }
}
