//
//  StoreCell.swift
//  best_buy_lighting
//
//  Created by Peter Irving on 8/27/19.
//  Copyright © 2019 Peter Irving. All rights reserved.
//

import UIKit

class StoreCell: UITableViewCell {
    
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var streetAddress: UILabel!
    @IBOutlet weak var cityAndZip: UILabel!
    @IBOutlet weak var milesAway: UILabel!
    
    func setupCell(store: Store) {
        storeName.text = store.name
        streetAddress.text = store.address
        cityAndZip.text = (store.city! + ", " + store.postalCode!)
    }
}
