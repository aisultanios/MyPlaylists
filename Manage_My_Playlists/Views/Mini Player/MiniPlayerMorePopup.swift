//
//  MiniPlayerMorePopup.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 14.02.2023.
//

import SwiftUI

//BLACK CONTEXT MENU STYLE
struct BlackMenu: MenuStyle {
    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .foregroundColor(.black.opacity(0.75))
    }
}

struct MiniPlayerMorePopup: View {
    
    @Binding var showMiniPlayerMenuPickerSelection: String
    @Binding var showMiniPlayerMenuPicker: Bool
    @Binding var sections: [popUpElementSection]
    @StateObject private var viewModel = MediaContentManager.shared

    var body: some View {
        
        Menu {
            ForEach(sections.reversed(), id: \.self) { section in
                Section(content: {
                    ForEach(section.elements, id: \.self) { row in
                        
                        sectionElementButton(title: row.title, icon: row.icon, role: .cancel)
                        
                    }
                })
            }
        } label: {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(.white.opacity(0.15))
                .background {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white.opacity(showMiniPlayerMenuPicker ? 0.25: 1.0))
                        .frame(width: 16.5, height: 16.5, alignment: .center)
                        .fontWeight(.heavy)
                }
        }
        .colorScheme(.dark)
        
    }
    
    @ViewBuilder
func sectionElementButton(title: String, icon: String, role: ButtonRole) -> some View {
    Button(role: role) {
        //Action
        if title == "Add to Library" {
            viewModel.contextMenuActionPopupsTitle = "Added to Library"
            viewModel.contextMenuActionPopupsIcon = "checkmark"
            withAnimation(.easeInOut(duration: 0.5)) {
                viewModel.showContextMenuActionPopup = true
            }
        }
    } label: {
        HStack {
            Text(title)
                .font(.system(size: 14.0, weight: .medium, design: .default))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Image(systemName: icon)
                .foregroundColor(.white)
                .font(.system(size: 14.0, weight: .semibold, design: .default))
        }
    }
}
    
}
    
