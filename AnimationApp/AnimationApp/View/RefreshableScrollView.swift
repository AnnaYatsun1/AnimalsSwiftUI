//
//  RefreshableScrollView.swift
//  AnimationApp
//
//  Created by Анна Яцун on 16.01.2025.
//
import SwiftUI

struct RefreshableScrollView<Content: View>: View {
    let action: () async -> Void
    let content: Content

    init(action: @escaping () async -> Void, @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
    }

    var body: some View {
        ScrollView {
            VStack {
                content
            }
            .refreshable {
                await action()
            }
        }
    }
}
