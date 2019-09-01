//
//  FetchLightingProductsAPI.swift
//  best_buy_lighting
//
//  Created by Peter Irving on 8/22/19.
//  Copyright © 2019 Peter Irving. All rights reserved.
//

import Foundation

class LightingProductsAPI {

    var fetchedProducts: [Product]?
    var fetchError: Error?
    
    func getProductData(refresh: Bool, callback: @escaping([Product]?, Error?) -> ()) {
       
        
        if refresh == true {
            print("refresh true, network fetching")
            networkFetch { (products, error) in
                callback(self.fetchedProducts, self.fetchError)
                return
            }
        } else {
            
            // I spent some time using FileManager.fileExists() for path getDocumentsDirectory().appendingPathComponent("products.json").absoluteString but the function would only return false, So to make this work, I just decided on a failed local fetch, go ahead and try a network fetch
            
            localFetch { (products, error) in
                print("in local fetch closure")
            
                if products == nil {
                    // if there is no local data stored or there was an error fetching data
                    self.networkFetch(callback: { (products, error) in
                        print("network fetch errror \(error)")
                        callback(self.fetchedProducts, nil)
                        return
                    })
                }
                callback(self.fetchedProducts, self.fetchError)
                return
            }
        }
//
//            let filename = getDocumentsDirectory().appendingPathComponent("products.json").absoluteString
//
//            print("filename: \(filename)")
//            let fileManager = FileManager.default
//
//            if fileManager.fileExists(atPath: filename) {
//                print("file exists, fetch data from disk")
//            } else {
//                print("file does not exists, initiate network fetch")
//                networkFetch { (products, error) in
//                    print("")
//                    callback(self.fetchedProducts, self.fetchError)
//                }
//            }
//
//        }
    }
    
    func localFetch(callback: @escaping([Product]?, Error?) -> ()){
        
        let filename = getDocumentsDirectory().appendingPathComponent("products.json")
        do {
            let productData = try Data.init(contentsOf: filename)
            convertJsonToProducts(data: productData)
            
        } catch {
            print("error fetching data locally, will try network fetch")
//            self.fetchError = error
        }
        callback(self.fetchedProducts, self.fetchError)
    }
    
    func networkFetch(callback: @escaping([Product]?, Error?) -> ()) {
        
        let lightingProductCode = "pcmcat345400050002"
        
        // use this to load test data and show that refreshing works
        let cameraProductCode = "abcat0400000"
 
        
        let url: URL = URL(string: "https://api.bestbuy.com/v1/products(categoryPath.id=\(lightingProductCode))?format=json&show=sku,name,salePrice,shortDescription,image,alternateViewsImage&pageSize=30&apiKey=\(apiKey)")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                self.fetchError = error
                return
            }
            
            guard let data = data else { return }
            
            self.writeDataToDisk(data: data)
            
            self.convertJsonToProducts(data: data)
            callback(self.fetchedProducts, self.fetchError)
            
        }.resume()
    }
    
    func convertJsonToProducts(data: Data) {

        do {
            let request = try JSONDecoder().decode(ProductRequest.self, from: data)
            fetchedProducts = request.products
            fetchError = nil
            print("success parsing json")
        } catch {
            print(error, "error parsing")
            fetchError = error
            fetchedProducts = nil
        }

    }

    
    
    func writeDataToDisk (data: Data) {
        let filename = getDocumentsDirectory().appendingPathComponent("products.json")
        do {
            print("filename to be written: \(filename)")
            try data.write(to: filename)
            print("success writing data to disk")
        } catch {
            print("error writing product json to disk, will have to fetch from network again")
        }
    }
   
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0]
    }

}
