//
//  TrackCell.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 10.01.2023.
//

import SwiftUI

struct TrackCell: View {
        
    @State var coverImageData: UIImage?
    @State var numberInOrder: String
    @State var title: String
    @State var artistName: String
    @State var albumTitle: String
    @State var releaseDate: String
    @State var width: CGFloat
    @State var height: CGFloat
    @State var isContextMenu: Bool = false
    @Binding var showTrackPickerSelection: String
    @Binding var showTrackPicker: Bool
    @Binding var sections: [popUpElementSection]
    @State var isCurrentPlayingItem: Bool
    @State var screenWidth: CGFloat
    
    @StateObject private var audioManager = AudioManager.shared
    @StateObject private var viewModel = MediaContentManager.shared
    
    var body: some View {
        
        VStack {
            HStack(alignment: .center) {
                
                HStack(alignment: .center) {
                    
                    if isContextMenu == true {
                        
                        //Track Icon
                        Image(uiImage: coverImageData ?? UIImage(named: "playlist_artwork_placeholder")!)
                            .trackCoverImageModifier()
                            .frame(width: width, height: height)
                            .padding(.all, 20)
                        
                        
                    } else if isContextMenu == false {
                        
                        //Track Icon
                        ZStack(alignment: .center) {
                            
                            Image(uiImage: coverImageData ?? UIImage(named: "playlist_artwork_placeholder")!)
                                .trackCoverImageModifier()
                                .frame(width: width, height: height)
                            
                            if isCurrentPlayingItem {
                                
                                RoundedRectangle(cornerRadius: 6.5)
                                    .fill(.black.opacity(0.25))
                                    .frame(width: width, height: height)
                                
                                NowPlayingEqualizerBars(isPlaying: $viewModel.isPlaying)
                                    .frame(width: width / 2.75, height: height / 3.0, alignment: .center)
                                    .shadow(radius: 1)
                                    .padding(.bottom, 2.5)
                            }
                            
                        }//: ZSTACK
                        
                        Text(numberInOrder)
                            .font(.system(size: 19.0, weight: .bold, design: .default))
                            .lineLimit(1)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding([.leading, .trailing], 4.5)
                        
                    }
                    
                    VStack(alignment: .leading, spacing: isContextMenu ? 3.0 : 2.0) {
                        
                        Text(title)
                            .font(isContextMenu ? .system(size: 21.0): .subheadline)
                            .lineLimit(1)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                        Text(artistName)
                            .font(isContextMenu ? .system(size: 16.5): .footnote)
                            .lineLimit(1)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                        
                        if isContextMenu == true {
                            Text("\(albumTitle) • \(releaseDate)")
                                .font(.system(size: 16.5))
                                .lineLimit(2)
                                .foregroundColor(.gray.opacity(0.4))
                                .multilineTextAlignment(.leading)
                        }
                        
                    }//:VSTACK
                    .padding(.trailing, isContextMenu ? 15: 65)
                    
                    Spacer()
                    
                    if isContextMenu {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .frame(width: 30, height: 30, alignment: .center)
                            .padding()
                    }
                    
                }//: HSTACK
                .frame(minWidth: screenWidth / 1.625)
                
                Spacer(minLength: width / 16.25)
            }//: HSTACK
        }//: VSTACK

    }
    
}
