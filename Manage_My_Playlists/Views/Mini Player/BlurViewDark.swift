//
//  BlurViewDark.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 9.02.2023.
//

import SwiftUI
import UIKit

struct BlurViewDark: UIViewRepresentable {
        
    var averageColor: UIColor
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        view.alpha = 1.0
        
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    }
    
}

