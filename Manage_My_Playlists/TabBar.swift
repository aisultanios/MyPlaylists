//
//  TabBar.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 4.02.2023.
//

import SwiftUI
import UIKit


struct TabBarRepresentable: UIViewControllerRepresentable {
        
    func makeUIViewController(context: Context) -> TabBarController {
        return TabBarController()
    }

    func updateUIViewController(_ uiViewController: TabBarController, context: Context) {
        // update logic here if needed
    }
    
}

struct TabBar: View {
    
    @StateObject private var viewModel = MediaContentManager.shared
    
    @State var expand: Bool = false
    @Namespace var animation
    
    var body: some View {
        
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: expand ? .center: .bottom)) {
            
            TabBarRepresentable()
                .edgesIgnoringSafeArea([.top, .bottom])
            
            if viewModel.isSearching == false {
                MiniPlayer(animation: animation, expand: $expand)
            }
            
        }
        
    }
    
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
