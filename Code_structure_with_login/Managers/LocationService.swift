//
//  Utility.swift
//  Code_structure_with_login
//
//  Created by vishal lakum on 13/11/20.
//  Copyright © 2020 vishal lakum. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol LocationServiceDelegate : class{
    func tracingLocation(_ currentLocation: CLLocation)
    func tracingLocationDidFailWithError(_ error: NSError)
}

class LocationService: NSObject, CLLocationManagerDelegate {

    static let shared: LocationService = {
        let instance = LocationService()
        return instance
    }()
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?

    weak var delegate: LocationServiceDelegate?
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            // you have 2 choice
            // 1. requestAlwaysAuthorization
            // 2. requestWhenInUseAuthorization
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation //kCLLocationAccuracyBest
        locationManager.distanceFilter = 2 // kCLDistanceFilterNone
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.activityType = .fitness//automotiveNavigation
        locationManager.delegate = self
    }
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        
        currentLocation = location
        
//        AppUtility.setLatitude(String(location.coordinate.latitude))
//        AppUtility.setLogitude(String(location.coordinate.longitude))
        
        updateLocation(location)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        // do on error
        updateLocationDidFailWithError(error as NSError)
    }
    
    // Private function
    fileprivate func updateLocation(_ currentLocation: CLLocation){
        
        guard let delegate = self.delegate else {
            return
        }
        //print("Base Class Location: ",currentLocation)

        delegate.tracingLocation(currentLocation)
    }
    
    fileprivate func updateLocationDidFailWithError(_ error: NSError) {
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocationDidFailWithError(error)
    }
    
    func checkLocationAskForPermission() -> Bool {
        
        if CLLocationManager.locationServicesEnabled(){
            let status = CLLocationManager.authorizationStatus()
            
            if status == CLAuthorizationStatus.notDetermined
            {
                locationManager?.requestAlwaysAuthorization()
                return false
            }
            else if status == CLAuthorizationStatus.denied
            {
                self.showLocationPopup()
                return false
            }else{
                return true
            }
        }else{
            return false
        }
    }

    func showLocationPopup(){
        let alertController = UIAlertController (title: "Location Service Disabled", message:  "To re-enable, please go to Settings and turn on Location Permission for this app.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        
                    })
                } else {
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title:  "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        let topWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow.rootViewController = UIViewController()
        topWindow.windowLevel = UIWindow.Level.alert + 1
        topWindow.makeKeyAndVisible()
        topWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}

