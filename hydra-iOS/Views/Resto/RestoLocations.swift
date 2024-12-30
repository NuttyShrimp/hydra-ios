//
//  RestoLocations.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 15/12/2024.
//

import MapKit
import SwiftUI

struct RestoLocations: View {
    @ObservedObject var restos: RestoDocument
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 51.045017, longitude: 3.725272),
        span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))

    var body: some View {
        // Info: Unable to use the DataLoaderComponent here, it crashes ones the data is loaded.
        // Normally the locations should be loaded once we are on this screen thus it is not a big deal
        if case .success(let data) = restos.restoLocations {
            Map(
                coordinateRegion: $region, interactionModes: .all,
                showsUserLocation: true, userTrackingMode: $userTrackingMode,
                annotationItems: data.filter {
                    $0.name.lowercased() != "english menu"
                }
            ) { item in
                let coord = CLLocationCoordinate2D(
                    latitude: item.latitude, longitude: item.longitude)
                return MapAnnotation(
                    coordinate: coord
                ) {
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .font(.title)

                        Text(item.name)
                            .font(.caption)
                            .padding(5)
                            .background(Color.init(.systemBackground))
                            .cornerRadius(5)
                            .shadow(radius: 2)
                    }
                    .onTapGesture {
                        let item = MKMapItem(placemark: MKPlacemark(coordinate: coord))
                        item.name = item.name
                        item.openInMaps(launchOptions: Constants.mapLaunchOptions)
                    }

                }
            }
            .ignoresSafeArea(.container)
        } else {
            EmptyView()
        }
    }

    struct Constants {
        static let mapLaunchOptions: [String: String] = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault
        ]
    }
}

#Preview {
    RestoLocations(restos: RestoDocument())
}
