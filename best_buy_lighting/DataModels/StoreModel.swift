//
//  StoreModel.swift
//  best_buy_lighting
//
//  Created by Peter Irving on 8/27/19.
//  Copyright © 2019 Peter Irving. All rights reserved.
//

import Foundation

struct StoreRequest: Codable {
    var ispuEligible: Bool?
    var stores: [Store]?
}

struct Store: Codable {
    
    var storeID: String?
    var name: String?
    var address: String?
    var city: String?
    var state: String?
    var postalCode: String?
    var storeType: String?
    var minPickupHours: Int?
    var lowStock: Bool?
    
}
