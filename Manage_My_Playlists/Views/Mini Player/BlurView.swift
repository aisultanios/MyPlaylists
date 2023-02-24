//
//  BlurView.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 4.02.2023.
//

import SwiftUI
import UIKit

struct BlurView: UIViewRepresentable {
        
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    }
    
}
