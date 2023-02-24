//
//  Apple Media Content Manager.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 13.10.2022.
//

import Foundation
import UIKit
import MediaPlayer
import MusicKit
import StoreKit
import SwiftUI

class MediaContentManager: ObservableObject {
    
    static let shared = MediaContentManager()
    private let appleMusicAPI = AppleMusicAPI.shared
    private let imageLoader = ImageLoader.shared
    
    //Retrieved Playlists
    var storeFrontId: String = ""
    @Published var playlists = [PlaylistWithMusicStructure?]()
    
    //Current Playlist Properties
    @Published var currentPlaylist: Playlist? = nil
    @Published var currentPlaylistsArtwork: UIImage = UIImage(named: "playlist_artwork_placeholder")!
    @Published var currentPlaylistsTitle: String = ""
    @Published var currentPlaylistsSubTitle: String = ""
    @Published var currentPlaylistsCaption: String = ""
    @Published var currentPlaylistsDescription: String = ""
    @Published var currentPlaylistsId: String = ""
    @Published var currentPlaylistsTotalSongs: String = ""
    @Published var currentPlaylistsTotalDuration: String = ""
    @Published var currentPlaylistsSongs = [trackIcon]()
    @Published var filteredSongs = [trackIcon]()
    private var preFilteredSongs = [trackIcon]()
    
    //Current Playing Items Properties
    @Published var currentPlayingItem: Track? = nil
    @Published var currentPlayingItemsTitle: String? = "No Item"
    @Published var currentPlayingItemsArtist: String? = ""
    @Published var currentPlayingItemsArtwork: UIImage? = UIImage(named: "playlist_artwork_placeholder")!
    @Published var currentQueueArray = [Track]()
    @Published var isCurrenPlayingItemFirstInQuery: Bool = true
    @Published var selectedSongsBgColors: [Color]? = []
    @Published var isPlaying: Bool = false

    //Playlist Menu Picker
    @Published var showPlaylistMenuPicker: Bool = false
    @Published var showPlaylistMenuPickerSelection = ""
    
    @Published var featuredArtists: [featuredArtist] = [featuredArtist(artistName: "21 Savage", artistImage: "21 Savage"), featuredArtist(artistName: "Akha", artistImage: "Akha"), featuredArtist(artistName: "Bakr", artistImage: "Bakr"), featuredArtist(artistName: "Eminem", artistImage: "Eminem"), featuredArtist(artistName: "Jah Khalib", artistImage: "Jah Khalib"), featuredArtist(artistName: "Metro Boomin", artistImage: "Metro Boomin"), featuredArtist(artistName: "Miguel", artistImage: "Miguel"), featuredArtist(artistName: "Miley Cyrus", artistImage: "Miley Cyrus"), featuredArtist(artistName: "RaiM", artistImage: "RaiM"), featuredArtist(artistName: "The Weeknd", artistImage: "The Weeknd"), featuredArtist(artistName: "Xcho", artistImage: "Xcho")]
    
    //Playlist Views Context Menu Properties
    @Published var playlistPopupSections: [popUpElementSection] = [popUpElementSection(elements: [popUpElement(title: "Edit", icon: "pencil"), popUpElement(title: "Sort By", icon: "arrow.up.arrow.down")]), popUpElementSection(elements: [popUpElement(title: "Delete from Library", icon: "trash"), popUpElement(title: "Download", icon: "arrow.down.circle"), popUpElement(title: "Add to a Playlist...", icon: "text.badge.plus")]), popUpElementSection(elements: [popUpElement(title: "Play Next", icon: "text.line.first.and.arrowtriangle.forward"), popUpElement(title: "Play Last", icon: "text.line.last.and.arrowtriangle.forward")]), popUpElementSection(elements: [popUpElement(title: "Share Playlist...", icon: "square.and.arrow.up"), popUpElement(title: "SharePlay", icon: "person.wave.2"), popUpElement(title: "Love", icon: "heart"), popUpElement(title: "Suggest Less Like This", icon: "hand.thumbsdown")])]
    
    //Track Cell Context Menu Properties
    @Published var showTrackPicker: Bool = false
    @Published var showTrackPickerSelection = ""
    
