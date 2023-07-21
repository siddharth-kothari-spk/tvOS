//
//  LocationViewController.swift
//  tvOS sample
//
//  Created by Siddharth Kothari on 20/07/23.
//

import UIKit
import AVFoundation
import CoreLocation

class LocationViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dayButton: UIButton!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    // MARK: - Video background properties
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    
    // MARK: - Location properties
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    // MARK: - Viewcontroller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initVideoBackground()
        setupLocationServices()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        avPlayer.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        avPlayer.pause()
    }
    
    // MARK: - video player methods
    func initVideoBackground() {
        avPlayer = AVPlayer(playerItem: preparePlayerItem(withIcon: Icon.sun))
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = .resizeAspectFill
        avPlayerLayer.frame = view.layer.bounds
        
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = .none
        
        view.backgroundColor = .clear
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
    }

    func preparePlayerItem(withIcon icon:Icon) -> AVPlayerItem {
        return AVPlayerItem(url: Bundle.main.url(forResource: icon.rawValue, withExtension: "mp4")!)
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        guard let playerItem = notification.object as? AVPlayerItem else { return }
        playerItem.seek(to: .zero, completionHandler: nil)
    }
    
    // MARK: - Location Services
    
    func setupLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
        }
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    // MARK: - UI Interactions
    @IBAction func dayButtonPressed(_ sender: Any) {
        
    }
}

// MARK: - Location Manager delegate
extension LocationViewController: CLLocationManagerDelegate {
    
    // MARK: - handle error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    //MARK: - handle authorization changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

    }
    
    // MARK: - handle location update
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        
        if let locationObject = locations.first {
            currentLocation = locationObject
            
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(locationObject) { placemarks, error in
                if error == nil {}
                guard let cityName = placemarks?.first?.locality else { return }
                
                DispatchQueue.main.async {
                    self.locationLabel.text = cityName
                }
            }
        }
    }
}
