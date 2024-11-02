//
//  DSAActivity.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 29/10/2024.
//

import SwiftUI

struct DSAActivityView: View {
    let event: DSAEvent
    let association: Association

    init(_ event: DSAEvent, _ organiser: Association) {
        self.event = event
        self.association = organiser
    }

    var body: some View {
        Button(action: {
            debugPrint("abc")
        }) {
            HStack {
                VStack(alignment: .leading) {
                    Text(event.title)
                    if event.startTime < Date.now && event.endTime != nil {
                        Text(event.endTime!.ISO8601Format())
                    } else {
                        Text(event.startTime.ISO8601Format())
                    }
                }
                Spacer()
                if association.logo != nil {
                    AsyncImage(url: association.logo) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 75, maxHeight: 75)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 50, height: 50)
                    }
                }
            }
            .modifier(
                Eventify(
                    eventType: .DSA, startDate: event.startTime,
                    endDate: event.endTime)
            )
            .padding()
        }
        .foregroundStyle(Color(UIColor.label))
    }
}

//#Preview {
//    DSAActivityView()
//}
