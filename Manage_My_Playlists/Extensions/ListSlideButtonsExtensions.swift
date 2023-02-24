//
//  contentMenuPreview.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 28.01.2023.
//

import SwiftUI

extension View {
    func addButtonActions(leadingButtons: [CellButtons], trailingButton: [CellButtons], onClick: @escaping (CellButtons) -> Void) -> some View {
        self.modifier(SwipeContainerCell(leadingButtons: leadingButtons, trailingButton: trailingButton, onClick: onClick))
    }
}
