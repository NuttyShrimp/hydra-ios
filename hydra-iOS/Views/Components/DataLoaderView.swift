//
//  DataLoaderView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 30/12/2024.
//

import SwiftUI

typealias Fetcher = () async -> Void

struct DataLoaderView<T, Content: View, Label: View>: View {
    @State var initialLoad = false

    var state: HydraDataFetch<T>
    let fetcher: Fetcher
    let content: (T) -> Content
    let label: () -> Label

    init(
        _ state: HydraDataFetch<T>, fetcher: @escaping Fetcher,
        @ViewBuilder content: @escaping (T) -> Content
    ) where Label == EmptyView {
        self.state = state
        self.fetcher = fetcher
        self.content = content
        self.label = { EmptyView() }
    }

    init(
        _ state: HydraDataFetch<T>, fetcher: @escaping Fetcher,
        @ViewBuilder label: @escaping () -> Label, @ViewBuilder content: @escaping (T) -> Content
    ) {
        self.state = state
        self.fetcher = fetcher
        self.content = content
        self.label = label
    }

    var body: some View {
        ZStack {
            switch state {
            case .fetching, .idle:
                ProgressView(label: label)
            case .success(let data):
                content(data)
            case .failure(let error):
                VStack {
                    Text("Error loading data")
                    Text(error.localizedDescription)
                }
            }
        }
        .task {
            guard !initialLoad else { return }
            initialLoad = true
            await fetcher()
        }

    }
}
