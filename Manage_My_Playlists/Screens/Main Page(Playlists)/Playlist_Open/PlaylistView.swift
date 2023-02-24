//
//  PlaylistView.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 8.01.2023.
//

import SwiftUI
import UIKit
import Combine

struct PlaylistContentView: View {
    
    @StateObject var router = Router(initial: AppRoute.FeaturedArtistsView)
    @StateObject var viewModel = MediaContentManager.shared

    var body: some View {
        ZStack {
            
            RouterHost(router: router) { route in
                switch route {
                case .PlaylistView: PlaylistView()
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle("")
                case .FeaturedArtistsView: FeaturedArtistsView(artists: $viewModel.featuredArtists)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle("Featured Artists")
                }
            }.environmentObject(router)
            
        }//: ZSTACK
    }
    
}

struct PlaylistView: View {
    
    //MARK: -PROPERTY
    
    @StateObject var viewModel = MediaContentManager.shared
    @ObservedObject var audioManager = AudioManager.shared
    
    @State var songsAreFetched: Bool = false
    @State var showActivityIndicator: Bool = true
    @State var isSearching: Bool = false
    @State var hideNavBar: Bool = false
    @State var query = ""
    @State var showArtworkAndDescriptions: Bool = true
    @Environment(\.dismissSearch) var dismissSearch
    
    @State var trackCellHeight: CGFloat = 55.0
    
    @EnvironmentObject var router: Router<AppRoute>
    @State private var path = NavigationPath()

    @State var currentPlayingItemsTitle: String? = nil
    
    @State private var selectedIndex: Int?
    
