//
//  ViewModelFactory.swift
//  task4PizzaSearch
//
//  Created by Yu Ma on 3/30/16.
//  Copyright © 2016 Yu Ma. All rights reserved.
//

import UIKit

class ViewModelFactory: NSObject {
    
    
    class func convertResultModelToViewModel(originalData : [SearchResultModel]) ->[ResultViewModel]{
        var resultArray = [ResultViewModel]()
        for result in originalData{
            
            let viewModel = ResultViewModel(searchresult: result)
            resultArray.append(viewModel)
        }
        return resultArray
    }
    

}
