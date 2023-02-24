//
//  FeaturedArtistCell.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 25.01.2023.
//

import SwiftUI

struct FeaturedArtistCell: View {
    
    @State var artistImage: String
    @State var artistName: String
    @State var width: CGFloat
    @State var height: CGFloat
    @State var fontSize: CGFloat
    @State var textAlinmentCentered: Bool
    
    var body: some View {
        
        VStack(alignment: textAlinmentCentered ? .center: .leading, spacing: textAlinmentCentered ? 5.0: 15.0) {
            Image(artistImage)
                .featuredArtistImageModifier(width: width, height: height)
                .background(.clear)
                .padding(.top, textAlinmentCentered ? 1.5: 0.0)
                .frame(alignment: .top)
            
            Text(artistName)
                .background(.clear)
                .foregroundColor(.black)
                .font(.system(size: fontSize))
                .multilineTextAlignment(textAlinmentCentered ? .center: .leading)
                .lineLimit(1)
                .frame(alignment: textAlinmentCentered ? .top: .topLeading)
                .padding(.leading, textAlinmentCentered ? 0.0: 5.0)
        }//: VSTACK
        .background(.clear)
        .frame(alignment: .top)
        
    }
}

struct FeaturedArtistCell_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedArtistCell(artistImage: "", artistName: "Miley Cyrus", width: 100, height: 100, fontSize: 20.0, textAlinmentCentered: true)
    }
}
