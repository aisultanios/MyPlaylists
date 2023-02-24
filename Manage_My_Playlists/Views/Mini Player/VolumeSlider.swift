//
//  VolumeSlider.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 13.02.2023.
//

import SwiftUI

struct VolumeSlider<T: BinaryFloatingPoint>: View {
    // The current value of the VolumeSlider, bound to an external value.
    @Binding var value: T

    // The closed range of valid values for the VolumeSlider.
    let inRange: ClosedRange<T>

    // The color to fill the VolumeSlider when it is actively being edited.
    let activeFillColor: Color

    // The color to fill the VolumeSlider when it is not being edited.
    let fillColor: Color

    // The color to fill the VolumeSlider when it has no value.
    let emptyColor: Color

    // The height of the VolumeSlider.
    let height: CGFloat

    // A closure that is called when the VolumeSlider's editing state changes.
    let onEditingChanged: (Bool) -> Void

    // Private variables for local progress tracking.
    @State private var localRealProgress: T = 0
    @State private var localTempProgress: T = 0
    @GestureState private var isActive: Bool = false

    // The body of the VolumeSlider view, defined using a GeometryReader and ZStack.
    var body: some View {
        GeometryReader { bounds in
            ZStack {
                // An HStack containing the speaker icons and the Capsule progress bar.
                HStack {
                    Image(systemName: "speaker.fill")
                        .font(.system(size: 15, weight: .regular, design: .default))
                        .foregroundColor(isActive ? activeFillColor : fillColor)
                    
                    GeometryReader { geo in
                        //PROGRESS BAR
                        ZStack(alignment: .center) {
                            Capsule()
                                .fill(emptyColor)
                            Capsule()
                                .fill(isActive ? activeFillColor : fillColor)
                                .mask({
                                    HStack {
                                        Rectangle()
                                            .frame(width: max(geo.size.width * CGFloat((localRealProgress + localTempProgress)), 0), alignment: .leading)
                                        Spacer(minLength: 0)
                                    }
                                })
                        }//: ZSTACK
                    }//: GEOMETRYREADER
                    
                    Image(systemName: "speaker.wave.3.fill")
                        .font(.system(size: 15, weight: .regular, design: .default))
                        .foregroundColor(isActive ? activeFillColor : fillColor)
                }//: HSTACK
                .frame(width: isActive ? bounds.size.width * 1.04 : bounds.size.width, alignment: .center)
                .animation(animation, value: isActive)
            }//: ZSTACK
            // Set the frame of the ZStack to match the bounds of the GeometryReader.
            .frame(width: bounds.size.width, height: bounds.size.height, alignment: .center)
            // Add a DragGesture to the ZStack to enable the VolumeSlider to be dragged.
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .updating($isActive) { value, state, transaction in
                    state = true
                }
                .onChanged { gesture in
                    // Update the temporary progress based on the drag gesture.
                    localTempProgress = T(gesture.translation.width / bounds.size.width)
                    // Update the external value based on the temporary progress.
                    value = max(min(getPrgValue(), inRange.upperBound), inRange.lowerBound)
                }
                .onEnded { value in
                    // Update the real progress based on the temporary progress.
                    localRealProgress = max(min(localRealProgress + localTempProgress, 1), 0)
                    localTempProgress = 0
                })//: GESTURES
            // Call onChange when the editing state of the VolumeSlider changes.
            .onChange(of: isActive) { newValue in
                // Update the external value based on the temporary progress.
                value = max(min(getPrgValue(), inRange.upperBound), inRange.lowerBound)
                onEditingChanged(newValue)
            }//: ONCHANGE
            .onAppear {
                // Update the real progress based on the progress
                localRealProgress = getPrgPercentage(value)
            }//: ONAPPEAR
            .onChange(of: value) { newValue in
                if !isActive {
                    // Update the real progress based on the drag gesture.
                    localRealProgress = getPrgPercentage(newValue)
                }
            }//: ONCHANGE
        }//: GEOMETRYREADER
        .frame(height: isActive ? height * 2 : height, alignment: .center)
    }
    
    //spring animations when engaged and disengaged
    private var animation: Animation {
        if isActive {
            return .spring()
        } else {
            return .spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.6)
        }
    }
    
    //calculates the percentage of a given value relative to the minimum and maximum values of a specified range.
    private func getPrgPercentage(_ value: T) -> T {
        let range = inRange.upperBound - inRange.lowerBound
        let correctedStartValue = value - inRange.lowerBound
        let percentage = correctedStartValue / range
        return percentage
    }
    
    //calculates and returns the slider's current value based on its progress percentage.
    private func getPrgValue() -> T {
        return ((localRealProgress + localTempProgress) * (inRange.upperBound - inRange.lowerBound)) + inRange.lowerBound
    }
}

