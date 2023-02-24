//
//  FeaturedArtists.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 25.01.2023.
//

import Foundation

struct featuredArtist: Identifiable, Hashable {
    let id = UUID()
    let artistName: String
    let artistImage: String
}
