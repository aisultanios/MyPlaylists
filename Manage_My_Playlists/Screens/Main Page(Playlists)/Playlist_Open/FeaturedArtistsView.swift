//
//  FeaturedArtistsView.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 31.01.2023.
//

import SwiftUI

struct FeaturedArtistsView: View {
    
    @Binding var artists: [featuredArtist]
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.flexible(minimum: geo.size.width / 2.3, maximum: (geo.size.width / 2.3) + 30)), GridItem(.flexible(minimum: geo.size.width / 2.3, maximum: (geo.size.width / 2.3) + 30))], alignment: .center, spacing: (geo.size.width / 21.5) * 1.6) {
                    
                    ForEach(artists) { artist in
                        
                        FeaturedArtistCell(artistImage: artist.artistImage, artistName: artist.artistName, width: geo.size.width / 2.3, height: geo.size.width / 2.3, fontSize: 16.0, textAlinmentCentered: true)
                            .frame(height: geo.size.width / 2.3 + 30)
                            .contextMenu {
                                
                                Button {
                                    //Action
                                } label: {
                                    HStack {
                                        Text("Share Artist...")
                                            .font(.system(size: 14.0, weight: .medium, design: .default))
                                            .foregroundColor(.black)
                                            .multilineTextAlignment(.leading)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "square.and.arrow.up")
                                            .foregroundColor(.black)
                                            .font(.system(size: 14.0, weight: .semibold, design: .default))
                                    }
                                }
                                
                                Button {
                                    //Action
                                } label: {
                                    HStack {
                                        Text("Create Station")
                                            .font(.system(size: 14.0, weight: .medium, design: .default))
                                            .foregroundColor(.black)
                                            .multilineTextAlignment(.leading)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "badge.plus.radiowaves.right")
                                            .foregroundColor(.black)
                                            .font(.system(size: 14.0, weight: .semibold, design: .default))
                                    }
                                }
                                
                            } preview: {
                                FeaturedArtistCell(artistImage: artist.artistImage, artistName: artist.artistName, width: (geo.size.width / 1.15) - 35, height: (geo.size.width / 1.15) - 35, fontSize: 20, textAlinmentCentered: false).frame(alignment: .top)
                                    .frame(width: geo.size.width / 1.15, height: geo.size.width / 1.045)
                            }//: CONTEXTMENU / PREVIEW
                        
                    }//: FOREACH FEATURED ARTISTS LIST
                }//: LAZYVGRID
                .padding(.horizontal, (geo.size.width / 21.5) / 2)
                .navigationTitle("Featured Artists")
            }//: SCROLLVIEW
        }//: GEOMETRYREADER
    }
}
