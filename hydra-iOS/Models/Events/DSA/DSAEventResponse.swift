//
//  DSAEventResponse.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 10/11/2024.
//
// The struct required to retreive the DSA events from the API

struct DSAEventResponse: Decodable {
    public var page: DSAEventPage
}

struct DSAEventPage: Decodable {
    public var entries: [DSAEvent]
}
