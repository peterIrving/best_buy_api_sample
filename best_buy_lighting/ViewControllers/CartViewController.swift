//
//  CartViewController.swift
//  best_buy_lighting
//
//  Created by Peter Irving on 8/29/19.
//  Copyright © 2019 Peter Irving. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subtotalLabel: UILabel!
    
    var products: [Product] = []
    var totalCount: Int = 0
    var totalPrice: Double = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCartData()
        setupUI()
    }
    
    func setupUI() {
        subtotalLabel.text = "Subtotal (\(totalCount) items): $\(totalPrice)"
    }
    
    func fetchCartData() {
        FetchCartProducts().fetch { (success, products) in
            self.products = products!
          
            (self.totalPrice, self.totalCount) = self.getTotalCountAndPrice(products: products!)
            
            self.tableView.reloadData()
        }
    }
    
    func getTotalCountAndPrice(products: [Product]) -> (Double, Int) {
        
        var count = 0
        var price = 0.00
        // get total count of all itmes
        products.forEach { (product) in
            count += product.quantity!
            price += (product.salePrice! * Double(product.quantity!))
        }
        
        return (price, count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        let product = products[indexPath.row]
        cell.setupCell(
            quantity: product.quantity!,
            title: product.name,
            description: product.shortDescription!,
            price: product.salePrice!,
            sku: product.sku, imageUrl: product.image!)
        return cell
    }
}
