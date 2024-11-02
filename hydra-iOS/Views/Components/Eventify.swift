//
//  NewsEntryView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 02/11/2024.
//

import SwiftUI

struct Eventify: ViewModifier {
    var type: EventType
    var startDate: Date
    var endDate: Date? = nil
    var dateFormatter = RelativeDateTimeFormatter()

    init(eventType type: EventType, startDate: Date) {
        self.type = type
        self.startDate = startDate
    }

    init(eventType type: EventType, startDate: Date, endDate: Date?) {
        self.type = type
        self.startDate = startDate
        self.endDate = endDate
    }

    func body(content: Content) -> some View {
        VStack {
            HStack {
                switch type {
                case .UGent: UGentHeader
                case .DSA: DSAHeader
                default: Text("Unconfigured header")
                }
                Spacer()
            }
            .font(.system(size: Constants.FontSize.header))
            Spacer()
            content
                .font(.system(size: Constants.FontSize.content))
            Spacer()
            HStack {
                Text(
                    dateFormatter.localizedString(
                        for: startDate, relativeTo: Date.now))
                if endDate != nil {
                    Text(
                        "tot \(dateFormatter.localizedString(for: endDate!, relativeTo: Date.now))"
                    )
                }
                Spacer()
            }
            .font(.system(size: Constants.FontSize.date))
        }
    }

    var UGentHeader: some View {
        HStack {
            Image(systemName: "newspaper.fill")
                .foregroundStyle(.accent)
            Text("Nieuws artikel")
        }
    }

    var DSAHeader: some View {
        HStack {
            Image(systemName: "calendar")
                .foregroundStyle(.accent)
            Text("Activiteit")
        }
    }

    private struct Constants {
        struct FontSize {
            static let header: CGFloat = 14
            static let date: CGFloat = 16
            static let content: CGFloat = 22
        }
    }
}

enum EventType {
    case UGent, DSA, Schamper
}
