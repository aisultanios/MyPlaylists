//
//  MiniPlayer.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 6.02.2023.
//

import SwiftUI
import MediaPlayer

struct MiniPlayer: View {
    
    @ObservedObject private var viewModel = MediaContentManager.shared
    @StateObject private var audioManager = AudioManager.shared
    @State private var imageLoader = ImageLoader.shared

    var animation: Namespace.ID
    @Binding var expand: Bool
    @State private var offset: CGFloat = 0.0

    var width = UIScreen.main.bounds.width
    var height = UIScreen.main.bounds.height
    
    @State var bouncePlayBtn: Bool = false
    @State var bounceForwardBtn: Bool = false
    @State var bounceBackwardBtn: Bool = false
    
    //Volume Bar Properties
    @State var isChangingVolume: Bool = false
    @State private var volume: Double = 0.3
    var maxVolume: Double = 1
        
    //Duration Progress Bar Properties
    @State private var playerDuration: TimeInterval = 0
    @State private var maxDuration: TimeInterval = 100
    
    //Colors for Progress Bar(Volume+Duration)
    @State private var color: Color = .white
    var normalFillColor: Color { color.opacity(0.5) }
    var emptyColor: Color { color.opacity(0.3) }
    
    @State private var trackImage: UIImage? = UIImage(named: "playlist_artwork_placeholder")
    
