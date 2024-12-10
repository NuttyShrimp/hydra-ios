//
//  RestoVIew.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 13/10/2024.
//

import LucideIcons
import SwiftUI

enum RestoNavigationOptions: String {
    case sandwiches, salades, locations

}

struct RestoView: View {
    @ObservedObject var restos: Restos

    var body: some View {
        NavigationStack {
            RestoMenuView(restos: restos)
                .navigationTitle(restos.selectedRestoMeta?.name ?? "Resto's")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        selectionMenu
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        otherMenu
                    }
                }
        }
        .task {
            await restos.loadAvailableRestos()
        }
    }

    var selectionMenu: some View {
        Menu(
            content: {
                ForEach(restos.restoMetas.indices, id: \.self) { index in
                    Button(action: {
                        restos.selectResto(index)
                    }) {
                        Text(restos.restoMetas[index].name)
                    }
                }
            }, label: { Image(systemName: "mappin") })

    }

    var otherMenu: some View {
        Menu(
            content: {
                NavigationLink(value: RestoNavigationOptions.sandwiches) {
                    Label(
                        title: { Text("Sandwiches") },
                        icon: { Image(uiImage: Lucide.sandwich) })
                }
            }, label: { Image(systemName: "ellipsis") }
        )
        .navigationDestination(for: RestoNavigationOptions.self) { option in
            ZStack {
                switch (option) {
                case .sandwiches:
                    SandwichesView(restos: restos)
                default:
                    Text("TODO")
                }
            }
            .navigationTitle(option.rawValue.capitalized)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
