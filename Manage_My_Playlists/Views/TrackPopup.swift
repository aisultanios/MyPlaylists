//
//  TrackPopup.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 28.01.2023.
//

import SwiftUI

struct TrackPopup: View {
    
    @Binding var showTrackPickerSelection: String
    @Binding var sections: [popUpElementSection]
    @StateObject private var viewModel = MediaContentManager.shared
    
    var body: some View {
        
        Menu {
            ForEach(sections, id: \.self) { section in
                Section(content: {
                    ForEach(section.elements, id: \.self) { row in
                        
                        Button {
                            //Action
                            switch row.title {
                            case "Playing Next":
                                viewModel.contextMenuActionPopupsTitle = "Playing Next"
                                viewModel.contextMenuActionPopupsIcon = "text.line.first.and.arrowtriangle.forward"
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    viewModel.showContextMenuActionPopup = true
                                }
                            case "Playing Last":
                                viewModel.contextMenuActionPopupsTitle = "Playing Last"
                                viewModel.contextMenuActionPopupsIcon = "text.line.last.and.arrowtriangle.forward"
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    viewModel.showContextMenuActionPopup = true
                                }
                            case "Added to Library":
                                viewModel.contextMenuActionPopupsTitle = "Added to Library"
                                viewModel.contextMenuActionPopupsIcon = "checkmark"
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    viewModel.showContextMenuActionPopup = true
                                }
                            case "Love":
                                viewModel.contextMenuActionPopupsTitle = "Loved"
                                viewModel.contextMenuActionPopupsIcon = "heart"
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    viewModel.showContextMenuActionPopup = true
                                }
                            default:
                                viewModel.contextMenuActionPopupsTitle = "Added to Library"
                                viewModel.contextMenuActionPopupsIcon = "checkmark"
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    viewModel.showContextMenuActionPopup = true
                                }
                            }
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
        } label: {
            Image(systemName: "ellipsis")
                .trackCellEllipseModifier()
        }
        .padding(.trailing, 55)
        .frame(width: 20, height: 55, alignment: .center)
        .buttonStyle(.borderless)
    }
}

