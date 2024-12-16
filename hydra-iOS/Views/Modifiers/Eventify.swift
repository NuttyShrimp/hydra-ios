//
//  NewsEntryView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 02/11/2024.
//

import SwiftUI

struct Eventify: ViewModifier {
    var event: any Eventable
    var startDate: Date
    var endDate: Date? = nil
    var dateFormatter = RelativeDateTimeFormatter()

    init(event: any Eventable, startDate: Date) {
        self.event = event
        self.startDate = startDate
    }

    init(event: any Eventable, startDate: Date, endDate: Date?) {
        self.event = event
        self.startDate = startDate
        self.endDate = endDate
    }

    func body(content: Content) -> some View {
        VStack {
            if Configuration.EventFeedShowPriority {
                Text("Priority: \(event.priority())")
            }
            HStack {
                switch event.type {
                case .UGent: UGentHeader
                case .DSA: DSAHeader
                case .SpecialEvent: SpecialEventHeader
                default: Text("Unconfigured header")
                }
                Spacer()
            }
            .font(.system(size: Constants.FontSize.header))
            Spacer()
            content
                .font(.system(size: Constants.FontSize.content, weight: .bold))
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
    
    var SpecialEventHeader: some View {
        HStack {
            Image(systemName: "exclamationmark.bubble.fill")
                .foregroundStyle(.accent)
            Text("Mededeling")
        }
    }
    
    private struct Constants {
        struct FontSize {
            static let header: CGFloat = 14
            static let date: CGFloat = 16
            static let content: CGFloat = 20
        }
    }
}

enum EventType {
    case UGent, DSA, Schamper, SpecialEvent
}
