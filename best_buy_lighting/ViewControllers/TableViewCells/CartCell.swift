//
//  CartCell.swift
//  best_buy_lighting
//
//  Created by Peter Irving on 8/29/19.
//  Copyright © 2019 Peter Irving. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var quantityAndTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var sku: Int?
    
    func setupCell(quantity: Int, title: String, description: String, price: Double, sku: Int, imageUrl: String) {
        
        quantityAndTitleLabel.text = "(\(quantity)) \(title)"
        descriptionLabel.text = description
        priceLabel.text = "$\(price)"
        self.sku = sku
         let url = URL(string: imageUrl)
        productImageView.kf.setImage(with: url)
    }
    
    @IBAction func findStoresClicked(_ sender: UIButton) {
        print("sku \(sku)")
    }
    
    
    
}
