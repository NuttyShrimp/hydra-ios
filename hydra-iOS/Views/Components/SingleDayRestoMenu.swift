//
//  SingleDayRestoMenu.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 07/12/2024.
//

import LucideIcons
import SwiftUI

struct SingleDayRestoMenu: View {
    var menu: RestoMenu
    @Environment(\.openURL) var openURL
    @AppStorage("showAllergens") var showAllergens: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if let message = menu.message {
                Text(message)
            } else if !menu.open {
                closedMessage
            }
            if menu.open {
                List {
                    hotMeals
                    coldMeals
                    soup
                    vegetables

                }
                .scrollContentBackground(.hidden)
                .background(Color(.systemGray6))
            }
        }
    }

    var closedMessage: some View {
        VStack {
            Text(
                "De resto is waarschijnlijk gesloten. Controleer voor de zekerheid de"
            )
            Button(
                action: {
                    openURL(Constants.restoURL)
                },
                label: {
                    Text("website")
                })
        }
    }

    var hotMeals: some View {
        MealSection(title: "Warme maaltijden", meals: menu.hotMeals())
    }

    var coldMeals: some View {
        MealSection(title: "Koude maaltijden", meals: menu.coldMeals())
    }

    var soup: some View {
        MealSection(title: "Soep", meals: menu.soups())
    }

    var vegetables: some View {
        MealSection(title: "Groenten", meals: menu.vegetables)
    }

    struct Constants {
        static let restoURL = URL(
            string: "https://www.ugent.be/student/nl/meer-dan-studeren/resto")!
    }
}

struct MealSection: View {
    var title: String
    var meals: [RestoMeal]
    @AppStorage("showAllergens") var showAllergens: Bool = false

    var body: some View {
        if meals.count > 0 {
            Section(header: Text(title).font(.system(size: 16).bold())) {
                ForEach(meals, id: \.name) { meal in
                    // This is a small hack to force the MealView to be rerendered when the allergen setting changes
                    if $showAllergens.wrappedValue {
                        MealView(meal, showAllergens: true)
                    } else {
                        MealView(meal, showAllergens: false)
                    }
                }
            }
            .listRowBackground(Color(.systemGray5))
        }
    }
}

struct MealView: View {
    var meal: RestoMeal
    @State private var isExpanded: Bool
    
    init(_ meal: RestoMeal, showAllergens isExpanded: Bool) {
        self.meal = meal
        self.isExpanded = isExpanded
    }
    
    
    var body: some View {
        if meal.allergens.isEmpty {
            basicInfo
        } else {
            allergensGroup
        }
    }
    
    var basicInfo: some View {
        HStack(spacing: 5) {
            MealIcon(kind: meal.kind)
            Text(meal.name)
            Spacer()
            if let price = meal.price {
                Text(price)
            }
        }
    }
    
    var allergensGroup: some View {
        DisclosureGroup(isExpanded: $isExpanded, content: {
            Text(meal.allergens.joined(separator: ", "))
                .font(.system(size: Constants.allergenFontSize))
        }, label: {
            basicInfo
        })
        .disclosureGroupStyle(.plain)
    }
    
    struct Constants {
        static let allergenFontSize: CGFloat = 14
    }
}

struct MealIcon: View {
    let kind: RestoMealKind

    var body: some View {
        switch kind {
        case .meat:
            Image(uiImage: Lucide.beef)
                .renderingMode(.template)
                .foregroundColor(Color(red: 0.886, green: 0.149, blue: 0.137))
        case .fish:
            Image(uiImage: Lucide.fishSymbol)
                .renderingMode(.template)
                .foregroundColor(Color(red: 0.549, green: 0.549, blue: 0.549))
        case .soup:
            Image(uiImage: Lucide.soup)
                .renderingMode(.template)
                .foregroundColor(Color(red: 0.965, green: 0.608, blue: 0.302))
        case .vegetarian:
            Image(uiImage: Lucide.salad)
                .renderingMode(.template)
                .foregroundColor(Color(red: 0.118, green: 0.498, blue: 0.137))
        case .vegan:
            Image(uiImage: Lucide.vegan)
                .renderingMode(.template)
                .foregroundColor(Color(red: 0.318, green: 0.655, blue: 0.278))
        }
    }
}
