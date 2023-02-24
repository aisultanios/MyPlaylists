//
//  Manage_My_Playlists_API_Calls_Tests.swift
//  Manage_My_PlaylistsTests
//
//  Created by Aisultan Askarov on 23.02.2023.
//

import XCTest
@testable import Manage_My_Playlists
//Testing End Points Incase If Anybody Decides To Change Them 
final class Manage_My_Playlists_API_Calls_Tests: XCTestCase {

    func testFetchUsersPlaylists() throws {
        
        //given
        let parameters = appleMusicFetchUsersPlaylistsScheme()
        let requestScheme = parameters.requestScheme
        let requestHost = parameters.requestHost
        let requestPath = parameters.requestPath
        //then
        XCTAssertEqual(requestScheme, "https")
        XCTAssertEqual(requestHost, "api.music.apple.com")
        XCTAssertEqual(requestPath, "/v1/me/library/playlists?")
        
    }
    
    func testFetchUsersPlaylistParameters() throws {
        
        //given
        let parameters = appleMusicFetchUsersPlaylistParametersScheme()
        let requestScheme = parameters.requestScheme
        let requestHost = parameters.requestHost
        let requestPath = parameters.requestPath
        //then
        XCTAssertEqual(requestScheme, "https")
        XCTAssertEqual(requestHost, "api.music.apple.com")
        XCTAssertEqual(requestPath, "/v1/me/library/playlists/")
        
    }

    func testFetchMusicFromPlaylistParameters() throws {
        
        //given
        let parameters = appleMusicFetchMusicFromPlaylistScheme()
        let requestScheme = parameters.requestScheme
        let requestHost = parameters.requestHost
        let requestPath = parameters.requestPath
        let requestQueryItems = parameters.queryItems
        //then
        XCTAssertEqual(requestScheme, "https")
        XCTAssertEqual(requestHost, "api.music.apple.com")
        XCTAssertEqual(requestPath, "/v1/catalog/tr/playlists/")
        XCTAssertEqual(requestQueryItems, [URLQueryItem(name: "include", value: "catalog")])

    }
}
