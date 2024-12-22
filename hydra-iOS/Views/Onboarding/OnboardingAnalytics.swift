//
//  OnboardingAnalytics.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 22/12/2024.
//

import SwiftUI

struct OnboardingAnalytics: View {
    @ObservedObject var analytics: AnalyticsDocument
    @Binding var currentPage: Int

    var body: some View {
        VStack {
            header
            analyticsSwitch
            crashlytics
            Spacer()
            Button(action: {
                currentPage = 2
            }, label: {
                HStack{
                    Spacer()
                    Label("Verder", systemImage: "arrow.right")
                    Spacer()
                }
                .padding(.vertical, Constants.btnPadding)
            })
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    var header: some View {
        VStack {
            Text("Data usage")
                .font(.title)
            Text("Change how much data you want to share with us.")
                .padding(.bottom)
                .font(.subheadline)
        }
    }
    
    var analyticsSwitch: some View {
        VStack {
            Text("Analytics")
                .fontWeight(.semibold)
                .align(.left)
            Text("Allow Hydra to collect anonymous user statistics. We use this to know how many people use Hydra & for what they use it.")
                .align(.left)
            Toggle(
                isOn: $analytics.analyticsEnabled
            ) {
                Text("Allow analytics")
            }
        }
    }
    
    var crashlytics: some View {
        VStack {
            Text("Crash reports")
                .fontWeight(.semibold)
                .align(.left)
            Text("Send logs and other useful (anonymous) information if the app crashes, allowing us to fix the issue as fast as possible.")
                .align(.left)
            Toggle(
                isOn: $analytics.crashlyticsEnabled
            ) {
                Text("Allow crash reports")
            }
        }
    }
    
    struct Constants {
        static let btnPadding: CGFloat = 7
    }
}

#Preview {
    @State var currentPage: Int = 0
    OnboardingAnalytics(analytics: AnalyticsDocument(), currentPage: $currentPage)
}
