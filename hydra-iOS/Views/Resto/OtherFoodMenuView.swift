//
//  Sandwiches.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 10/12/2024.
//

import SwiftUI

struct OtherFoodMenuView: View {
    @ObservedObject var additionalResto: AdditionalResto

    var body: some View {
        VStack(spacing: 5) {
            List {
                ForEach(additionalResto.availableItems.elements, id: \.key) { key, value in
                    if (value.count > 0) {
                        OtherMenuSectionView(title: key, menuItems: value)
                    }
                }
            }
        }
        .task {
            await additionalResto.loadAllInfo()
        }
    }
}

struct OtherMenuSectionView: View {
    var title: String
    var menuItems: [OtherMenuItem]
    
    var body: some View {
        Section(header: Text(title).font(.system(size: 16).bold())) {
            ForEach(menuItems) { item in
                OtherMenuItemView(menuItem: item)
            }
        }
    }
}

struct OtherMenuItemView: View {
    var menuItem: OtherMenuItem
    @State var isExpanded: Bool = false

    // TODO: for some reason is the text box smaller when collapsed
    var body: some View {
        DisclosureGroup(content: {
            if let description = menuItem.description {
                HStack {
                    Text(description)
                    Spacer()
                }
            }
        }, label: {
            HStack {
                Text(menuItem.name)
                    .font(.headline)
                Spacer()
                Text("€" + menuItem.price)
            }
        })
        .disclosureGroupStyle(.plain)
    }
}

#Preview {
    OtherFoodMenuView(additionalResto: AdditionalResto())
}
