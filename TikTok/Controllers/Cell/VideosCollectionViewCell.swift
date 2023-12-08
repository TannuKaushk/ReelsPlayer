//
//  VideosCollectionViewCell.swift
//  TikTok
//
//  Created by TORVIS on 04/09/23.
//


import UIKit
import GSPlayer

class VideosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var playerView: VideoPlayerView!
    
    @IBOutlet weak var playImg: UIImageView!
    private var url: URL?
    
    var videos: String?
    override func awakeFromNib() {
        super.awakeFromNib()
        viewsetup()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        playerView.isHidden = true
    }
    
    func play() {
        playerView.play(for: url!)
            self.playImg.isHidden = true
            self.playerView.isHidden = false
   
    }
    
    func set(url: URL) {
        self.url = url
    }
    
    func pause() {
        playerView.pause(reason: .hidden)
    }
    
    func viewsetup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.playerView.isUserInteractionEnabled = true
        self.playerView.addGestureRecognizer(tap)
        
    }
    
    @objc func viewTapped() {
        if playerView.state == .playing {
            playImg.isHidden = false
            playerView.pause(reason: .userInteraction)
        } else {
            playImg.isHidden = true
            playerView.resume()
        }
    }
}
