//
//  ViewController.swift
//  mapnotest
//
//  Created by JotaroSugiyama on 2020/04/19.
//  Copyright © 2020 JotaroSugiyama. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, UITabBarDelegate, CLLocationManagerDelegate, GMSMapViewDelegate{
    
    var mapView: GMSMapView!
    var camera: GMSCameraPosition!
    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocation?
    private var zoomLevel: Float = 17.8
    
    @IBOutlet var tabBar : UITabBar!

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBar.delegate = self
        
        // GoogleMapの初期化
        self.mapView.isMyLocationEnabled = true
        self.mapView.mapType = GMSMapViewType.normal
        self.mapView.settings.compassButton = true
        self.mapView.settings.myLocationButton = true
        self.mapView.delegate = self

        // 位置情報関連の初期化
        self.locationManager = CLLocationManager()
        self.locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager!.requestAlwaysAuthorization()
        self.locationManager!.distanceFilter = 50
        self.locationManager!.startUpdatingLocation()
        self.locationManager!.delegate = self
        
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = false
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem){
        switch item.tag {
        case 1:
            print("1")
        case 2:
            print("2")
        default:
            return
        }
    }

    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: self.zoomLevel, bearing: 0, viewingAngle: 45)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.settings.scrollGestures = false
        mapView.settings.zoomGestures = true
        mapView.settings.tiltGestures = false
        mapView.settings.rotateGestures = true
        mapView.setMinZoom(15, maxZoom: 19)
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        self.view = mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        camera = GMSCameraPosition.camera(withTarget: (locations.last?.coordinate)!, zoom: self.zoomLevel, bearing: 0, viewingAngle: 45)
        self.mapView.camera = camera
        
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude

        print("latitude: \(latitude!)\nlongitude: \(longitude!)")
    }
    
//    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
//
//        guard let lat = mapView.myLocation?.coordinate.latitude,
//            let lng = mapView.myLocation?.coordinate.longitude else { return false }
//
//        let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: lng , zoom: self.zoomLevel, bearing: 0, viewingAngle: 45)
//        mapView.animate(to: camera)
//        return true
//    }
}
