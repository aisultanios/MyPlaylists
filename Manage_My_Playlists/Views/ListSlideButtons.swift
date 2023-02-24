//
//  ListSlideButtons.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 30.01.2023.
//

import SwiftUI

let buttonWidth: CGFloat = 75

enum CellButtons: Identifiable {
    
    case playNext
    case playLast
    case addToPlaylist
    
    var id: String {
        return "\(self)"
    }
}

struct CellButtonView: View {
    let data: CellButtons
    let cellHeight: CGFloat
    
    func getView(for image: String, imageColor: Color) -> some View {
        VStack {
            Image(systemName: image)
                .font(.system(size: 23.0))
        }
        .foregroundColor(imageColor)
        .frame(width: buttonWidth, height: cellHeight)
    }
    
    var body: some View {
        switch data {
        case .playNext:
            getView(for: "text.line.first.and.arrowtriangle.forward", imageColor: .white)
                .background(.purple)
        case .playLast:
            getView(for: "text.line.last.and.arrowtriangle.forward", imageColor: .white)
                .background(.orange)
        case .addToPlaylist:
            getView(for: "plus", imageColor: .pink)
                .background(.gray.opacity(0.175))
        }
    }
}

struct SwipeContainerCell: ViewModifier  {
    enum VisibleButton {
        case none
        case left
        case right
    }
    @State private var offset: CGFloat = 0
    @State private var oldOffset: CGFloat = 0
    @State private var visibleButton: VisibleButton = .none
    let leadingButtons: [CellButtons]
    let trailingButton: [CellButtons]
    let maxLeadingOffset: CGFloat
    let minTrailingOffset: CGFloat
    let onClick: (CellButtons) -> Void
    
    init(leadingButtons: [CellButtons], trailingButton: [CellButtons], onClick: @escaping (CellButtons) -> Void) {
        self.leadingButtons = leadingButtons
        self.trailingButton = trailingButton
        maxLeadingOffset = CGFloat(leadingButtons.count) * buttonWidth
        minTrailingOffset = CGFloat(trailingButton.count) * buttonWidth * -1
        self.onClick = onClick
    }
    
    func reset() {
        visibleButton = .none
        offset = 0
        oldOffset = 0
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .contentShape(Rectangle()) ///otherwise swipe won't work in vacant area
        .offset(x: offset)
        .gesture(DragGesture(minimumDistance: 15, coordinateSpace: .local)
        .onChanged({ (value) in
            let totalSlide = value.translation.width + oldOffset
            if  (0...Int(maxLeadingOffset) ~= Int(totalSlide)) || (Int(minTrailingOffset)...0 ~= Int(totalSlide)) { //left to right slide
                withAnimation{
                    offset = totalSlide
                }
            }
            ///can update this logic to set single button action with filled single button background if scrolled more then buttons width
        })
        .onEnded({ value in
            withAnimation {
              if visibleButton == .left && value.translation.width < -20 { ///user dismisses left buttons
                reset()
             } else if  visibleButton == .right && value.translation.width > 20 { ///user dismisses right buttons
                reset()
             } else if offset > 25 || offset < -25 { ///scroller more then 50% show button
                if offset > 0 {
                    visibleButton = .left
                    offset = maxLeadingOffset
                } else {
                    visibleButton = .right
                    offset = minTrailingOffset
                }
                oldOffset = offset
                ///Bonus Handling -> set action if user swipe more then x px
            } else {
                reset()
            }
         }
        }))
            GeometryReader { proxy in
                HStack(spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(leadingButtons) { buttonsData in
                        Button(action: {
                            withAnimation {
                                reset()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) { ///call once hide animation done
                                onClick(buttonsData)
                            }
                        }, label: {
                            CellButtonView.init(data: buttonsData, cellHeight: proxy.size.height)
                        })
                    }
                }.offset(x: (-1 * maxLeadingOffset) + offset)
                Spacer()
                HStack(spacing: 0) {
                    ForEach(trailingButton) { buttonsData in
                        Button(action: {
                            withAnimation {
                                reset()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) { ///call once hide animation done
                                onClick(buttonsData)
                            }
                        }, label: {
                            CellButtonView.init(data: buttonsData, cellHeight: proxy.size.height)
                        })
                    }
                }.offset(x: (-1 * minTrailingOffset) + offset)
            }
        }
        }
    }
}
