//
//  AudioManager.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 16.02.2023.
//

import Foundation
import MediaPlayer
import MusicKit
import SwiftUI

extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView(frame: CGRect.zero)
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        //Hiding system volumeView side bar.
        volumeView.sendSubviewToBack(slider!)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            slider?.value = volume
        }
    }
}

final class AudioManager: ObservableObject {
    
    static let shared = AudioManager()
    private let viewModel = MediaContentManager.shared
       
    @State var systemMusicPlayer = MPMusicPlayerController.systemMusicPlayer
    private var shuffleMode = MPMusicPlayerController.systemMusicPlayer.shuffleMode
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func getQueue(onCompletion: @escaping (MPMusicPlayerPlayParametersQueueDescriptor?) -> Void) {
        
        do {
        
            guard let parameters = viewModel.currentPlaylist?.playParameters else { return }
            let data = try JSONEncoder().encode(parameters)
            let playParameters = try JSONDecoder().decode(MPMusicPlayerPlayParameters.self, from: data)
            let queue = MPMusicPlayerPlayParametersQueueDescriptor(playParametersQueue: [playParameters])
        
            onCompletion(queue)
            
        } catch {
            onCompletion(nil)
        }
    }
    
    private func stop() {
        
        shuffleMode = systemMusicPlayer.shuffleMode
        systemMusicPlayer.shuffleMode = MPMusicShuffleMode.off

        viewModel.isPlaying = false
        systemMusicPlayer.stop()
        systemMusicPlayer.nowPlayingItem = nil
        
    }

    func play() {
                
        systemMusicPlayer.shuffleMode = shuffleMode
        systemMusicPlayer.prepareToPlay { [self] _ in
            
            do {
                
                guard let parameters = viewModel.currentPlaylist?.playParameters else { return }
                let data = try JSONEncoder().encode(parameters)
                let playParameters = try JSONDecoder().decode(MPMusicPlayerPlayParameters.self, from: data)
                let trackQueue = MPMusicPlayerPlayParametersQueueDescriptor(playParametersQueue: [playParameters])
                
                systemMusicPlayer.setQueue(with: trackQueue)
                viewModel.isPlaying = true
                systemMusicPlayer.play()

            } catch {
                print("")
            }
                        
        }
        
    }

    func play(startingAt index: Int) {
        stop()

        if systemMusicPlayer.indexOfNowPlayingItem != index {
            getQueue() { [self] queue in
                if let currentPlayingIndex = viewModel.filteredSongs.firstIndex(where: { $0.track == viewModel.currentPlayingItem }) {
                    let queueStartingIndex = max(currentPlayingIndex - index, 0)
                    let queue = Array(viewModel.filteredSongs.suffix(from: queueStartingIndex))
                    viewModel.currentQueueArray = queue.map({$0.track})
                } else {
                    viewModel.currentQueueArray = viewModel.filteredSongs.map({$0.track})
                }

                do {
                    guard let parameters = viewModel.currentQueueArray[index].playParameters else { return }
                    let data = try JSONEncoder().encode(parameters)
                    let playParameters = try JSONDecoder().decode(MPMusicPlayerPlayParameters.self, from: data)
                    let trackQueue = MPMusicPlayerPlayParametersQueueDescriptor(playParametersQueue: [playParameters])

                    systemMusicPlayer.setQueue(with: trackQueue)
                    viewModel.isPlaying = true
                    systemMusicPlayer.play()

                } catch {
                    print("")
                }
            }
        }
    }
    
    func playShuffled() {
        
        systemMusicPlayer.shuffleMode = .songs
        systemMusicPlayer.prepareToPlay { [self] _ in
            
            do {
                
                getQueue() { [self] queue in
                    systemMusicPlayer.setQueue(with: queue!)
                    viewModel.isPlaying = true
                    systemMusicPlayer.play()
                }
                
            } 
                        
        }
        
    }
    
}
