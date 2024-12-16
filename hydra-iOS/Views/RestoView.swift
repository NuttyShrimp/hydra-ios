//
//  RestoVIew.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 13/10/2024.
//

import LucideIcons
import SwiftUI

enum RestoNavigationOptions {
    case extraMenus, locations

    func toString() -> String {
        switch self {
        case .extraMenus:
            return "Overige menu's"
        case .locations:
            return "Locaties"
        }
    }

}

struct RestoView: View {
    @ObservedObject var restos: RestoDocument
    @StateObject var additionalResto = AdditionalResto()

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
                HStack {
                    NavigationLink(value: RestoNavigationOptions.extraMenus) {
                        Label(
                            title: {
                                Text(
                                    RestoNavigationOptions.extraMenus.toString()
                                )
                            },
                            icon: {
                                Image(uiImage: Lucide.sandwich.withRenderingMode(.alwaysTemplate))
                            })
                    }
                    NavigationLink(value: RestoNavigationOptions.locations) {
                        Label(
                            title: {
                                Text(
                                    RestoNavigationOptions.locations.toString())
                            },
                            icon: { Image(systemName: "map") })
                    }
                }
            }, label: { Image(systemName: "ellipsis") }
        )
        .navigationDestination(for: RestoNavigationOptions.self) { option in
            ZStack {
                switch option {
                case .extraMenus:
                    OtherFoodMenuView(additionalResto: additionalResto)
                case .locations:
                    RestoLocations(restos: restos)
                }
            }
            .navigationTitle(option.toString().capitalized)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
