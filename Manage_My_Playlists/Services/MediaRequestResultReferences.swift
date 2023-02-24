//
//  MediaRequestResultCases.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 13.10.2022.
//

import Foundation
import UIKit
import MusicKit

enum MediaRequestResultReferences: String {
    
    case authorized
    case denied
    case restricted
    case notDetermined
    
}

enum FetchResults {
    
    case SUCCESS
    case FAILED
    
}

enum GetPlaylistsResults {

    case SUCCESS
    case FAILED
    case USERHASNOSUBSCRIPTION
    case denied
    case restricted
    case notDetermined
}

//Media STRUCTS

struct trackIcon: Identifiable, Hashable {
    
    let id: String
    var image: UIImage
    let track: Track
    
    init(image: UIImage, track: Track) {
        self.id = UUID().uuidString
        self.image = image
        self.track = track
    }
    
}

struct appleMusicFetchUsersPlaylistsScheme {
    //get users playlists
    // "https://api.music.apple.com/v1/me/library/playlists"
    
    let requestScheme = "https"
    let requestHost = "api.music.apple.com"
    let requestPath = "/v1/me/library/playlists"
    
}

struct appleMusicFetchUsersPlaylistParametersScheme {
    //get playlist parameters
    // "https://api.music.apple.com/v1/me/library/playlists/\(playlist_id.id)")!
    
    let requestScheme = "https"
    let requestHost = "api.music.apple.com"
    let requestPath = "/v1/me/library/playlists"
    
}

struct appleMusicFetchMusicFromPlaylistScheme {
    //retrieve tracks for playlist
    // "https://api.music.apple.com/v1/catalog/tr/playlists/{playlist_id}"
    // playlistTracksRequestURLComponents.queryItems = [URLQueryItem(name: "include", value: "catalog")]

    let requestScheme = "https"
    let requestHost = "api.music.apple.com"
    let requestPath = "/v1/catalog/tr/playlists"
    let queryItems = [URLQueryItem(name: "include", value: "catalog")]
    
}
