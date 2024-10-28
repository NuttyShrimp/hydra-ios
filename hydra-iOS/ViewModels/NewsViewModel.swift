//
//  NewsViewModel.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 13/10/2024.
//

import Foundation
import Alamofire

class CustomDecoder: JSONDecoder, @unchecked Sendable {
    let dateFormatter = DateFormatter()

    override init() {
        super.init()
        dateDecodingStrategy = .iso8601
    }
}

class NewsViewModel: ObservableObject {
    // NOTE: Should this be moved to a model?
    @Published private(set) var DSAEvents: [DSAEvent] = [];
    @Published private var UGentNews: [UgentNewsEntry] = [];
    
    var events: [NewsEvent] {
        return (DSAEvents.map { $0.intoNewsEvent() }
                + UGentNews.map { $0.intoNewsEvent() }).sorted {
            $0.creationDate < $1.creationDate
        }
    }
    
    func loadEvents() {
        loadDSAEvents()
        LoadUgentNews()
    }
    
    private func loadDSAEvents() {
        debugPrint("Loading DSA events")
        AF.request("\(Constants.DSA)/activiteiten").responseDecodable(of: DSAResponse.self, decoder: CustomDecoder()) { response in
            do {
                self.DSAEvents = try response.result.get().page.entries
                debugPrint("Loaded \(self.DSAEvents.count) DSA events")
            } catch {
                // TODO: Add notification that fetch failed
                print("Failed to fetch DSA events: \(error)")
            }
        }
    }
    
    private func LoadUgentNews() {
        debugPrint("Loading Ugent News")
        AF.request("\(Constants.ZEUS_V2)/news/nl.json").responseDecodable(of: UgentNewsResponse.self, decoder: CustomDecoder()) { response in
            do {
                self.UGentNews = try response.result.get().entries
                debugPrint("Loaded \(self.UGentNews.count) Ugent news")
            } catch {
                // TODO: Add notification that fetch failed
                print("Failed to fetch Ugent news: \(error)")
            }
        }
    }
}
