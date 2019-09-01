//
//  ProductCell.swift
//  best_buy_lighting
//
//  Created by Peter Irving on 8/22/19.
//  Copyright © 2019 Peter Irving. All rights reserved.
//

import UIKit
import Kingfisher

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var salePriceLabel: UILabel!
    
    func setupCell(product: Product) {
        nameLabel.text = product.name
        salePriceLabel.text = "$\(product.salePrice!)"
//        if let url = URL(string: product.image) {
//            productImage.kf.setImage(with: url)
//        }
        if let urlString = product.image {
            let imgUrl = URL(string: urlString)
            
            productImage.kf.setImage(with: imgUrl)
        }
//        productImage.kf.setImage(with: url)
    }
}
