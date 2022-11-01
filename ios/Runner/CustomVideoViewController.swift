//
//  CustomVideoViewController.swift
//  Video Player Demo
//
//  Created by aljo on 23/11/21.
//

import UIKit
import VersaPlayer
import SDWebImage
//import QuickLookThumbnailing

class CustomVideoViewController: UIViewController {

    @IBOutlet weak var playerView: VersaPlayerView!
    @IBOutlet weak var controls: VersaPlayerControls!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerView.layer.backgroundColor = UIColor.black.cgColor
        playerView.use(controls: controls)

        
        
        
        let longVideoURL = "https://d37qxr5wqdn2c4.cloudfront.net/out/v1/e9fa194537924420b265917ee50aecb4/06cbed0a327249f2afe852009b5c2679/3f0fd354b0714b04898f921dc1f26280/index.m3u8"
        let longIMGURL = "https://d37qxr5wqdn2c4.cloudfront.net/b7b21768-273b-4890-8ecb-c181689217db/sprite.png"
       
     
        //---Short Video
        let shortVideoURL = "https://d37qxr5wqdn2c4.cloudfront.net/out/v1/22468131a4884b64bb4b5dffdb8647f1/06cbed0a327249f2afe852009b5c2679/3f0fd354b0714b04898f921dc1f26280/index.m3u8"
        
        let shortIMGURL = "https://d37qxr5wqdn2c4.cloudfront.net/a2ef798c-c6bd-407f-85eb-51285ca2c01d/sprite.png"
        
        
        //"https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8"
        if let url = URL.init(string: longVideoURL) {
            let item = VersaPlayerItem(url: url)
            playerView.set(item: item)
        }
        //----Long Video
       
       
       
        
        SDWebImageManager.shared.loadImage(
                with: URL(string: longIMGURL),
                options: .highPriority,
                progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                  print(isFinished)
            if image != nil {
                self.playerView.controls?.DxnImage = image
            }
        }
    }
    
    @IBAction func backBTN(_ sender: Any) {
        
        print("perform Back Action")
    }
    
}


public extension UIImageView {
   public func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
  public func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
