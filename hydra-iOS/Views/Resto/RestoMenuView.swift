//
//  Menu.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 10/12/2024.
//

import SwiftUI

struct RestoMenuView: View {
    @ObservedObject var restos: RestoDocument
    
    // Tab header from: https://www.appcoda.com/swiftui-custom-tab-bar
    var body: some View {
        VStack {
            HScrollNavbar(
                tabbarItems: restos.mealBarTabs,
                selectedIndex: $restos.selectedDate
            )

            TabView(selection: $restos.selectedDate) {
                let tabs = $restos.mealBarTabs
                ForEach(tabs.indices, id: \.self) { index in
                    RestoMenuTabItemView(index: index, restos: restos)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

struct RestoMenuTabItemView: View {
    var index: Int
    @ObservedObject var restos: RestoDocument
    
    var body: some View {
        ZStack(alignment: .top) {
            if index == 0 {
                legend
                .padding(.horizontal)
            } else if let menu = restos.getMenuForDay(day: index-1) {
                SingleDayRestoMenu(menu: menu)
                    .padding(.vertical, 0)
            } else {
                Text("No menu available")
            }
        }
        .frame(
            minWidth: 0, maxWidth: .infinity, minHeight: 0,
            maxHeight: .infinity, alignment: .topLeading
        )
        .tag(index - 1)
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
