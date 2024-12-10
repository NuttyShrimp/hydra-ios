//
//  Sandwiches.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 10/12/2024.
//

import SwiftUI

struct SandwichesView: View {
    @ObservedObject var restos: Restos

    var body: some View {
        VStack(spacing: 5) {
            let sandwiches = restos.availableSandwiches
            ForEach(sandwiches) { sandwich in
                SandwichView(sandwich: sandwich)
            }
            Spacer()
        }
        .padding(.horizontal)
        .task {
            await restos.loadSandwiches()
        }
    }
}

struct SandwichView: View {
    var sandwich: RestoSandwich
    @State var isExpanded: Bool = false

    var body: some View {
        VStack {
            HStack {
                Text(sandwich.name)
                    .font(.headline)
                Spacer()
                Text("€" + sandwich.price)
            }
            HStack {
                Text(sandwich.ingredients.joined(separator: ", "))
                Spacer()
            }
            .frame(minHeight: 0, maxHeight: isExpanded ? .none : 0)
            .clipped()
            .animation(.smooth, value: isExpanded)
            .transition(.slide)
            Divider()
        }
        .onTapGesture {
            withAnimation{
                isExpanded.toggle()
            }
        }
    }
}

#Preview {
    SandwichesView(restos: Restos())
}
