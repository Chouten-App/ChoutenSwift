//
//  Player.swift
//  Saikou Beta
//
//  Created by Inumaki on 20.02.23.
//
import SwiftUI
import AVKit
import UIKit

class PlayerView: UIView {
    
    // Override the property to make AVPlayerLayer the view's backing layer.
    override static var layerClass: AnyClass { AVPlayerLayer.self }
    
    // The associated player object.
    var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }
    
    var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
}
