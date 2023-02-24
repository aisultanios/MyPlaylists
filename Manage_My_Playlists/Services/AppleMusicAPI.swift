//
//  AppleMusicAPI.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 6.01.2023.
//

import UIKit
import StoreKit
import MusicKit
import MediaPlayer

class AppleMusicAPI {
    
    static let shared = AppleMusicAPI()
    let mediaServiceController = SKCloudServiceController()
    var playlistsArray = [PlaylistWithMusicStructure]()
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    private init() {}
    
    func appleMusicFetchStorefrontRegion(onCompletion: @escaping (FetchResults, String?) -> Void) {
        
        DispatchQueue.global(qos: .background).async { [self] in
            
            mediaServiceController.requestStorefrontIdentifier { storefrontId, error in
                
                DispatchQueue.main.async {
                    
                    guard error == nil else {
                        print("An error occured. Handle it here.")
                        onCompletion(.FAILED, nil)
                        return
                    }
                    
                    guard let storefrontId = storefrontId else {
                        print("Handle the error - the callback didn't contain a storefront ID.")
                        onCompletion(.FAILED, nil)
                        return
                    }
                    
                    let trimmedId = String(storefrontId.prefix(5))
                    onCompletion(.SUCCESS, trimmedId)
                    
                    print("Success! The Storefront ID fetched was: \(trimmedId)")
                    
                }
                
            }
        }
        
    }
    
    func appleMusicFetchUsersPlaylists(onCompletion: @escaping (FetchResults, MusicItemCollection<Playlist>?) -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            
            let schemeStruct = appleMusicFetchUsersPlaylistsScheme()

            Task {
                
                var UsersPlaylistsURLComponents = URLComponents()
                UsersPlaylistsURLComponents.scheme = schemeStruct.requestScheme
                UsersPlaylistsURLComponents.host = schemeStruct.requestHost
                UsersPlaylistsURLComponents.path = schemeStruct.requestPath
                
                if let url = UsersPlaylistsURLComponents.url {
                    
                    do {
                        
                        let dataRequest = MusicDataRequest(urlRequest: URLRequest(url: url))
                        let playlistsResponse = try await dataRequest.response()
                        
                        let playlists = try? decoder.decode(MusicItemCollection<Playlist>.self, from: playlistsResponse.data)
                        
                        DispatchQueue.main.async {
                            onCompletion(.SUCCESS, playlists)
                        }
                        
                    } catch {
                        print("Error Occured When fetching users playlists")
                        DispatchQueue.main.async {
                            onCompletion(.FAILED, nil)
                        }
                    }
                    
                }
            }
        }
        
    }
    
    func appleMusicFetchPlaylistParameters(playlist_ids: MusicItemCollection<Playlist>, onCompletion: @escaping (FetchResults, [PlaylistWithMusicStructure]?) -> Void) {
        
        let schemeStruct = appleMusicFetchUsersPlaylistParametersScheme()

        playlistsArray.removeAll()
        
        for playlist_id in playlist_ids {
            
            DispatchQueue.global(qos: .userInitiated).async { [self] in

                Task {
                    
                    var UsersPlaylistParametersURLComponents = URLComponents()
                    UsersPlaylistParametersURLComponents.scheme = schemeStruct.requestScheme
                    UsersPlaylistParametersURLComponents.host = schemeStruct.requestHost
                    UsersPlaylistParametersURLComponents.path = "\(schemeStruct.requestPath)/\(playlist_id.id)"
                    
                    if let url = UsersPlaylistParametersURLComponents.url {
                        do {
                            let dataRequest = MusicDataRequest(urlRequest: URLRequest(url: url))
                            let playlistsResponse = try await dataRequest.response()
                            let playlist = try? decoder.decode(MusicItemCollection<Playlist>.self, from: playlistsResponse.data)
                            
                            let data = try? encoder.encode(playlist?.first?.playParameters)
                            if data != nil {
                                let playParams = try? decoder.decode(MPMusicPlayerPlayParameters.self, from: data!)
                                DispatchQueue.main.async { [self] in
                                playlistsArray.append(PlaylistWithMusicStructure(Playlist: playlist?.first ?? nil, Tracks: [Track?](), PlayParams: playParams ?? nil))
                                    if playlistsArray.count == playlist_ids.count {
                                        onCompletion(.SUCCESS, playlistsArray)
                                    }
                                }
                                
                            } else {
                                DispatchQueue.main.async {
                                    onCompletion(.FAILED, nil)
                                }
                            }
                            
                        } catch {
                            print("Error Occured When fetching users playlists params")
                            onCompletion(.FAILED, nil)
                        }
                    }
                }
            }
        }
    }
    
    func appleMusicFetchMusicFromPlaylist(playlistId: String, storefrontId: String, onCompletion: @escaping (FetchResults, MusicItemCollection<Playlist>?) -> Void) {
        
        let schemeStruct = appleMusicFetchMusicFromPlaylistScheme()
        
        DispatchQueue.main.async { [self] in
            
            Task {
                
                var playlistTracksRequestURLComponents = URLComponents()
                playlistTracksRequestURLComponents.scheme = schemeStruct.requestScheme
                playlistTracksRequestURLComponents.host = schemeStruct.requestHost
                playlistTracksRequestURLComponents.path = "\(schemeStruct.requestPath)/\(playlistId)"
                playlistTracksRequestURLComponents.queryItems = schemeStruct.queryItems
                
                if let url = playlistTracksRequestURLComponents.url {
                    do {
                        let dataRequest = MusicDataRequest(urlRequest: URLRequest(url: url))
                        let playlistsResponse = try await dataRequest.response()
                        let playlist = try? decoder.decode(MusicItemCollection<Playlist>.self, from: playlistsResponse.data)
                        
                        DispatchQueue.main.async {
                            if playlist != nil {
                                onCompletion(.SUCCESS, playlist)
                            } else {
                                onCompletion(.FAILED, nil)
                            }
                        }
                            
                    } catch {
                        print("Error Occured When fetching music from playlist")
                        DispatchQueue.main.async {
                            onCompletion(.FAILED, nil)
                        }
                    }
                }
                
            }
        }
    }
    
    func checkIfAppleMusicIsAvailable(onCompletion: @escaping (MediaRequestResultReferences?) -> Void) {
                
        DispatchQueue.global(qos: .background).async {
            
            if SKCloudServiceController.authorizationStatus() == .authorized {
                
                onCompletion(.authorized)
                
            } else if SKCloudServiceController.authorizationStatus() == .denied {
                
                onCompletion(.denied)
                
            } else if SKCloudServiceController.authorizationStatus() == .notDetermined {
                
                onCompletion(.notDetermined)
                
            } else if SKCloudServiceController.authorizationStatus() == .restricted {
                
                onCompletion(.restricted)
                
            }
            
        }
    }
    
    func checkIfUserHasAppleMusicSubscription(onCompletion: @escaping (FetchResults?) -> Void) {
        
        DispatchQueue.global(qos: .background).async { [self] in
            mediaServiceController.requestCapabilities { capabilities, error in
                if capabilities.contains(.musicCatalogPlayback) {
                    // User has Apple Music account
                    onCompletion(.SUCCESS)
                }
                else if capabilities.contains(.musicCatalogSubscriptionEligible) {
                    // User can sign up to Apple Music
                    onCompletion(.FAILED)
                }
            }
        }
        
    }
    
}
