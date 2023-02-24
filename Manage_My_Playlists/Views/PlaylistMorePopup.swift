//
//  PlaylistMorePopup.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 27.01.2023.
//

import SwiftUI

struct PlaylistMorePopup: View {
    
    @StateObject private var viewModel = MediaContentManager.shared
    
    @Binding var showPlaylistMenuPickerSelection: String
    @Binding var showPlaylistMenuPicker: Bool
    @Binding var sections: [popUpElementSection]
    
    var sortBy: [sortByElement] = [sortByElement(title: "Playlist Order"), sortByElement(title: "Title"), sortByElement(title: "Artist"), sortByElement(title: "Album"), sortByElement(title: "Release Date")]
    
    var body: some View {
        
        Menu {
            ForEach(sections, id: \.self) { section in
                Section(content: {
                    ForEach(section.elements, id: \.self) { row in
                        
                        if row.title == "Sort By" {
                                                        
                            sortByPicker()
                            
                        } else if row.title == "Delete from Library" {
                            
                            sectionElementButton(title: row.title, icon: row.icon, role: .destructive)
                            
                        } else {
                            
                            sectionElementButton(title: row.title, icon: row.icon, role: .cancel)
                            
                        }
                        
                    }
                })
                .listRowBackground(Color.white)
            }
        } label: {
            Circle()
                .fill(.gray.opacity(0.15))
                .frame(width: 30, height: 30)
                .overlay {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 13.0, weight: .semibold))
                        .foregroundColor(.pink)
                        .padding()
                        .opacity(showPlaylistMenuPicker ? 0.25: 1.0)
                }
        }
    }
    
    @ViewBuilder
    func sortByPicker() -> some View {
        
        Menu {
            ForEach(sortBy) { sortSection in
                Button {
                    //Sort Action
                } label: {
                    HStack {
                        Text(sortSection.title)
                            .font(.system(size: 14.0, weight: .regular, design: .default))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                    }
                }

            }
        } label: {
            HStack {
                
                Text("Sort By")
                    .font(.system(size: 14.0, weight: .black, design: .default))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Image(systemName: "arrow.up.arrow.down")
                    .foregroundColor(.black)
                    .font(.system(size: 14.0, weight: .black, design: .default))
            }
        }
        .pickerStyle(.menu)
        
    }
    
    @ViewBuilder
    func sectionElementButton(title: String, icon: String, role: ButtonRole) -> some View {
        Button(role: role) {
            //Action
            if title == "Love" {
                if title == "Love" {
                    viewModel.contextMenuActionPopupsTitle = "Loved"
                    viewModel.contextMenuActionPopupsIcon = "heart"
                    withAnimation(.easeInOut(duration: 0.5)) {
                        viewModel.showContextMenuActionPopup = true
                    }
                }
            }
        } label: {
            HStack {
                Text(title)
                    .font(.system(size: 14.0, weight: .medium, design: .default))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Image(systemName: icon)
                    .foregroundColor(.black)
                    .font(.system(size: 14.0, weight: .semibold, design: .default))
            }
        }
    }
    
}

struct popUpElementSection: Identifiable, Hashable {
    
    let id: String
    var elements: [popUpElement]
    
    init(elements: [popUpElement]) {
        self.id = UUID().uuidString
        self.elements = elements
    }
    
}

struct popUpElement: Identifiable, Hashable {
    let id: String
    var title: String
    var icon: String
    
    init(title: String, icon: String) {
        self.id = UUID().uuidString
        self.title = title
        self.icon = icon
    }
    
}

struct sortByElement: Identifiable {
    let id: String
    var title: String
    
    init(title: String) {
        self.id = UUID().uuidString
        self.title = title
    }
    
}
