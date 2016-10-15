//
//  ResultViewMode.swift
//  task4PizzaSearch
//
//  Created by Yu Ma on 3/30/16.
//  Copyright © 2016 Yu Ma. All rights reserved.
//

import UIKit
import CoreLocation

class ResultViewModel : NSObject {
    var result : SearchResultModel!
    var latitude : Double?
    var longtitude : Double?
    var distance : String?
    var title : String?
    var address : String?
    var city : String?
    var state : String?
    var phone : String?
    
    
    init(searchresult :  SearchResultModel){
        self.result = searchresult
        self.latitude = searchresult.latitude
        self.longtitude = searchresult.longtitude
        self.title = searchresult.title
        self.address = searchresult.address
        self.city = searchresult.city
        self.state = searchresult.state
        self.phone = searchresult.phone
        self.distance = ResultViewModel.caculationDistance(self.latitude, log: self.longtitude)
        
        print("kkkkkkaaaa", self.result)
    }
    
    private class func caculationDistance(lat : Double?, log : Double?) -> (String){
        
        let coord1 = CLLocation(latitude: lat!, longitude: log!)
        print("success lon2222", lat, log)
        let location = NSUserDefaults.standardUserDefaults()
        let latitude = (location.stringForKey("latitude")! as NSString).doubleValue
        let longtitude = (location.stringForKey("longtitude")! as NSString).doubleValue
        print("success lon1", latitude, longtitude)
        let coord2 = CLLocation(latitude: latitude, longitude: longtitude)
        

 
        let distance = coord1.distanceFromLocation(coord2)/100000
       
        return String(distance)
    }
}