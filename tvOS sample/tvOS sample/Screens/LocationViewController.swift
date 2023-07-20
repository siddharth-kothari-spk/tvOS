//
//  LocationViewController.swift
//  tvOS sample
//
//  Created by Siddharth Kothari on 20/07/23.
//

import UIKit
import AVFoundation

class LocationViewController: UIViewController {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dayButton: UIButton!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initVideoBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        avPlayer.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        avPlayer.pause()
    }
    
    func initVideoBackground() {
        avPlayer = AVPlayer(playerItem: preparePlayerItem(withIcon: Icon.sun))
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = .resizeAspectFill
        avPlayerLayer.frame = view.layer.bounds
        
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = .none
        
        view.backgroundColor = .clear
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: AVPlayerItem.didPlayToEndTimeNotification, object: avPlayer.currentItem)
    }

    func preparePlayerItem(withIcon icon:Icon) -> AVPlayerItem {
        return AVPlayerItem(url: Bundle.main.url(forResource: icon.rawValue, withExtension: "mp4")!)
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        guard let playerItem = notification.object as? AVPlayerItem else { return }
        playerItem.seek(to: .zero, completionHandler: nil)
    }
    
    @IBAction func dayButtonPressed(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
