//
//  ProductDetailViewController.swift
//  best_buy_lighting
//
//  Created by Peter Irving on 8/22/19.
//  Copyright © 2019 Peter Irving. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var secondaryImageView: UIImageView!
    
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        titleLabel.text = product.name
        descriptionLabel.text = product.shortDescription
        priceLabel.text = "$\(product.salePrice ?? 0.00)"
        if let mainUrl = URL(string: product.image!) {
            mainImageView.kf.setImage(with: mainUrl)
            
        }
        //MARK EXTEND UI IMAGE TO HANDLE THIS AND SHOW A STOCK IMAGE IF NULL
        if let alternateURLString = product.alternateViewsImage {
            let imgUrl = URL(string: alternateURLString)

            secondaryImageView.kf.setImage(with: imgUrl)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is FindStoresViewController {
            let vc = segue.destination as? FindStoresViewController
            vc?.nameString = product.name
            vc?.descriptionString = product.shortDescription
            vc?.imageUrl = product.image
            vc?.sku = product.sku
        }
    }
    
    @IBAction func addToCartClicked(_ sender: UIButton) {
        
        let itemCount = FetchCartItemQuantity().cartItemCount(sku: product.sku) ?? 0
        print("there are this many items \(itemCount)")
        
        // create the alert
        let alert = UIAlertController(title: "Add?", message: "Would you like to add \(product.name) to your cart?", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: {
            
            action in
            
            if itemCount > 0 {
                self.updateProductQuantity(itemCount: itemCount)
            } else if itemCount == 0 {
                self.insertProductToCart()
            }
            
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {action in print("cancel")}))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func insertProductToCart() {
        
        InsertCartItem().insert(addedProduct: product) { (success) in
            var title = "Failure"
            var message = "There was an error trying to save to cart"
            if success {
                title = "Success"
                message = "Product added to cart"
            }
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertAction.Style.cancel, handler: {action in print("")}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateProductQuantity(itemCount: Int) {
        
        print("item count \(itemCount)")
        
        UpdateCartItemQuantity().updateQuantity(updatedProductSKU: product!.sku, initialQuantity: itemCount, addend: 1) { (success) in
            print("success")
        }
        
    }
        
}






