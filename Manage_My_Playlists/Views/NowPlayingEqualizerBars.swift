//
//  NowPlayingEqualizerBars.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 16.02.2023.
//

import SwiftUI

private let numBars = 4
private let spacerWidthRation: CGFloat = 0.6
private let barWidthScaleFactor = 1 / (CGFloat(numBars) + CGFloat(numBars - 1) * spacerWidthRation)

struct NowPlayingEqualizerBars: View {
    
    @State private var animating = false
    @Binding var isPlaying: Bool
    
    var body: some View {
        GeometryReader { geo in
            let barWidth = geo.size.width * barWidthScaleFactor
            let spacerWidth = barWidth * spacerWidthRation
            HStack(spacing: spacerWidth) {
                ForEach(0..<4) { index in
                    Bar(minHeightFraction: 0.1, maxHeightFraction: 1, completion: animating ? 0.5: 0)
                        .fill(.white)
                        .frame(width: barWidth)
                        .animation(createAnimation(), value: animating)
                }
            }//: HSTACK
            .onAppear {
                animating = true
            }//: ONAPPEAR
            .onChange(of: isPlaying) { newValue in
                animating = newValue
            }//: ONCHANGE
        }//: GEOMETRYREADER
    }
    
    //Creating up and down bar animation
    private func createAnimation() -> Animation {
        Animation
            .easeInOut(duration: 0.5 + Double.random(in: -0.2...0.2))
            .repeatForever(autoreverses: true)
            .delay(Double.random(in: 0...0.55)) //delaying it so that each bar gets an indvidual animation
    }
    
}

//CUSTOM SHAPE
private struct Bar: Shape {
    
    private let minHeightFraction: CGFloat
    private let maxHeightFraction: CGFloat
    var animatableData: CGFloat
    
    init(minHeightFraction: CGFloat, maxHeightFraction: CGFloat, completion: CGFloat) {
        self.minHeightFraction = minHeightFraction
        self.maxHeightFraction = maxHeightFraction
        self.animatableData = completion
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let heightFractionDelta = maxHeightFraction - minHeightFraction
        let heightFraction = minHeightFraction + heightFractionDelta * animatableData
        
        let rectHeight = rect.height * heightFraction
        
        let rectOrigin = CGPoint(x: rect.minX, y: rect.maxY - rectHeight)
        let rectSize = CGSize(width: rect.width, height: rectHeight)
        
        let barRect = CGRect(origin: rectOrigin, size: rectSize)
        
        path.addRect(barRect)
        
        return path
    }
    
}

