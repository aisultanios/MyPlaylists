//
//  MusicSlider.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 13.02.2023.
//

import SwiftUI

struct MusicProgressSlider<T: BinaryFloatingPoint>: View {
    
    // value represents current playback time
    @Binding var value: T
    
    let inRange: ClosedRange<T>
    
    //colors for the slider.
    let activeFillColor: Color
    let fillColor: Color
    let emptyColor: Color
    
    //height of the slider.
    let height: CGFloat
    
    //called when editing starts or ends.
    let onEditingChanged: (Bool) -> Void
    
    //private state variables.
    @State private var localRealProgress: T = 0
    @State private var localTempProgress: T = 0
    @GestureState private var isActive: Bool = false
    @State private var progressDuration: T = 0
    @State private var editedValue: T?
    
    init(
        value: Binding<T>,
        inRange: ClosedRange<T>,
        activeFillColor: Color,
        fillColor: Color,
        emptyColor: Color,
        height: CGFloat,
        onEditingChanged: @escaping (Bool) -> Void
    ) {
        self._value = value
        self.inRange = inRange
        self.activeFillColor = activeFillColor
        self.fillColor = fillColor
        self.emptyColor = emptyColor
        self.height = height
        self.onEditingChanged = onEditingChanged
    }
    
    var body: some View {
        GeometryReader { bounds in
            
            ZStack {
                VStack(spacing: 12.5) {
                    //Progress Bar
                    ZStack(alignment: .center) {
                        
                        Capsule()
                            .fill(emptyColor)
                        
                        Capsule()
                            .fill(isActive ? activeFillColor : fillColor)
                            .mask({
                                HStack {
                                    Rectangle()
                                        .frame(width: max(bounds.size.width * CGFloat((localRealProgress + localTempProgress)), 0), alignment: .leading)
                                    Spacer(minLength: 0)
                                }
                            })
                    }//: ZSTACK
                    
                    //Progress Time
                    HStack {
                        Text(progressDuration.asTimeString(style: .positional))
                        Spacer(minLength: 0)
                        Text("-" + (inRange.upperBound - progressDuration).asTimeString(style: .positional))
                    }//: HSTACK
                    .font(.system(size: 10.75, weight: .medium, design: .rounded))
                    .monospacedDigit()
                    .foregroundColor(isActive ? .white : emptyColor)
                }//: VSTACK
                .frame(width: isActive ? bounds.size.width * 1.04 : bounds.size.width, alignment: .center)
                
                // Apply an animation to the slider when it's being edited.
                .animation(animation, value: isActive)
            }//: ZSTACK
            .frame(width: bounds.size.width, height: bounds.size.height, alignment: .center)
            
            // Add a gesture to the slider to allow dragging to change the value.
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .updating($isActive) { value, state, transaction in
                    state = true
                }
                .onChanged { gesture in
                    localTempProgress = T(gesture.translation.width / bounds.size.width)
                    let prg = max(min((localRealProgress + localTempProgress), 1), 0)
                    progressDuration = inRange.upperBound * prg
                    value = max(min(getPrgValue(), inRange.upperBound), inRange.lowerBound)
                    editedValue = max(min(getPrgValue(), inRange.upperBound), inRange.lowerBound)
                }.onEnded { value1 in
                    localRealProgress = max(min(localRealProgress + localTempProgress, 1), 0)
                    localTempProgress = 0
                    progressDuration = inRange.upperBound * localRealProgress
                    value = editedValue ?? value
                    editedValue = nil

                })//: GESTURES
            .onChange(of: isActive) { newValue in
                // Update the external value based on the temporary progress.
                value = max(min(getPrgValue(), inRange.upperBound), inRange.lowerBound)
                editedValue = max(min(getPrgValue(), inRange.upperBound), inRange.lowerBound)
                onEditingChanged(newValue)
            }//: ONCHANGE
            .onAppear {
                // Update the real progress based on the progress
                localRealProgress = getPrgPercentage(value)
                progressDuration = inRange.upperBound * localRealProgress
            }//: ONAPPEAR
            .onChange(of: value) { newValue in
                if !isActive {
                    // Update the real progress based on the drag gesture.
                    localRealProgress = getPrgPercentage(newValue)
                    progressDuration = inRange.upperBound * localRealProgress
                }
            }//: ONCHANGE
        }//: GEOMETRYREADER
        .frame(height: isActive ? height * 1.25 : height, alignment: .center)
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

