//
//  RestoVIew.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 13/10/2024.
//

import SwiftUI

struct RestoView: View {
    @ObservedObject var restos: Restos

    var body: some View {
        mealTabs
            .navigationTitle(restos.selectedRestoMeta?.name ?? "Resto's")
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
        VStack {
            TabBarView(
                tabbarItems: restos.mealBarTabs,
                selectedIndex: $restos.selectedDate
            )

            TabView(selection: $restos.selectedDate) {
                var tabs = $restos.mealBarTabs
                ForEach(tabs.indices, id: \.self) { index in
                    ZStack(alignment: .top) {
                        if index == 0 {
                            legend
                        } else if let menu = restos.selectedRestoMenu {
                            SingleDayRestoMenu(menu: menu)
                        } else {
                            Text("No menu available")
                        }
                    }
                    .frame(
                        minWidth: 0, maxWidth: .infinity, minHeight: 0,
                        maxHeight: .infinity, alignment: .topLeading)
                    .tag(index - 1)
                }
            }.padding(.horizontal)
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

    var legend: some View {
        VStack(alignment: .leading) {
            ForEach(RestoMealKind.allCases, id: \.self) { kind in
                HStack(spacing: 5) {
                    MealIcon(kind: kind)
                        .frame(width: 30, height: 30)
                        .scaleEffect(1.5)
                    Text(kind.toString())
                }
                .font(.system(size: 20))
            }
        }
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
                            isActive: selectedIndex == (index - 1),
                            namespace: menuItemTransition
                        )
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                selectedIndex = (index - 1)
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