    @Published var trackPopupSections: [popUpElementSection] = [popUpElementSection(elements: [popUpElement(title: "Add to Library", icon: "plus"), popUpElement(title: "Add to a Playlist...", icon: "text.badge.plus")]), popUpElementSection(elements: [popUpElement(title: "Play Next", icon: "text.line.first.and.arrowtriangle.forward"), popUpElement(title: "Play Last", icon: "text.line.last.and.arrowtriangle.forward")]), popUpElementSection(elements: [popUpElement(title: "Share Song...", icon: "square.and.arrow.up"), popUpElement(title: "SharePlay", icon: "person.wave.2"), popUpElement(title: "View Full Lyrics", icon: "quote.bubble"), popUpElement(title: "Share Lyrics", icon: "arrow.up.message"), popUpElement(title: "Show Album", icon: "square"), popUpElement(title: "Create Station", icon: "badge.plus.radiowaves.forward")]), popUpElementSection(elements: [popUpElement(title: "Love", icon: "heart"), popUpElement(title: "Suggest Less Like This", icon: "hand.thumbsdown")])]
    
    @Published var showContextMenuActionPopup: Bool = false
    @Published var contextMenuActionPopupsTitle: String = ""
    @Published var contextMenuActionPopupsIcon: String = ""
    
    //Mini Player Context Menu Properties
    @Published var showMiniPlayerMenuPicker: Bool = false
    @Published var showMiniPlayerMenuPickerSelection = ""
    
    @Published var miniPlayerPopupSections: [popUpElementSection] = [popUpElementSection(elements: [popUpElement(title: "Add to Library", icon: "plus"), popUpElement(title: "Add to a Playlist...", icon: "text.badge.plus")]), popUpElementSection(elements: [popUpElement(title: "Share Song...", icon: "square.and.arrow.up"), popUpElement(title: "SharePlay", icon: "person.wave.2"), popUpElement(title: "View Full Lyrics", icon: "quote.bubble"), popUpElement(title: "Share Lyrics", icon: "arrow.up.message"), popUpElement(title: "Show Album", icon: "square"), popUpElement(title: "Create Station", icon: "badge.plus.radiowaves.forward")]), popUpElementSection(elements: [popUpElement(title: "Love", icon: "heart"), popUpElement(title: "Suggest Less Like This", icon: "hand.thumbsdown")])]

    
    private init() {}
    