    var body: some View {
        
        VStack(alignment: .center, spacing: expand ? height / 35: 0) {
            
            if expand {
                
                Capsule()
                    .fill(.white.opacity(0.425))
                    .frame(width: expand ? 35: 0, height: expand ? 5: 0)
                    .opacity(expand ? 5: 0)
                    .padding(.top, expand ? 4: 0)
                
            }
            
            HStack(alignment: .center, spacing: 15) {
                
                if expand {
                    Spacer(minLength: 0)
                }
                
                if !expand {
                    //Track Image and Title
                    Image(uiImage: viewModel.currentPlayingItemsArtwork!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame (width: 50, height: 50)
                        .cornerRadius (6.5)
                        .matchedGeometryEffect(id: "Image", in: animation)
                    
                    Text(viewModel.currentPlayingItemsTitle ?? "No Item")
                        .font (.system(size: 17.0, weight: .regular, design: .default))
                        .fontWeight (.regular)
                        .multilineTextAlignment(.leading)
                        .matchedGeometryEffect(id: "LabelMusicTitle", in: animation)
                        .frame(alignment: .leading)
                        .lineLimit(1)
                }
                
                Spacer(minLength: 0)
                
                if !expand {
                    //Control Btns
                    HStack(spacing: 7.5) {
                        //BACKWARD BTN if the track is not first in the query
                        if !viewModel.isCurrenPlayingItemFirstInQuery {
                            
                            Circle()
                                .fill(.black)
                                .opacity(bounceBackwardBtn ? 0.15: 0.0)
                                .frame(width: 45, height: 45, alignment: .center)
                                .background {
                                    Button(action: {
                                        audioManager.systemMusicPlayer.skipToPreviousItem()
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            bounceBackwardBtn.toggle()
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                            withAnimation(.easeOut(duration: 0.2)) {
                                                bounceBackwardBtn.toggle()
                                            }
                                            
                                        })
                                        
                                    }, label: {
                                        Image(systemName: "backward.fill")
                                            .font (bounceBackwardBtn ? .headline: .title2)
                                            .foregroundColor (.black)
                                            .frame(width: 45, height: 45)
                                    })
                                }
                            
                        }
                        
                        //PLAY/PAUSE BTN
                        Circle()
                            .fill(.black)
                            .opacity(bouncePlayBtn ? 0.15: 0.0)
                            .frame(width: 45, height: 45, alignment: .center)
                            .background {
                                Button(action: {
                                    if viewModel.isPlaying == true {
                                        audioManager.systemMusicPlayer.pause()
                                    } else {
                                        audioManager.systemMusicPlayer.play()
                                    }
                                    
                                    DispatchQueue.main.async {
                                        
                                        viewModel.isPlaying.toggle()
                                        
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            bouncePlayBtn.toggle()
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                            withAnimation(.easeOut(duration: 0.2)) {
                                                bouncePlayBtn.toggle()
                                            }
                                            
                                        })
                                        
                                    }
                                    
                                }, label: {
                                    Image(systemName: viewModel.isPlaying ? "pause.fill": "play.fill")
                                        .font (bouncePlayBtn ? .headline: .title2)
                                        .foregroundColor (.black)
                                        .frame(width: 45, height: 45)
                                })
                            }
                        
                        
                        //FORWARD BTN
                        Circle()
                            .fill(.black)
                            .opacity(bounceForwardBtn ? 0.15: 0.0)
                            .frame(width: 45, height: 45, alignment: .center)
                            .background {
                                Button(action: {
                                    audioManager.systemMusicPlayer.skipToNextItem()
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        bounceForwardBtn.toggle()
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                        withAnimation(.easeOut(duration: 0.2)) {
                                            bounceForwardBtn.toggle()
                                        }
                                        
                                    })
                                    
                                }, label: {
                                    Image(systemName: "forward.fill")
                                        .font (bounceForwardBtn ? .headline: .title2)
                                        .foregroundColor (.black)
                                        .frame(width: 45, height: 45)
                                })
                            }
                    }//: HSTACK
                }
                
            }//: HSTACK
            .padding(.horizontal, 20)
                            
            if expand {
                
                VStack(spacing: height / 18.5) {
                    
                    Rectangle()
                        .fill(.clear)
                        .frame(width: width / 1.14, height: width / 1.14)
                        .background {
                            Image(uiImage: viewModel.currentPlayingItemsArtwork!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame (width: viewModel.isPlaying ? width / 1.14: width / 1.55, height: viewModel.isPlaying ? width / 1.14: width / 1.55)
                                .cornerRadius(10)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(color: .gray, radius: 0.35)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.clear)
                                        .frame(width: width / 1.75, height: width / 1.75, alignment: .center)
                                        .ignoresSafeArea(.container, edges: .bottom)
                                        .shadow(color: .black.opacity(0.25), radius: 15, x: 0, y: 15)
                                }
                                .matchedGeometryEffect(id: "Image", in: animation)

                        }//: TRACK IMAGE
                                            
                    VStack(spacing: height / 20) {
                        
                        //Title, Ellipsis, Progress Bar, Play/Pause
                        VStack(spacing: height / 30) {
                            
                            //Title, Ellipsis, Progress Bar, Timing
                            VStack(spacing: height / 30) {
                                
                                //Title and ellipsis
                                HStack {
                                    
                                    VStack(alignment: .leading, spacing: 0.25) {
                                        Text(viewModel.currentPlayingItemsTitle ?? "No Item")
                                            .font(.system(size: 21.0, weight: .medium, design: .default))
                                            .foregroundColor(.white)
                                            .fontWeight(.medium)
                                            .multilineTextAlignment(.leading)
                                            .matchedGeometryEffect(id: "LabelMusicTitle", in: animation)
                                        
                                        if viewModel.currentPlayingItemsArtist != "" {
                                            Text(viewModel.currentPlayingItemsArtist ?? "")
                                                .font(.system(size: 19.0, weight: .regular, design: .default))
                                                .foregroundColor(.white.opacity(0.5))
                                                .fontWeight(.regular)
                                                .multilineTextAlignment(.leading)
                                        }
                                    }
                                    .padding(.leading, 35)
                                    
                                    Spacer(minLength: 0)
                                    
                                    MiniPlayerMorePopup(showMiniPlayerMenuPickerSelection: $viewModel.showMiniPlayerMenuPickerSelection, showMiniPlayerMenuPicker: $viewModel.showMiniPlayerMenuPicker, sections: $viewModel.miniPlayerPopupSections)
                                        .padding(.trailing, 35)
                                    
                                }//: HSTACK
                                
                                //Progress Bar and Timing
                                VStack(spacing: 0) {
                                    
                                    MusicProgressSlider(value: $playerDuration, inRange: TimeInterval.zero...maxDuration, activeFillColor: color, fillColor: normalFillColor, emptyColor: emptyColor, height: height / 27.5) { started in
                                        print(started)
                                        
                                        if started == false {
                                            audioManager.systemMusicPlayer.currentPlaybackTime = playerDuration
                                        }
                                        
                                    }
                                    .frame(height: height / 27.5)
                                    .padding([.leading, .trailing], 35)
                                    .onAppear {
                                        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
                                            playerDuration = audioManager.systemMusicPlayer.currentPlaybackTime
                                        }
                                    }
                                    
                                }// VSTACK
                                .background(.white.opacity(0.00001))
                                
                            }//: VSTACK
                            
                            //Play Pause Skip Btns
                            HStack(spacing: width / 12) {
                                
                                if !viewModel.isCurrenPlayingItemFirstInQuery {
                                    //BACKWARD BTN
                                    Circle()
                                        .fill(.white)
                                        .opacity(bounceBackwardBtn ? 0.15: 0.0)
                                        .frame(width: 75, height: 75, alignment: .center)
                                        .background {
                                            Button(action: {
                                                audioManager.systemMusicPlayer.skipToPreviousItem()
                                                withAnimation(.easeInOut(duration: 0.2)) {
                                                    bounceBackwardBtn.toggle()
                                                }
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                                    withAnimation(.easeOut(duration: 0.2)) {
                                                        bounceBackwardBtn.toggle()
                                                    }
                                                    
                                                })
                                            }, label: {
                                                Image(systemName: "backward.fill")
                                                    .font (.system(size: bounceBackwardBtn ? 22.5: 30, weight: .regular, design: .default))
                                                    .foregroundColor (.white)
                                            })
                                        }
                                } else {
                                    //Empty Circle shape if the track is first in query
                                    Circle()
                                        .fill(.clear)
                                        .frame(width: 75, height: 75, alignment: .center)
                                }
                                
                                //PLAY/PAUSE BTN
                                Circle()
                                    .fill(.white)
                                    .opacity(bouncePlayBtn ? 0.15: 0.0)
                                    .frame(width: 75, height: 75, alignment: .center)
                                    .background {
                                        Button(action: {
                                            if viewModel.isPlaying == true {
                                                audioManager.systemMusicPlayer.pause()
                                            } else {
                                                audioManager.systemMusicPlayer.play()
                                            }
                                            
                                            DispatchQueue.main.async {
                                                
                                                if viewModel.isPlaying == false {
                                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.6)) {
                                                        viewModel.isPlaying.toggle()
                                                    }
                                                } else if viewModel.isPlaying == true {
                                                    withAnimation(.easeOut(duration: 0.4)) {
                                                        viewModel.isPlaying.toggle()
                                                    }
                                                }
                                                
                                                withAnimation(.easeInOut(duration: 0.2)) {
                                                    bouncePlayBtn.toggle()
                                                }
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                                    withAnimation(.easeOut(duration: 0.2)) {
                                                        bouncePlayBtn.toggle()
                                                    }
                                                    
                                                })
                                                
                                            }
                                            
                                        }, label: {
                                            Image(systemName: viewModel.isPlaying ? "pause.fill": "play.fill")
                                                .font (.system(size: bouncePlayBtn ? 35.0: 42.5, weight: .heavy, design: .default))
                                                .foregroundColor (.white)
                                            
                                        })
                                    }
                                
                                
                                //FORWARD BTN
                                Circle()
                                    .fill(.white)
                                    .opacity(bounceForwardBtn ? 0.15: 0.0)
                                    .frame(width: 75, height: 75, alignment: .center)
                                    .background {
                                        Button(action: {
                                            audioManager.systemMusicPlayer.skipToNextItem()
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                bounceForwardBtn.toggle()
                                            }
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                                withAnimation(.easeOut(duration: 0.2)) {
                                                    bounceForwardBtn.toggle()
                                                }
                                                
                                            })
                                            
                                        }, label: {
                                            Image(systemName: "forward.fill")
                                                .font (.system(size: bounceForwardBtn ? 22.5: 30, weight: .regular, design: .default))
                                                .foregroundColor (.white)
                                            
                                        })
                                    }
                                
                            }//: HSTACK
                            
                        }//: VSTACK
                        
                        //Volume
                        VStack(spacing: height / 22.5) {
                            
                            //Volume Slider and icons
                            VolumeSlider(value: $volume, inRange: 0...maxVolume, activeFillColor: color, fillColor: normalFillColor, emptyColor: emptyColor, height: 7.5) { _ in
                                MPVolumeView.setVolume(Float(volume))
                            }
                            .frame(height: 7.5)
                            .padding([.leading, .trailing], 35)
                            .zIndex(1.0)
                            
                            //Lower Part Buttons
                            HStack(spacing: width / 5.4) {
                                Button {
                                    print("")
                                } label: {
                                    Image(systemName: "quote.bubble")
                                        .foregroundColor(.white.opacity(0.7))
                                        .font(.system(size: 19, weight: .semibold, design: .default))
                                }
                                
                                Button {
                                    print("")
                                } label: {
                                    Image(systemName: "shareplay")
                                        .foregroundColor(.white.opacity(0.7))
                                        .font(.system(size: 19, weight: .semibold, design: .default))
                                }
                                
                                Button {
                                    print("")
                                } label: {
                                    Image(systemName: "list.bullet")
                                        .foregroundColor(.white.opacity(0.7))
                                        .font(.system(size: 19, weight: .semibold, design: .default))
                                }
                            }//: HSTACK
                            
                        }//: VSTACK
                        .background(.white.opacity(0.000001))
                        
                    }//: VSTACK
                    
                }//: VSTACK
                .frame(height: expand ? nil : 0)
                .opacity(expand ? 1: 0)
                .padding(.top, -10)
                
            } //: ELEMENTS WHEN MINI PLAYER IS EXPANDED
            
        }//: VTSACK
        .frame (maxWidth: width, maxHeight: expand ? .infinity: 65)
        // moving the miniplayer above the tabbar..
        // approz tab bar height is 49
        .background (
            
            VStack(spacing: 0, content: {
                
                ZStack {
                    
                    if expand {
                        
                        LinearGradient(colors: viewModel.selectedSongsBgColors?.reversed() ?? [.gray.opacity(0.35), .gray.opacity(0.15), .gray.opacity(0.25)], startPoint: .top, endPoint: .bottom)
                            .ignoresSafeArea()
                            .overlay(
                                BlurViewDark(averageColor: UIImage(named: "Miley Cyrus")?.averageColor ?? .gray.withAlphaComponent(0.15))
                            )
                            .matchedGeometryEffect(id: "Blur", in: animation)
                        
                    } else if !expand {
                        BlurView()
                            .matchedGeometryEffect(id: "Blur", in: animation)
                    }
                    
                }//: ZSTACK
                
                Divider()
            })//: VSTACK
            .onTapGesture {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8, blendDuration: 0.65)) {
                    expand = true
                }
            } //Expand Mini Player
            
        )//: BACKGROUND ELEMENTS
        .cornerRadius(expand ? 20: 0)
        .offset (y: expand ? 0: -48)
        .offset(y: offset)
        .ignoresSafeArea()
        .onAppear {
            //Setting The Properties Of The Current Playing Item
            guard let currentTrack = viewModel.filteredSongs.first(where: {$0.track.title == audioManager.systemMusicPlayer.nowPlayingItem?.title})?.track else { return }
            imageLoader.setTheImage(url: currentTrack.artwork?.url(width: 256, height: 256)?.absoluteString ?? "", title: audioManager.systemMusicPlayer.nowPlayingItem?.title ?? "") { [self] image in
                viewModel.currentPlayingItemsArtwork = image
                viewModel.currentPlayingItemsTitle = audioManager.systemMusicPlayer.nowPlayingItem?.title ?? ""
                viewModel.currentPlayingItemsArtist = audioManager.systemMusicPlayer.nowPlayingItem?.artist ?? ""
                maxDuration = audioManager.systemMusicPlayer.nowPlayingItem?.playbackDuration ?? 0.0
                
                for color in image?.getPixelColor() ?? [.gray.withAlphaComponent(0.35), .gray.withAlphaComponent(0.15), .gray.withAlphaComponent(0.25)] {
                    viewModel.selectedSongsBgColors?.removeAll()
                    viewModel.selectedSongsBgColors?.append(Color(uiColor: color))
                }
                
            }
            
            //If the item is first in query the backwards button will be hidden
            if currentTrack.title == viewModel.currentQueueArray.first?.title {
                viewModel.isCurrenPlayingItemFirstInQuery = true
            } else {
                viewModel.isCurrenPlayingItemFirstInQuery = false
            }
            
        }//: ONAPPEAR
        .gesture(
            //Mini Player Shrink Gesture
            DragGesture().onEnded(onEnded(value:)).onChanged(onChanged(value:))
        )//: DRAG GESTURE
        .onChange(of: audioManager.systemMusicPlayer.nowPlayingItem) { newValue in
            //Setting The Properties Of The Current Playing Item
            guard let currentTrack = viewModel.filteredSongs.first(where: {$0.track.title == newValue?.title})?.track else { return }
            imageLoader.setTheImage(url: currentTrack.artwork?.url(width: 256, height: 256)?.absoluteString ?? "", title: newValue?.title ?? "") { [self] image in
                viewModel.currentPlayingItemsArtwork = image
                viewModel.currentPlayingItemsTitle = audioManager.systemMusicPlayer.nowPlayingItem?.title ?? ""
                viewModel.currentPlayingItemsArtist = audioManager.systemMusicPlayer.nowPlayingItem?.artist ?? ""
                maxDuration = audioManager.systemMusicPlayer.nowPlayingItem?.playbackDuration ?? 0.0
                
                for color in image?.getPixelColor() ?? [.gray.withAlphaComponent(0.35), .gray.withAlphaComponent(0.15), .gray.withAlphaComponent(0.25)] {
                    viewModel.selectedSongsBgColors?.removeAll()
                    viewModel.selectedSongsBgColors?.append(Color(uiColor: color))
                }
                
            }
            
            //If the item is first in query the backwards button will be hidden
            if newValue?.title == viewModel.currentQueueArray.first?.title {
                viewModel.isCurrenPlayingItemFirstInQuery = true
            } else {
                viewModel.isCurrenPlayingItemFirstInQuery = false
            }
            
        }//: ONCHANGE
        .overlay {
            if expand, viewModel.showContextMenuActionPopup == true {
                ContextMenuActionPopup(animateContextMenuActionPopup: $viewModel.showContextMenuActionPopup, popupTitle: $viewModel.contextMenuActionPopupsTitle, popupIcon: $viewModel.contextMenuActionPopupsIcon, size: CGSize(width: UIScreen.main.bounds.width / 1.66, height: UIScreen.main.bounds.width / 1.566))
                    
            }
        }//: OVERLAY ELEMENTS
        
    }
    
    func onChanged(value: DragGesture.Value) {
        
        //only when expanded
        if value.translation.height > 0 && expand {
            offset = value.translation.height
        }
        
    }//: WHEN STARTED DRAGGING
    
    func onEnded(value: DragGesture.Value) {
        
        withAnimation(.spring(response: 0.35, dampingFraction: 0.86, blendDuration: 0.6)) {
            
            if value.translation.height > height / 3.5 {
                expand = false
            }
            offset = 0
        }
        
    }//: WHEN FINISHED DRAGGING
    
}

