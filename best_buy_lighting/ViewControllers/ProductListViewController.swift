//
//  ProductListViewController.swift
//  best_buy_lighting
//
//  Created by Peter Irving on 8/21/19.
//  Copyright © 2019 Peter Irving. All rights reserved.
//

import UIKit
import GoogleSignIn

class ProductListViewController: UITableViewController, GIDSignInUIDelegate {
    
    //MARK: SYNC DATA FLOW
    // 1: CHECK IF THERE IS ANY PRODUCTS IN CORE DATA
    // 2: IF THERE ARE, FETCH AND SHOW
    // 3: IF NOT, API CALL > place items in core data > FETCH FROM CORE DATA
    // 4: ON PULLDOWN FETCH CALL API
        // A: CHECK SKU's against CORE DATA SKU's
            // i: IF SKU DOESNT EXIST IN CORE DATA, ADD (fetched product)
            // ii: IF SKU DOES EXIST IN CORE DATA, do nothing
            // iii: IF SKU DOESNT EXIST IN FETCHED DATA, DELETE FROM CORE DATA
    
    var products: [Product] = [Product]()
    let refresher = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControll()
        loadProducts(isRefreshing: false)
    }
    
    func setupRefreshControll() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refresher
        } else {
            tableView.addSubview(refresher)
        }
        refresher.addTarget(self, action: #selector(refreshProductData(_:)), for: .valueChanged)
    }
    
    @objc func refreshProductData(_ sender: Any) {
        loadProducts(isRefreshing: true)
        
    }
    
    func loadProducts(isRefreshing: Bool) {
        if isRefreshing == false {
            self.showSpinner(onView: self.view)
        }
        
        LightingProductsAPI().getProductData(refresh: isRefreshing) { (fetchedProducts, error) in
            if let error = error {
                self.showNetworkErrorAlert(title: "There was an error",message: error.localizedDescription)
                self.removeSpinner()
                return
            }
            
            
            if let prods = fetchedProducts {
                print("setting proudcts")
                self.products = prods
            } else {
                print("setting products to []")
                self.products = []
            }
            

            DispatchQueue.main.async {
                
                if isRefreshing {
                    self.refresher.endRefreshing()
                } else {
                    self.removeSpinner()
                }
                
                self.tableView.reloadData()
//                if self.products.isEmpty {
//                    self.showNetworkErrorAlert(title: "No results",message: "There were no results found")
//                }
            }
        
        }
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if products.count == 0 {
            return 0
        }
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        let product = products[indexPath.row]
        
        cell.setupCell(product: product)
       
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is ProductDetailViewController {
            if products.isEmpty {
                return
            }
            let productToPass = products[selectedRow]
            
            if let detailViewController = segue.destination as? ProductDetailViewController {
                detailViewController.product = productToPass
            }
            self.removeSpinner()
        } 
        
    }
    
    var selectedRow: Int = -1
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        selectedRow = indexPath.row
        performSegue(withIdentifier: "SegueToProductDetail", sender: self)
        // this calls prepare for segue
    }
    
    @IBAction func logOutClicked(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        navigationController?.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "BackToLogin", sender: self)
        
    }
    
    @IBAction func cartClicked(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "SegueToCart", sender: self)
    }
    
    
}
