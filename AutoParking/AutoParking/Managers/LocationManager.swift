//
//  LocationManager.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import Foundation
import AutoParkingNetwork
import CoreLocation
import Turf

protocol LocationManagerDelegate {
    
    func fetchParksCompletion(status: Bool)
}

extension LocationManagerDelegate {}

final class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    private var service: ServiceProtocol = App.service
    
    let delegates = MulticastDelegate<LocationManagerDelegate>()
    
    private var locationManager = CLLocationManager()
    var location: CLLocation?
    var locationError: Error?
    var minKey: String?
    var userLocationLat: Double?
    var userLocationLong: Double?
    
    var parks: [Park]? = []
    
    // MARK: - Inits
    
    private func fetchParksCompletion(status: Bool) {
        self.delegates.invoke(invocation: { $0.fetchParksCompletion(status: status) })
    }
    
    
    func fetchParks(completion: ((Bool) -> ())? = nil) {
        let token = SessionManager.shared.accessToken ?? ""
        guard let location = self.location else {
            print("Location is nil, cannot fetch parks")
            return
        }
//        print("Fetching parks for location: \(location)")
        self.service.park.getParkList(token: token, location: location) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let park):
                self.parks = park.data
                
                completion?(true)
                self.fetchParksCompletion(status: true)
                
            case .wrong(_):
                completion?(false)
                self.fetchParksCompletion(status: false)
                
            default:
                completion?(false)
                self.fetchParksCompletion(status: false)
            }
        }
    }
    
    override init() {
        
        locationManager = CLLocationManager()
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 1
        
    }
    
    func requestPermissions() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    func calculateClosestPoints(location: CLLocation, parks: [Park]) {
        let userLocation = location.coordinate
        var minDistance: Double = .greatestFiniteMagnitude
        var closestCoordinates: [String: Double] = [:]

        for park in parks {
            if let closestPoint = closestPoint(on: park.polylineCoords ?? [], to: userLocation) {
                closestCoordinates[park.code ?? ""] = closestPoint
                
                // make sure distance 10 metres to find minkey
                
//                if closestPoint < 10.0 {
                    if closestPoint < minDistance {
                        minDistance = closestPoint
                        minKey = park.id
                        
                    }
//                }
            }
        }

//        print("minKey")
//        print(minKey)
//        
//        print("\(self.userLocationLat) \(self.userLocationLong) user loct")
        
        self.userLocationLat = userLocation.latitude
        self.userLocationLong = userLocation.longitude

//        print("closes calculate func -> \(closestCoordinates)")
//        print(closestCoordinates.keys)
//        print(closestCoordinates.values)
//        print("closes calculate func -> \(closestCoordinates)")
//        print("userLocation")
//        print(userLocation)
    }
    
    private func closestPoint(on polyline: [Coordinates], to location: CLLocationCoordinate2D) -> Double? {
        guard polyline.count > 1 else { return nil }

        var smallestDistance: Double = .greatestFiniteMagnitude
        
        let point = Turf.Point(location)
        
        let line = Turf.LineString([.init(latitude: polyline.first?.latitude ?? 0.0, longitude: polyline.first?.longitude ?? 0.0),.init(latitude: polyline.last?.latitude ?? 0.0, longitude: polyline.last?.longitude ?? 0.0)])
        
        let linePoint = line.closestCoordinate(to: point.coordinates)
        
//        print("linePoint distance")
//        print(linePoint?.coordinate.distance(to: point.coordinates))

        return linePoint?.coordinate.distance(to: point.coordinates)
    }

    private func toRadians(_ degrees: Double) -> Double {
        return degrees * .pi / 180
    }

    private func haversineDistance(lat1: Double, lng1: Double, lat2: Double, lng2: Double) -> Double {
        let R = 6371e3 // Earth's radius in meters
        let φ1 = toRadians(lat1)
        let φ2 = toRadians(lat2)
        let Δφ = toRadians(lat2 - lat1)
        let Δλ = toRadians(lng2 - lng1)

        let a = sin(Δφ / 2) * sin(Δφ / 2) +
                cos(φ1) * cos(φ2) *
                sin(Δλ / 2) * sin(Δλ / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))

        return R * c // distance in meters
    }

    private func distancePointToSegment(point: CLLocationCoordinate2D, segmentStart: CLLocationCoordinate2D, segmentEnd: CLLocationCoordinate2D) -> Double {
        let px = point.latitude
        let py = point.longitude
        let ax = segmentStart.latitude
        let ay = segmentStart.longitude
        let bx = segmentEnd.latitude
        let by = segmentEnd.longitude
        
        let abx = bx - ax
        let aby = by - ay
        let apx = px - ax
        let apy = py - ay

        let ab_dot_ap = abx * apx + aby * apy
        let ab_length_sq = abx * abx + aby * aby

        var closestPoint = CLLocationCoordinate2D(latitude: ax, longitude: ay)

        if ab_length_sq != 0 {
            let t = ab_dot_ap / ab_length_sq
            if t > 1 {
                closestPoint = segmentEnd
            } else if t > 0 {
                closestPoint = CLLocationCoordinate2D(latitude: ax + abx * t, longitude: ay + aby * t)
            }
        }

        return haversineDistance(lat1: px, lng1: py, lat2: closestPoint.latitude, lng2: closestPoint.longitude)
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                
                self.userLocationLat = manager.location?.coordinate.latitude
                self.userLocationLong = manager.location?.coordinate.longitude
                locationManager.startUpdatingLocation()
            }
        }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .restricted, .denied:
            // Handle restricted or denied status
            break
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let bestLocation = locations.last, bestLocation.horizontalAccuracy > 0 else {
            print("Failed to get a valid location")
            return
        }
//        print("Received new location: \(bestLocation)")
        
//        print(bestLocation)
        location = bestLocation
//        fetchParks() { success in
//            print("Fetch parks completed with status: \(success)")
//        }
        calculateClosestPoints(location: bestLocation, parks: self.parks ?? [])
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = error
    }
}