    func getYearOfTheAlbum(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: date)
        return year
    }
    
    //SEARCH BAR METHODS
    @Published var isSearching: Bool = false

    private var previousQuery = ""
    private var isFirstCall = true

    func search(with query: String) {
                        
        DispatchQueue.main.async { [self] in

            if query.isEmpty {
                filteredSongs = currentPlaylistsSongs
            } else if !query.isEmpty, query != previousQuery {
                filteredSongs = currentPlaylistsSongs.filter { $0.track.title.lowercased().contains(query.lowercased()) }
            } else if query == previousQuery {
                return
            }

            previousQuery = query

        }
    }
    
    
    //GET PLAYLISTS API CALLS
    
    func getPlaylists(onCompletion: @escaping (GetPlaylistsResults) -> Void) {
        
        DispatchQueue.main.async { [self] in
            
            appleMusicAPI.checkIfAppleMusicIsAvailable { [self] result in
                
                switch result {
                    
                case .authorized:
                    //AUTHORIZED. Check if user has an apple music subscription
                    appleMusicAPI.checkIfUserHasAppleMusicSubscription { [self] result in
                        
                        switch result {
                            
                        case .SUCCESS:
                            //USER HAS AN ACTIVE APPLE MUSIC SUBSCRIPTION
                            //FETCH STOREFRONTID
                            appleMusicAPI.appleMusicFetchStorefrontRegion { [self] result, storefrontId in
                                
                                if result == .SUCCESS, storefrontId != nil {
                                    //Fetch Playlists
                                    storeFrontId = storefrontId!
                                    appleMusicAPI.appleMusicFetchUsersPlaylists() { [self] result, playlistsIds in
                                        
                                        if result == .SUCCESS {
                                            
                                            appleMusicAPI.appleMusicFetchPlaylistParameters(playlist_ids: playlistsIds!) { result, playlists in
                                                
                                                self.playlists.append(contentsOf: playlists ?? [PlaylistWithMusicStructure]())
                                                onCompletion(.SUCCESS)
                                                
                                            }
                                            
                                        } else {
                                            //Something Went Wrong. Ask user to try again.
                                            onCompletion(.FAILED)
                                        }
                                        
                                    }
                                    
                                } else {
                                    //ERROR. Tell user to try again
                                    onCompletion(.FAILED)
                                }
                                
                            }
                            
                        case .FAILED:
                            //USER DOESNT HAVE AN ACTIVE APPLE MUSIC SUBSCRIPTION. SHOW APPLE MUSIC PAYWALL
                            onCompletion(.USERHASNOSUBSCRIPTION)
                            
                        case .none:
                            //USER DOESNT HAVE AN ACTIVE APPLE MUSIC SUBSCRIPTION. SHOW APPLE MUSIC PAYWALL
                            onCompletion(.USERHASNOSUBSCRIPTION)
                            
                        }
                        
                    }
                    
                case .restricted:
                    //RESTRICTED
                    onCompletion(.restricted)
                    
                case .denied:
                    //DENIED
                    onCompletion(.denied)
                    
                case .notDetermined:
                    //NOTDETERMINED
                    onCompletion(.notDetermined)
                    
                case .none:
                    //Request Authorization as in NOTDETERMINED
                    onCompletion(.notDetermined)
                    
                }
                
            }
            
        }
    }
    
    func getMusicForPlaylist(onCompletion: @escaping (FetchResults) -> Void) {
        
        currentPlaylistsSongs.removeAll()
        filteredSongs.removeAll()
        
        appleMusicAPI.appleMusicFetchMusicFromPlaylist(playlistId: currentPlaylistsId, storefrontId: "tr") { [self] result, music in
            
            if result == .SUCCESS, music != nil {
                
                DispatchQueue.main.async { [self] in
                    currentPlaylistsSubTitle = music?.first?.curatorName ?? music?.first?.featuredArtists?.title ?? ""
                    
                    if music?.first?.curatorName == "Apple Music" {
                        currentPlaylistsCaption = ""
                    } else {
                        let currentDate = Date() // get the current date
                        let lastModifiedDate = music?.first?.lastModifiedDate // get the last modified date of the playlist
                        let calendar = Calendar.current
                        let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: currentDate)!
                        let twoWeeksAgo = calendar.date(byAdding: .weekOfYear, value: -2, to: currentDate)!
                        let yesterday = calendar.date(byAdding: .day, value: -1, to: currentDate)!
                        let today = calendar.startOfDay(for: currentDate)

                        if lastModifiedDate! > twoWeeksAgo && lastModifiedDate! <= weekAgo {
                            // update was made more than 1 week ago but not more than 2 weeks ago
                            let day = calendar.component(.weekday, from: lastModifiedDate!)
                            let weekdays = ["SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"]
                            let dayOfWeek = weekdays[day-1]
                            currentPlaylistsCaption = "UPDATED LAST \(dayOfWeek)"
                        } else if lastModifiedDate! > weekAgo && lastModifiedDate! <= today {
                            // update was made within the current week
                            let day = calendar.component(.weekday, from: lastModifiedDate!)
                            let weekdays = ["SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"]
                            let dayOfWeek = weekdays[day-1]
                            currentPlaylistsCaption = "UPDATED \(dayOfWeek)"
                        } else if lastModifiedDate! > yesterday && lastModifiedDate! <= today {
                            // update was made yesterday
                            currentPlaylistsCaption = "UPDATED YESTERDAY"
                        } else if lastModifiedDate! == today {
                            // update was made today
                            currentPlaylistsCaption = "UPDATED TODAY"
                        }
                    }
                    
                    currentPlaylistsDescription = music?.first?.standardDescription ?? ""
                    
                    var numberOfSongs = 0
                    var totalDuration = 0
                    for track in music!.first!.tracks! {
                        imageLoader.setTheImage(url: track.artwork?.url(width: 256, height: 256)?.absoluteString ?? "", title: track.title) { [self] image in
                            currentPlaylistsSongs.append(trackIcon(image: image ?? UIImage(named: "playlist_artwork_placeholder")!, track: track))
                            if numberOfSongs == music?.first?.tracks?.count {
                                onCompletion(.SUCCESS)
                            }
                        }
                        totalDuration += Int(track.duration ?? 0)
                        numberOfSongs += 1
                    }
                    let hours = totalDuration / 3600
                    let minutes = (totalDuration % 3600) / 60
                    currentPlaylistsTotalDuration = ("\(hours) hours \(minutes) minutes")
                    currentPlaylistsTotalSongs = "\(String(numberOfSongs)) songs"

                    //onCompletion(.SUCCESS)
                }
            } else {
                //Couldnt get music. Ask user to try again
                onCompletion(.FAILED)
            }
            
        }
        
    }
    
}



