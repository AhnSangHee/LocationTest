//
//  GpsCore.swift
//  locationTest
//
//  Created by Selina on 2023/04/04.
//

import CoreLocation
import SwiftUI

import ComposableArchitecture

public struct Gps: ReducerProtocol {
    public struct State: Equatable {
        var authorizationStatus: CLAuthorizationStatus?
        var alert: AlertState<Action>?
        
        public init() {}
    }
    
    public enum Action: Equatable {
        case onAppear
        case alertDismissed
        case requestAuthorization
        case requestAuthorizationResponse(TaskResult<CLAuthorizationStatus>)
        case showAlert
    }
    
    @Dependency(\.locationManagerClient) var locationManagerClient
    
    public init() {}
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                locationManagerClient.requestAuthorization()
                return .none
            case .alertDismissed:
                state.alert = nil
                return .none
            case .requestAuthorization:
                locationManagerClient.requestAuthorization()
                return .task {
                    .requestAuthorizationResponse(
                        await TaskResult {
                            try await locationManagerClient.authorizationStatus()
                        }
                    )
                }
            case .requestAuthorizationResponse(.success(let authorizationStatus)):
                state.authorizationStatus = authorizationStatus
                if state.authorizationStatus == .restricted ||
                    state.authorizationStatus == .denied {
                    state.alert = AlertState(
                        title: { TextState("알림") },
                        actions: {
                            ButtonState(
                                role: .cancel,
                                action: .alertDismissed,
                                label: { TextState("취소") }
                            )

                            ButtonState(
                                role: .none,
                                action: .showAlert.self,
                                label: { TextState("확인") }
                            )
                        },
                        message: { TextState("위치에 접근할 수 없습니다. 위치 접근 권한을 허용하시겠습니까?") }
                    )
                    return .none
                }
                
                if !locationManagerClient.checkAvailability() {
                    state.alert = AlertState(
                        title: { TextState("알림") },
                        actions: {
                            ButtonState(
                                role: .none,
                                action: .showAlert.self,
                                label: { TextState("확인") }
                            )
                        },
                        message: { TextState("GPS 서비스를 사용할 수 없습니다!") }
                    )
                }
                
                print("현재 상태", state.authorizationStatus?.rawValue)
                
//                locationManagerClient.currentLocation()
                return .none
            case .requestAuthorizationResponse(.failure(_)):
                state.authorizationStatus = .notDetermined
                return .none
            case .showAlert:
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return .none
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { _ in })
                    return .none
                }
                return .none
            }
        }
    }
}
