//
//  LocationManagerClientTest.swift
//  locationTest
//
//  Created by Selina on 2023/04/04.
//

import Dependencies
import XCTestDynamicOverlay

extension LocationManagerClient: TestDependencyKey {
    static var testValue = Self(
        requestAuthorization: unimplemented("\(Self.self).requestAuthorization"),
        checkAvailability: unimplemented("\(Self.self).checkAvailablity"),
        authorizationStatus: unimplemented("\(Self.self).authorizationStatus")
    )
}
