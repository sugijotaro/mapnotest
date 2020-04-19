//
//  ViewController.swift
//  mapnotest
//
//  Created by JotaroSugiyama on 2020/04/19.
//  Copyright © 2020 JotaroSugiyama. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var mapView: GMSMapView!
    var camera: GMSCameraPosition!
    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocation?
    private var zoomLevel: Float = 15.0
    /// 初期描画の判断に利用
//    private var initView: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }

    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 14.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        
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
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
////      if !self.initView {
//        // 初期描画時のマップ中心位置の移動
//        camera = GMSCameraPosition.camera(withTarget: (locations.last?.coordinate)!, zoom: self.zoomLevel)
//        self.mapView.camera = camera
//        self.locationManager?.stopUpdatingLocation()
////        self.initView = true
////      }
//        print("aaa")
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        camera = GMSCameraPosition.camera(withTarget: (locations.last?.coordinate)!, zoom: self.zoomLevel)
        self.mapView.camera = camera
        
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude

        print("latitude: \(latitude!)\nlongitude: \(longitude!)")
    }

}

