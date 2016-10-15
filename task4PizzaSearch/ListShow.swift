//
//  ListShow.swift
//  task4PizzaSearch
//
//  Created by Yu Ma on 3/29/16.
//  Copyright © 2016 Yu Ma. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
var semaphore = dispatch_semaphore_create(0)
let SegueIdentifier = "MapShow"
var zipNum = ""

class ListShow: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let locationManager = CLLocationManager()
    weak var DetailView: MapView?
    var result = [ResultViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        semaphore = dispatch_semaphore_create(0)
        print("begin update")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        //semaphore = dispatch_semaphore_create(0)
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let location = NSUserDefaults.standardUserDefaults()
        location.setValue(locValue.latitude, forKey: "latitude")
        location.setValue(locValue.longitude, forKey: "longtitude")
        location.synchronize()
        self.getZip()
        locationManager.stopUpdatingLocation()
    }
    
    func showNetworkError() {
        let alert = UIAlertController(title: NSLocalizedString("Sorry Networt Issue", comment: "Error Alert: title"), message: NSLocalizedString("There was an Error reading from the YAhoo . Please try again.", comment: "Error Alert: message") , preferredStyle: .Alert)
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: "Error Alert: action"), style: .Default, handler: nil)
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func getZip() {
        
        let geoCoder = CLGeocoder()
        let location = NSUserDefaults.standardUserDefaults()
        let latitudeData = (location.stringForKey("latitude")!as NSString).doubleValue
        let longtitudeData = (location.stringForKey("longtitude")!as NSString).doubleValue
        let locationPass = CLLocation(latitude: latitudeData, longitude: longtitudeData)
        
        
        geoCoder.reverseGeocodeLocation(locationPass, completionHandler: { (placemarks, error) -> Void in
            //print("place MArkssssss", placemarks)
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            if let zipCode = placeMark.addressDictionary!["ZIP"] as? NSString {
                zipNum = zipCode as String
                dispatch_semaphore_signal(semaphore)
               
            }
            
        })
    }

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MapShow" {
            
                let detailViewController = segue.destinationViewController as! MapView
                let indexPath = sender as! NSIndexPath
                let searchResult = self.result[indexPath.row]
                detailViewController.searchResult = searchResult
           
        }
    }


}

//MARK:UITableViewDelegate
extension ListShow: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
       // let row = indexPath.row
        print("true")

        performSegueWithIdentifier("MapShow", sender: indexPath)
                
        
    }
}
//MARK:UITableViewDataSource
extension ListShow: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.result.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
            let cell = tableView.dequeueReusableCellWithIdentifier("SearchResultCell", forIndexPath: indexPath) as! ListShowCell
            let searchResult = self.result[indexPath.row]
            cell.configureForSearchResult(searchResult)
            return cell
        
     }

}
//MARK: UISearchBarDelegate
extension ListShow:UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.getZip()
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        performSearch()
    }
    
    func performSearch() {
        if (searchBar.text != nil){
            
            APIClient.searchByYahoo(searchBar.text!, zipCode: zipNum, completion: { (isSuccess, resultArray) -> Void in
                
                if(isSuccess && resultArray.count > 0){
                  //  self.result = resultArray
                    self.result = ViewModelFactory.convertResultModelToViewModel(resultArray)
                    self.tableView.reloadData()
                    self.searchBar.resignFirstResponder()
                }else{
                    self.showNetworkError()
                }
                
            })
            
           searchBar.resignFirstResponder()
        }
        
    }
    
    
    //This is how to attach the search bar to the top of the screen so that there's no white gap
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    

    
}




