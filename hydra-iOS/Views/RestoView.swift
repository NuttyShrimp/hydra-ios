//
//  RestoVIew.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 13/10/2024.
//

import SwiftUI

struct RestoView: View {
    @ObservedObject var restos: Restos
    @State var selectedIndex = 0

    init(restos: Restos) {
        self.restos = restos
    }

    var body: some View {
        VStack {
            mealTabs
        }.navigationTitle(restos.selectedRestoMeta?.name ?? "Resto's")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    selectionMenu
                }
            }
            .task {
                await restos.loadAvailableRestos()
            }
    }

    // Tab header from: https://www.appcoda.com/swiftui-custom-tab-bar
    var mealTabs: some View {
        ZStack(alignment: .top) {
            TabView(selection: $selectedIndex) {
                var tabs = $restos.mealBarTabs
                ForEach(tabs.indices, id: \.self) { index in
                    if index == 0 {
                        legend
                            .tag(index)
                    } else {
                        ZStack(alignment: .top) {
                            if let menu = restos.selectedRestoMenu {
                                SingleDayRestoMenu(menu: menu)
                            } else {
                                Text("No menu available")
                            }
                        }
                        .tag(index)
                    }
                }
            }
            .ignoresSafeArea()

            TabBarView(
                tabbarItems: restos.mealBarTabs,
                selectedIndex: $selectedIndex
            )
            .padding(.horizontal)
        }
    }

    var selectionMenu: some View {
        Menu(
            content: {
                ForEach(Array(restos.restoMetas.enumerated()), id: \.offset) {
                    index, restoMeta in
                    Button(action: {
                        restos.selectResto(index)
                    }) {
                        Text(restoMeta.name)
                    }
                }
            }, label: { Image(systemName: "mappin") })

    }

    var legend: some View {
        Text("Legende")
    }
    var dayView: some View {
        Text("Day")
    }
}

struct TabbarItem: View {
    var name: String
    var isActive: Bool = false
    let namespace: Namespace.ID

    var body: some View {
        if isActive {
            Text(name)
                .font(.subheadline)
                .padding(.horizontal)
                .padding(.vertical, 4)
                .foregroundColor(.white)
                .background(Capsule().foregroundColor(.accent))
                .matchedGeometryEffect(id: "highlightmenuitem", in: namespace)
        } else {
            Text(name)
                .font(.subheadline)
                .padding(.horizontal)
                .padding(.vertical, 4)
                .foregroundColor(.black)
        }

    }
}

struct TabBarView: View {
    var tabbarItems: [String]

    @Binding var selectedIndex: Int
    @Namespace private var menuItemTransition

    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(tabbarItems.indices, id: \.self) { index in
                        TabbarItem(
                            name: tabbarItems[index],
                            isActive: selectedIndex == index,
                            namespace: menuItemTransition
                        )
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                selectedIndex = index
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(25)
            .onChange(of: selectedIndex) { index in
                withAnimation {
                    scrollView.scrollTo(index, anchor: .center)
                }
            }

        }

    }
}
