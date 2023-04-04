//
//  LocationManagerClient.swift
//  locationTest
//
//  Created by Selina on 2023/04/04.
//

import CoreLocation

import Dependencies

struct LocationManagerClient: Sendable {
    var requestAuthorization: @Sendable () -> Void
    var checkAvailability: @Sendable () -> Bool
    var authorizationStatus: @Sendable () async throws -> CLAuthorizationStatus
}

extension DependencyValues {
    var locationManagerClient: LocationManagerClient {
        get { self[LocationManagerClient.self] }
        set { self[LocationManagerClient.self] = newValue }
    }
}
