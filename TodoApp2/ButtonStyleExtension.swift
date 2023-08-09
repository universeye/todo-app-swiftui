//
//  ButtonStyleExtension.swift
//  TodoApp2
//
//  Created by Terry Kuo on 2023/8/9.
//

import SwiftUI

struct ToolBarButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .bold()
            .padding(10)
            .foregroundColor(.gray)
            .background(Color(uiColor: .systemGray5))
            .clipShape(Circle())
    }
}

extension ButtonStyle where Self == ToolBarButton {
    static var toolBarButton: ToolBarButton { .init() }
}