    var body: some View {
        
        GeometryReader { geo in
            
            ZStack {
                
                if songsAreFetched == true {
                    
                    ChildView(isSearching: $isSearching, showArtworkAndDescriptions: $showArtworkAndDescriptions)
                    
                    ScrollView(.vertical, showsIndicators: true) {
                        
                        VStack() {
                            
                            //Playlist Arwork
                            if showArtworkAndDescriptions == true {
                                Image(uiImage: viewModel.currentPlaylistsArtwork)
                                    .playlistArtworkImageModifier(width: geo.size.width)
                                    .offset(y: 7.5)
                                
                                VStack(alignment: .center, spacing: 4) {
                                    
                                    //Playlist title
                                    if viewModel.currentPlaylistsTitle != "", viewModel.currentPlaylistsTitle != "nil" {
                                        Text(viewModel.currentPlaylistsTitle)
                                            .foregroundColor(.black)
                                            .font(.system(size: 22.5, weight: .semibold, design: .default))
                                            .multilineTextAlignment(.center)
                                            .lineLimit(2)
                                            .padding([.leading, .trailing], 20)
                                    }
                                    
                                    //Playlist subtitle
                                    if viewModel.currentPlaylistsSubTitle != "", viewModel.currentPlaylistsSubTitle != "nil" {
                                        Text(viewModel.currentPlaylistsSubTitle)
                                            .foregroundColor(.pink)
                                            .font(.system(size: 23.0, weight: .regular, design: .default))
                                            .multilineTextAlignment(.center)
                                    }
                                    
                                    //Playlist caption
                                    if viewModel.currentPlaylistsCaption != "", viewModel.currentPlaylistsCaption != "nil" {
                                        Text(viewModel.currentPlaylistsCaption)
                                            .foregroundColor(.secondary)
                                            .font(.system(size: 16.5, weight: .medium, design: .default))
                                            .multilineTextAlignment(.center)
                                    }
                                }
                                .offset(y: 20.0)
                            }
                            
                            VStack(alignment: .leading, spacing: 16.5) {
                                
                                if viewModel.filteredSongs.isEmpty == true, isSearching == true {
                                    
                                } else {
                                    //Play and Shuffle Buttons
                                    HStack(alignment: .center, spacing: geo.size.width / 21.5) {
                                        Button {
                                            //Some Action
                                            print("Play")
                                            audioManager.play()
                                        } label: {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(.gray.opacity(0.15))
                                                .overlay {
                                                    HStack(alignment: .center, spacing: 5) {
                                                        Image(systemName: "play.fill")
                                                            .playlistsPlayBtnImageModifiers()
                                                        Text("Play")
                                                            .foregroundColor(.pink)
                                                            .font(.system(size: 19.0, weight: .medium, design: .default))
                                                    }
                                                }
                                        }
                                        .frame(width: (geo.size.width / 2) - ((geo.size.width / 21.5) * 1.5), height: 50.0, alignment: .center)
                                        
                                        Button {
                                            //Some Action
                                            print("Shuffle")
                                            audioManager.playShuffled()
                                        } label: {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(.gray.opacity(0.15))
                                                .overlay {
                                                    HStack(alignment: .center, spacing: 5) {
                                                        Image(systemName: "shuffle")
                                                            .playlistsShuffleBtnImageModifiers()
                                                        Text("Shuffle")
                                                            .foregroundColor(.pink)
                                                            .font(.system(size: 19.0, weight: .medium, design: .default))
                                                    }
                                                }
                                        }
                                        .frame(width: (geo.size.width / 2) - ((geo.size.width / 21.5) * 1.5), height: 50.0, alignment: .center)
                                    }
                                    .padding([.leading, .trailing], geo.size.width / 21.5)
                                    
                                    if viewModel.currentPlaylistsDescription != "", showArtworkAndDescriptions == true {
                                        //Playlists Description
                                        Text(viewModel.currentPlaylistsDescription)
                                            .foregroundColor(.secondary)
                                            .font(.system(size: 16.5, weight: .regular, design: .default))
                                            .padding(.trailing, (geo.size.width / 21.5))
                                            .padding(.leading, (geo.size.width / 21.5))
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(2)
                                        
                                        
                                    }
                                    //List
                                    PlaylistsList(width: geo.size.width)
                                    
                                    if showArtworkAndDescriptions == true {
                                        
                                        //Number of songs and length
                                        Text("\(viewModel.currentPlaylistsTotalSongs), \(viewModel.currentPlaylistsTotalDuration)")
                                            .foregroundColor(.secondary)
                                            .font(.subheadline)
                                            .multilineTextAlignment(.leading)
                                            .padding([.leading, .trailing], (geo.size.width / 21.5))
                                            .frame(height: 47.5, alignment: .topLeading)
                                        
                                        //Featured Artists List
                                        VStack(alignment: .leading, spacing: 10) {
                                            
                                            NavigationLink(destination: FeaturedArtistsView(artists: $viewModel.featuredArtists)) {
                                                HStack(alignment: .center, spacing: 5) {
                                                    Text("Featured Artists")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 24.0, weight: .bold, design: .default))
                                                        .multilineTextAlignment(.leading)
                                                    Image(systemName: "chevron.right")
                                                        .font(.system(size: 20.0, weight: .bold, design: .default))
                                                        .foregroundColor(.gray)
                                                }
                                                .padding(.top)
                                                .padding(.leading, geo.size.width / 21.5)
                                            }
                                            
                                            FeaturedArtistsList(width: geo.size.width)
                                            
                                        }
                                        .frame(height: geo.size.width / 1.4, alignment: .top)
                                        .background(.gray.opacity(0.125))
                                        
                                    }
                                    
                                }
                            }//: VSTACK
                            .offset(y: (isSearching ? 8.5: 22.5))
                        }//: VSTACK
                        
                    }//: SCROLLVIEW
                    .background(.white)
                    
                }
            }//: ZSTACK
        }//: GEOMETRY READER
        .onChange(of: isSearching) { newValue in
            viewModel.isSearching = newValue
            if newValue == false {
                UINavigationBar.appearance().tintColor = .black
                showArtworkAndDescriptions = true
            } else if newValue == true {
                UINavigationBar.appearance().tintColor = .systemPink
                showArtworkAndDescriptions = false
            }
        }//: ONCHANGE
        .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .automatic))
        .listStyle(.plain)
        .environment(\.defaultMinListRowHeight, 35.5)
        .listRowSeparator(.visible, edges: [.all])
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            
            HStack(alignment: .center, spacing: 7.5) {
                Button {
                    print("")
                } label: {
                    Circle()
                        .fill(.gray.opacity(0.15))
                        .frame(width: 30, height: 30)
                        .overlay {
                            Image(systemName: "arrow.down")
                                .font(.system(size: 13.0, weight: .semibold))
                                .foregroundColor(.pink)
                                .padding()
                        }
                }
                
                //PLAYLISTS CONTEXTMENU
                PlaylistMorePopup(showPlaylistMenuPickerSelection: $viewModel.showPlaylistMenuPickerSelection, showPlaylistMenuPicker: $viewModel.showPlaylistMenuPicker, sections: $viewModel.playlistPopupSections)
                
            }//: HSTACK
            
        }//: TOOLBAR
        .onAppear {
            
            if !viewModel.currentPlaylistsSongs.contains(where: {$0.track.albumTitle == viewModel.currentPlaylistsTitle}) || viewModel.currentPlaylistsSongs.isEmpty {
                viewModel.getMusicForPlaylist { result in
                    print(result)
                    if result == .SUCCESS {
                        songsAreFetched = true
                        showActivityIndicator = false
                        viewModel.search(with: query)
                    } else {
                        songsAreFetched = false
                        showActivityIndicator = false
                    }
                }
            }
            
            
        }//: ONAPPEAR
        .overlay {
            if showActivityIndicator == true {
                VStack(alignment: .center, spacing: 12.5) {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .foregroundColor(.gray)
                        .scaleEffect(1)
                        .ignoresSafeArea(.all)
                        .padding(0)
                    
                    Text("LOADING")
                        .foregroundColor(.gray)
                        .font(.system(size: 17.0, weight: .regular, design: .default))
                        .multilineTextAlignment(.center)
                }
            }
            
            if viewModel.filteredSongs.count == 0, isSearching == true {
                EmptySearchList()
                    .ignoresSafeArea(.all)
            }
            
            if viewModel.showContextMenuActionPopup == true {
                ContextMenuActionPopup(animateContextMenuActionPopup: $viewModel.showContextMenuActionPopup, popupTitle: $viewModel.contextMenuActionPopupsTitle, popupIcon: $viewModel.contextMenuActionPopupsIcon, size: CGSize(width: UIScreen.main.bounds.width / 1.66, height: UIScreen.main.bounds.width / 1.566))
            }
            
        }//:OVERLAY
        .onSubmit(of: .search, {
            viewModel.search(with: query)
        })//: ONSUBMIT
        .onChange(of: query, perform: { newValue in
            viewModel.search(with: newValue)
        })//: ONCANGE
        .disabled(viewModel.showContextMenuActionPopup)
        
    }
        
    @ViewBuilder
    func PlaylistsList(width: CGFloat) -> some View {
        
        LazyVStack(alignment: .center, spacing: 0) {
            
            if showArtworkAndDescriptions == true {
                Divider()
                    .padding([.leading], width / 21.5)
            }
            
                ForEach(viewModel.filteredSongs.indices, id: \.self) { index in
                    VStack(alignment: .center, spacing: 0.0) {
                        HStack {
                            if viewModel.filteredSongs[index].track.title == viewModel.currentPlayingItemsTitle {
                                TrackCell(coverImageData: viewModel.filteredSongs[index].image, numberInOrder: String(index + 1), title: viewModel.filteredSongs[index].track.title, artistName: viewModel.filteredSongs[index].track.artistName, albumTitle: viewModel.filteredSongs[index].track.albumTitle ?? "", releaseDate: viewModel.getYearOfTheAlbum(date: viewModel.filteredSongs[index].track.releaseDate ?? Date()), width: 47.5, height: 47.5, isContextMenu: false, showTrackPickerSelection: $viewModel.showTrackPickerSelection, showTrackPicker: $viewModel.showTrackPicker, sections: $viewModel.trackPopupSections, isCurrentPlayingItem: (viewModel.filteredSongs[index].track.title == viewModel.currentPlayingItemsTitle) ? true: false, screenWidth: width)
                                    .buttonStyle(.automatic)
                                    .frame(height: 55.0)
                                    .offset(y: 0)
                                    .padding([.leading], width / 21.5)
                                    .background(.white)
                                    .onTapGesture {
                                        if viewModel.showTrackPicker == false {
                                            withAnimation {
                                                self.selectedIndex = index
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                                withAnimation {
                                                    self.selectedIndex = nil
                                                }
                                            }
                                            
                                            if (index) != 0 {
                                                audioManager.play(startingAt: index)
                                            } else {
                                                audioManager.play()
                                            }
                                        }
                                    }//: ONTAP PLAY GESTURE
                                
                            } else {
                                TrackCell(coverImageData: viewModel.filteredSongs[index].image, numberInOrder: String(index + 1), title: viewModel.filteredSongs[index].track.title, artistName: viewModel.filteredSongs[index].track.artistName, albumTitle: viewModel.filteredSongs[index].track.albumTitle ?? "", releaseDate: viewModel.getYearOfTheAlbum(date: viewModel.filteredSongs[index].track.releaseDate ?? Date()), width: 47.5, height: 47.5, isContextMenu: false, showTrackPickerSelection: $viewModel.showTrackPickerSelection, showTrackPicker: $viewModel.showTrackPicker, sections: $viewModel.trackPopupSections, isCurrentPlayingItem: false, screenWidth: width)
                                    .buttonStyle(.automatic)
                                    .frame(height: 55.0)
                                    .offset(y: 0)
                                    .padding([.leading], width / 21.5)
                                    .background(.white)
                                    .onTapGesture {
                                        if viewModel.showTrackPicker == false {
                                            withAnimation {
                                                self.selectedIndex = index
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                                withAnimation {
                                                    self.selectedIndex = nil
                                                }
                                            }
                                            
                                            if (index) != 0 {
                                                audioManager.play(startingAt: index)
                                            } else {
                                                audioManager.play()
                                            }
                                        }
                                    }//ONTAP PLAY GESTURE
                            }
                            
                            TrackPopup(showTrackPickerSelection: $viewModel.showTrackPickerSelection, sections: $viewModel.trackPopupSections)
                                .frame(width: 20.0, height: 55.0, alignment: .center)
                                .opacity(viewModel.showTrackPicker ? 0.25: 1.0)
                                .zIndex(1)
                            
                        }//HSTACK
                        .contextMenu {
                            
                            ForEach(viewModel.trackPopupSections, id: \.self) { section in
                                Section(content: {
                                    ForEach(section.elements, id: \.self) { row in
                                        
                                        Button {
                                            //Action
                                        } label: {
                                            HStack {
                                                Text(row.title)
                                                    .font(.system(size: 14.0, weight: .medium, design: .default))
                                                    .foregroundColor(.black)
                                                    .multilineTextAlignment(.leading)
                                                
                                                Spacer()
                                                
                                                Image(systemName: row.icon)
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 14.0, weight: .semibold, design: .default))
                                            }
                                        }
                                    }
                                })
                                .listRowBackground(Color.white)
                            }
                            
                        } preview: {
                            HStack {
                                
                                TrackCell(coverImageData: viewModel.filteredSongs[index].image, numberInOrder: String(index + 1), title: viewModel.filteredSongs[index].track.title, artistName: viewModel.filteredSongs[index].track.artistName, albumTitle: viewModel.filteredSongs[index].track.albumTitle ?? "", releaseDate: viewModel.getYearOfTheAlbum(date: viewModel.filteredSongs[index].track.releaseDate ?? Date()), width: 100, height: 100, isContextMenu: true, showTrackPickerSelection: $viewModel.showTrackPickerSelection, showTrackPicker: $viewModel.showTrackPicker, sections: $viewModel.trackPopupSections, isCurrentPlayingItem: false, screenWidth: width)
                                    .frame(width: width, height: 155)
                                    .padding([.leading, .trailing], width / 21.5)
                                                             
                            }
                        }//: CONTEXTMENU/PREVIEW
                        
                        Divider()
                            .padding([.leading], (width / 21.5) + 65.0)
                        
                    }//VSTACK
                    .addButtonActions(leadingButtons: [.playNext, .playLast], trailingButton: [.addToPlaylist]) { button in
                        print(button)
                        switch button {
                        case .playNext:
                            viewModel.contextMenuActionPopupsTitle = "Playing Next"
                            viewModel.contextMenuActionPopupsIcon = "text.line.first.and.arrowtriangle.forward"
                            withAnimation(.easeInOut(duration: 0.5)) {
                                viewModel.showContextMenuActionPopup = true
                            }
                        case .playLast:
                            viewModel.contextMenuActionPopupsTitle = "Playing Last"
                            viewModel.contextMenuActionPopupsIcon = "text.line.last.and.arrowtriangle.forward"
                            withAnimation(.easeInOut(duration: 0.5)) {
                                viewModel.showContextMenuActionPopup = true
                            }
                        case .addToPlaylist:
                            viewModel.contextMenuActionPopupsTitle = "Added to Library"
                            viewModel.contextMenuActionPopupsIcon = "checkmark"
                            withAnimation(.easeInOut(duration: 0.5)) {
                                viewModel.showContextMenuActionPopup = true
                            }
                        }
                    }
                    .overlay(selectedIndex == index ? .gray.opacity(0.75) : .clear)
                }//: FOREACH TRACKS LIST
                .id(query)
        }//: LazyVSTACK
    }
    
    @ViewBuilder
    func FeaturedArtistsList(width: CGFloat) -> some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 10) {
                ForEach(viewModel.featuredArtists) { artist in
                    
                    FeaturedArtistCell(artistImage: artist.artistImage, artistName: artist.artistName, width: width / 3.61, height: width / 3.61, fontSize: 16.0, textAlinmentCentered: true)
                        .frame(height: width / 3.61 + 30)
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
                            FeaturedArtistCell(artistImage: artist.artistImage, artistName: artist.artistName, width: (width / 1.15) - 35, height: (width / 1.15) - 35, fontSize: 20, textAlinmentCentered: false).frame(alignment: .top)
                                .frame(width: width / 1.15, height: width / 1.045)
                        } //CONTEXTMENU/PREVIEW
                    
                }//: FOREACH FEATURED ARTISTS LIST
            }//: HSTACK
            .padding(.horizontal, width / 21.5)
        }
    }
    
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView()
    }
}

