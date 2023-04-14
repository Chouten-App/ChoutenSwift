//
//  PlayerViewModel.swift
//  Saikou Beta
//
//  Created by Inumaki on 20.02.23.
//

import Foundation
import AVKit
import SwiftWebVTT
import Combine

final class PlayerViewModel: ObservableObject {
    var player = AVPlayer()
    @Published var isInPipMode: Bool = false
    @Published var isPlaying = false
    
    @Published var isEditingCurrentTime = false
    @Published var currentTime: Double = .zero
    @Published var buffered: Double = .zero
    @Published var duration: Double?
    @Published var selectedSubtitleIndex: Int = 0
    @Published var webVTT: WebVTT?
    @Published var currentSubs: [WebVTT.Cue] = []
    @Published var isLoading: Bool = true
    @Published var hasError: Bool = false
    @Published var id: String = ""
    @Published var episodeNumber: Int = 1
    
    private var subscriptions: Set<AnyCancellable> = []
    private var errorsubscriptions: Set<AnyCancellable> = []
    private var timeObserver: Any?
    private var errorObserver: Any?
    
    deinit {
        if let timeObserver = timeObserver {
            player.removeTimeObserver(timeObserver)
        }
        timer.upstream.connect().cancel()
    }
    
    func setVolume(newVolume: Float) {
        player.volume = newVolume
    }
    
    func getVolume() -> Float {
        player.volume
    }
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    init() {
        timer.sink { time in
            // Calculate the percentage of video buffered
            let bufferedTimeRanges = self.player.currentItem?.loadedTimeRanges
            guard let firstRange = bufferedTimeRanges?.first?.timeRangeValue else { return }
            let bufferedDuration = firstRange.start + firstRange.duration
            let bufferedPercentage = Float(CMTimeGetSeconds(bufferedDuration) / (self.duration ?? 1.0))
            self.buffered = CMTimeGetSeconds(bufferedDuration)
        }
        .store(in: &subscriptions)
        
        $isEditingCurrentTime
            .dropFirst()
            .filter({ $0 == false })
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.player.seek(to: CMTime(seconds: self.currentTime, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)
                if self.player.rate != 0 {
                    self.player.play()
                }
            })
            .store(in: &subscriptions)
        
        player.publisher(for: \.timeControlStatus)
            .sink { [weak self] status in
                switch status {
                case .playing:
                    self?.isPlaying = true
                case .paused:
                    self?.isPlaying = false
                case .waitingToPlayAtSpecifiedRate:
                    break
                @unknown default:
                    break
                }
            }
            .store(in: &subscriptions)
        
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 600), queue: .main) { [weak self] time in
            guard let self = self else { return }
            
            
            if self.isEditingCurrentTime == false {
                self.currentTime = time.seconds
                
                
                self.getSubtitleText()
                
                if(self.player.status == AVPlayer.Status.readyToPlay) {
                    self.isLoading = false} else {self.isLoading = true}
                
                if(self.player.error != nil) {
                    self.hasError = true
                }
            }
        }
        
        player.publisher(for: \.status)
            .sink { [weak self] sts in
                switch sts {
                case .failed:
                    self?.hasError = true
                    print(self?.player.error)
                case .readyToPlay:
                    self?.hasError = false
                case .unknown:
                    self?.hasError = false
                @unknown default:
                    break
                }
            }
            .store(in: &errorsubscriptions)
    }
    
    func getSubtitleText() {
        var new = webVTT?.cues.filter {
            $0.timeStart <= currentTime && $0.timeEnd >= currentTime
        }
        
        currentSubs = new ?? []
    }
    
    func getCurrentItem() -> AVPlayerItem? {
        return player.currentItem
    }
    
    func setCurrentItem(_ item: AVPlayerItem) {
        currentTime = .zero
        duration = nil
        player.replaceCurrentItem(with: item)
        
        item.publisher(for: \.status)
            .filter({ $0 == .readyToPlay })
            .sink(receiveValue: { [weak self] _ in
                self?.duration = item.asset.duration.seconds
                
            })
            .store(in: &subscriptions)
    }
}
