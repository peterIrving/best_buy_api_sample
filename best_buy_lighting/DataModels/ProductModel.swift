//
//  ProductModel.swift
//  best_buy_lighting
//
//  Created by Peter Irving on 8/22/19.
//  Copyright © 2019 Peter Irving. All rights reserved.
//

import Foundation
import CoreData

struct ProductRequest: Codable {
    let from, to, currentPage, total, totalPages: Int?
    let queryTime, totalTime, canonicalURL: String?
    let products: [Product]
}

class Product: Codable{
    
    var name: String
    var salePrice: Double?
    var shortDescription: String?
    var image: String?
    var alternateViewsImage: String?
    var sku: Int
    var quantity: Int?

    init(name: String, salePrice: Double?, description: String?, image: String?, sku: Int, quantity: Int) {
        self.name = name
        self.salePrice = salePrice
        self.shortDescription = description
        self.image = image
        self.sku = sku
        self.quantity = quantity
    }
}
