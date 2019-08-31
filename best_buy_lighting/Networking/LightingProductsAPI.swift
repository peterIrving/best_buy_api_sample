//
//  FetchLightingProductsAPI.swift
//  best_buy_lighting
//
//  Created by Peter Irving on 8/22/19.
//  Copyright © 2019 Peter Irving. All rights reserved.
//

import Foundation

class LightingProductsAPI {

    
    func fetch(callback: @escaping([Product]?, Error?) -> ()) {
        
        let url: URL = URL(string: "https://api.bestbuy.com/v1/products(categoryPath.id=pcmcat345400050002)?format=json&show=sku,name,salePrice,shortDescription,image,alternateViewsImage&apiKey=\(apiKey)")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                callback(nil, error)
            }
            // also check response status 200 okay
            
            guard let data = data else { return }
            
            print(String(bytes: data, encoding: String.Encoding.utf8) ?? "unable to decode")
            print("\n\n")
            do {
                let request = try JSONDecoder().decode(ProductRequest.self, from: data)
                let products: [Product] = request.products
                print("success parsing json")
                callback(products, nil)
               
            } catch {
                print(error, "error parsing")
                callback(nil, error)
            }
        }.resume()
    }
}
