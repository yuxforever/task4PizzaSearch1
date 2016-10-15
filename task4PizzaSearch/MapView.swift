//
//  MapView.swift
//  task4PizzaSearch
//
//  Created by Yu Ma on 3/30/16.
//  Copyright © 2016 Yu Ma. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit


class MapView: UIViewController{
    
    var annotation:MKAnnotation!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    
    @IBOutlet weak var map: MKMapView!
    var searchResult : ResultViewModel!{
    
    didSet {
    if isViewLoaded() {
      updateUI()
        }
      }
    }
    
    
    override func viewDidLoad() {
    super.viewDidLoad()
        print("kkkkkkkkssss" ,searchResult )
        
        let location = NSUserDefaults.standardUserDefaults()
        let latitude = (location.stringForKey("latitude")! as NSString).doubleValue
        let longtitude = (location.stringForKey("longtitude")! as NSString).doubleValue
        print("success lon1", latitude, longtitude)
        
        
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        let span = MKCoordinateSpanMake(1, 0.8)
        let region = MKCoordinateRegionMake(coordinate, span)
        self.map.setRegion(region, animated: true)

        
      if searchResult != nil {
            updateUI()
      }
   
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }


    func updateUI() {
        
        self.pointAnnotation = MKPointAnnotation()
        self.pointAnnotation.title = searchResult.title
        let lat = searchResult.latitude
        let log = searchResult.longtitude
        
        self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude:     log!)
        self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
        self.map.centerCoordinate = self.pointAnnotation.coordinate
        self.map.addAnnotation(self.pinAnnotationView.annotation!)

    
    }
    

}
