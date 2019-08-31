//
//  StoresForProductAPI.swift
//  best_buy_lighting
//
//  Created by Peter Irving on 8/27/19.
//  Copyright © 2019 Peter Irving. All rights reserved.
//

import Foundation

class StoresForSkuApi {
    
    
    
    func fetch(sku: Int, callback: @escaping([Store]?, Error?) -> ()) {
        
        let  coordURL: URL = URL(string:  "https://api.bestbuy.com/v1/stores(area(30.267153,-97.743057,50))+products(sku=\(sku))?format=json&show=storeId,storeType,city,address,postalCode,name&pageSize=1&apiKey=\(apiKey)")!
        
        let coord2: URL = URL(string: "https://api.bestbuy.com/v1/products/\(sku)/stores(area(30.267153,-97.743057,50)).json&apiKey=\(apiKey)")!
        
        let url: URL = URL(string:  "https://api.bestbuy.com/v1/products/\(sku)/stores.json?postalCode=78705&apiKey=\(apiKey)")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                callback(nil, error)
            }
            
            guard let data = data else { return }
            
            print(String(bytes: data, encoding: String.Encoding.utf8) ?? "unable to decode")
            print("\n\n")
            do {
                let request = try JSONDecoder().decode(StoreRequest.self, from: data)
                let stores: [Store] = request.stores!
                print("success parsing json")
                callback(stores, nil)
                
            } catch {
                print(error, "error parsing")
                callback(nil, error)
            }
            }.resume()
    }
}

