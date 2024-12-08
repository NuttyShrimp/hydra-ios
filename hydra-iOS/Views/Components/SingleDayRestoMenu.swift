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

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if let message = menu.message {
                Text(message)
            } else if !menu.open {
                closedMessage
            }
            if menu.open {
                hotMeals
                coldMeals
                soup
                vegetables
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

    var body: some View {
        if meals.count > 0 {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                ForEach(meals, id: \.name) { meal in
                    HStack(spacing: 5) {
                        MealIcon(kind: meal.kind)
                        Text(meal.name)
                    }
                }
            }
        }
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