//CHILD VIEW IS USED TO TRACK SEARCH BARS ACTIVITY
struct ChildView : View {
    @Environment(\.isSearching) var isSearchingEnv
    @Binding var isSearching: Bool
    @Binding var showArtworkAndDescriptions: Bool
    var body: some View {
        Text("")
            .onChange(of: isSearchingEnv) { newValue in
                isSearching = newValue
                if newValue == true {
                    showArtworkAndDescriptions = false
                } else if newValue == false {
                    showArtworkAndDescriptions = true
                }
                print(newValue)
            }
    }
}

struct CustomSearchBar: View {
    
    @Binding var query: String
    @Binding var isSearching: Bool
    @Binding var showCancelButton: Bool
    @State var width: CGFloat = 0.0
    var onCancel: (() -> Void)?
    var onSearch: (() -> Void)?
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.gray.opacity(0.175))
                .overlay {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 10)
                        
                        TextField("Search", text: $query)
                            .foregroundColor(.black)
                            .background(.clear)
                            .tint(.pink)
                            .accentColor(.pink)
                        
                        if query != "" {
                            Button(action: {
                                self.query = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 5)
                            }
                        }
                    }
                }// :OVERLAY
                .onChange(of: query, perform: { newValue in
                    UITextField.appearance().returnKeyType = .done
                })//: ONCHANGE
            if showCancelButton == true {
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    self.query = ""
                    self.onCancel?()
                }) {
                    Text("Cancel")
                        .foregroundColor(.pink)
                }
                .opacity(isSearching ? 1.0: 0.0)
                .padding(.trailing, isSearching ? 0: -100)
            }
        }//: HSTACK
        .frame(width: (width - ((width / 21.5) * 2)), height: 40, alignment: .center)
    }
}
