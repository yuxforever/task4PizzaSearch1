//
//  APIClient.swift
//  task4PizzaSearch
//
//  Created by Yu Ma on 3/30/16.
//  Copyright © 2016 Yu Ma. All rights reserved.
//

import UIKit


class APIClient: NSObject {

    class func searchByYahoo(searchText: String, zipCode : String, completion:(isSuccess:Bool,resultArray:[SearchResultModel])-> Void ){
        if(!searchText.isEmpty){
            let url = APIClient.urlWithSearchText(searchText, zip: zipCode)
            let session = NSURLSession.sharedSession()
             let dataTask = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(isSuccess: false,resultArray: [SearchResultModel]())
                    })
                }else{
                    if data != nil {
                        let dataDic = APIClient.convertDataToDic(data!)
                        if dataDic != nil {
                            let resultArray = APIClient.convertDicToResultArray(dataDic!)
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completion(isSuccess: true,resultArray: resultArray)
                            })
                        }
                    }
                }
             })
            dataTask.resume()
            
        }
    }
    
    private class func convertDataToDic(data:NSData) -> [String:AnyObject]? {
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
        } catch {
            print("JSON error: \(error)")
            return nil
        }
    }
    
    private class func urlWithSearchText(searchText:String, zip:String) -> NSURL {
        
        
        let zipcode = zip.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let escapedSearchText = searchText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        let urlString = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20local.search%20where%20zip%3D%27\(zipcode)%27%20and%20query%3D%27\(escapedSearchText)%27&format=json&diagnostics=true&callback="
        
        
        print("1010101010",urlString)
        let url = NSURL(string: urlString )!
        
        print("URL: \(url)")
        
        return url
        
        
    }
    
    private class func convertDicToResultArray(dictionary: [String:AnyObject]) -> [SearchResultModel] {
        guard let queryDic = dictionary["query"] as? NSDictionary else {
            print("Expected 'results' array")
            return []
        }
        guard let resultsDic = queryDic["results"] as? NSDictionary else{
            return []
        }
        guard let array = resultsDic["Result"] as? [AnyObject] else{
            return []
        }
        
        var searchResults = [SearchResultModel]()
        for result in array {
            if let resultDict = result as? NSDictionary {
                var searchResult: SearchResultModel?
                
                if let xmlns = resultDict["xmlns"] as? String {
                    if xmlns == "urn:yahoo:lcl"{
                        searchResult = parseResult(resultDict)
                    }
                }
                if searchResult != nil {
                    searchResults.append(searchResult!)
                }
                
                
            }
        }
        
        return searchResults
    }
    private class func parseResult(dictionary: NSDictionary) -> SearchResultModel {
        let searchResult = SearchResultModel()
        if let title = dictionary["Title"]as? String{
            searchResult.title=title
        }
        if let address = dictionary["Address"]as? String{
            searchResult.address=address
        }
        if let city = dictionary["City"]as? String{
            searchResult.city=city
        }
        if let state = dictionary["State"]as? String{
            searchResult.state=state
        }
        if let phone = dictionary["Phone"]as? String{
            searchResult.phone=phone
        }
        if let latitude = Double((dictionary["Latitude"] as? String)!){
            searchResult.latitude=latitude
        }
        if let longtitude = Double((dictionary["Longitude"] as? String)!){
            searchResult.longtitude=longtitude
        }

        
//        searchResult.title = dictionary["Title"] as! String
//        searchResult.address = dictionary["Address"] as! String
//        searchResult.city = dictionary["City"] as! String
//        searchResult.state = dictionary["State"] as! String
//        searchResult.phone = dictionary["Phone"] as! String
//        searchResult.latitude = Double(dictionary["Latitude"] as! String)!
//        searchResult.longtitude = Double(dictionary["Longitude"] as! String)!
        
        /*if let lat = dictionary["Latitude"] as? Double {
         searchResult.latitude = lat
        }
        if let log = dictionary["Longitude"] as? Double{
           searchResult.longtitude = log
        }
        */
        
        return searchResult
    }
}
