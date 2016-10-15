//
//  ListShowCell.swift
//  task4PizzaSearch
//
//  Created by Yu Ma on 3/29/16.
//  Copyright © 2016 Yu Ma. All rights reserved.
//


import UIKit


class ListShowCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    var model: SearchResult!
    var viewModel : ResultViewModel!
    
    func configureForSearchResult(searchResult: ResultViewModel) {
        
        nameLabel.text = searchResult.title
        addressLabel.text = searchResult.address
        cityLabel.text = searchResult.city
        stateLabel.text = searchResult.state
        phoneLabel.text = searchResult.phone
        distanceLabel.text = searchResult.distance
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
                
        nameLabel.text = nil
        addressLabel.text = nil
        cityLabel.text = nil
        stateLabel.text = nil
        phoneLabel.text = nil
    }

    
}
