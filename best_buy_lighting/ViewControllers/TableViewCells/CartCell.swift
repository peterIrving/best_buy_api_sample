//
//  CartCell.swift
//  best_buy_lighting
//
//  Created by Peter Irving on 8/29/19.
//  Copyright © 2019 Peter Irving. All rights reserved.
//

import UIKit

protocol didUpdateQuantity {
    func reloadUI()
}

class CartCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var quantityAndTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var sku: Int?
    var quantity: Int?
    
    var delegate: didUpdateQuantity?
    
    func setupCell(quantity: Int, title: String, description: String, price: Double, sku: Int, imageUrl: String) {
        self.selectionStyle = .none
        quantityAndTitleLabel.text = "(\(quantity)) \(title)"
        descriptionLabel.text = description
        priceLabel.text = "$\(price)"
        self.sku = sku
        self.quantity = quantity
        let url = URL(string: imageUrl)
        productImageView.kf.setImage(with: url)
    }
    
    @IBAction func plusOneClicked(_ sender: UIButton) {
        updateQuantity(addend: 1)
    }
    
    @IBAction func minusOneClicked(_ sender: UIButton) {
        updateQuantity(addend: -1)
    }
    
    func updateQuantity(addend: Int) {
        UpdateCartItemQuantity().updateQuantity(updatedProductSKU: sku!, initialQuantity: quantity!, addend: addend) { (success) in
            self.delegate?.reloadUI()
        }
    }
    
    
    @IBAction func findStoresClicked(_ sender: UIButton) {
        print("sku \(sku)")
    }
    
    
    
}
