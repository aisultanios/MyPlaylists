//
//  ContextMenuActionPopup.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 4.02.2023.
//

import SwiftUI

struct ContextMenuActionPopup: View {
    
    @Binding var animateContextMenuActionPopup: Bool
    @Binding var popupTitle: String
    @Binding var popupIcon: String
    @State var size: CGSize?
    @State private var showCheckmark: CGFloat = -100
    @State private var scale = 0.0

    var body: some View {
        ZStack(alignment: .center, content: {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(uiColor: .systemGray6))
                .overlay(alignment: .bottom) {
                    VStack(alignment: .center, spacing: popupTitle == "Loved" ? 22: 45) {
                        
                        if popupTitle == "Added to Library" {
                            
                            Image(systemName: popupIcon)
                                .foregroundColor(.gray)
                                .font(.system(size: 100, weight: .regular, design: .default))
                                .clipShape(Rectangle().offset(x: showCheckmark))
                                .scaledToFill()
                            
                        } else {
                            
                            Image(systemName: popupIcon)
                                .foregroundColor(.gray)
                                .font(.system(size: 100, weight: .regular, design: .default))
                                .scaledToFill()
                            
                        }
                        
                        VStack(alignment: .center, spacing: 6.5) {
                            
                            Text(popupTitle)
                                .font(.system(size: 22.0, weight: .semibold))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                            
                            if popupTitle == "Loved" {
                                Text("We'll recommend more like this in Listen Now.")
                                    .font(.system(size: 16.5, weight: .regular))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                            }
                        }
                        
                    }//: VSTACK
                    .padding([.top, .bottom], 32.5)
                    .padding([.leading, .trailing], 20)
                }//: OVERLAY
                .opacity(animateContextMenuActionPopup ? 1.0: 0.15)
                .scaleEffect(scale)
                .frame(width: (size?.width ?? 300), height: (size?.height ?? 350), alignment: .center)
        })//: ZSTACK
        .onAppear {
            
            withAnimation(.easeInOut(duration: 0.4)) {
                scale = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                
                if popupTitle == "Added to Library" {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                }
                
                withAnimation(.easeInOut(duration: 0.4)) {
                    showCheckmark = 0
                }
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                withAnimation(.easeInOut(duration: 0.4)) {
                    animateContextMenuActionPopup = false
                }
                
            })
        }//: ONAPPEAR
    }
}
