//
//  OnboardingNewsFeed.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 22/12/2024.
//

import SwiftUI

struct OnboardingNewsFeed: View {
    @AppStorage("finishedOnboarding") var finishedOnboarding = false

    var body: some View {
        VStack {
            Button(
                action: {
                    finishedOnboarding = true
                },
                label: {
                    HStack {
                        Spacer()
                        Label("Ga naar de app", systemImage: "flag.pattern.checkered")
                        Spacer()
                    }
                    .padding(.vertical, Constants.btnPadding)
                }
            )
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    struct Constants {
        static let btnPadding: CGFloat = 7
    }
}

#Preview {
    OnboardingNewsFeed()
}
