//
//  Manage_My_PlaylistsTests.swift
//  Manage_My_PlaylistsTests
//
//  Created by Aisultan Askarov on 13.10.2022.
//

import XCTest
@testable import Manage_My_Playlists

final class Manage_My_PlaylistsTests: XCTestCase {
    
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
        XCTAssertEqual(requestPath, "/v1/me/library/playlists/")
        XCTAssertEqual(requestQueryItems, [URLQueryItem(name: "include", value: "catalog")])

    }
    
}
