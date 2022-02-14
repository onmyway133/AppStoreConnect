//
//  Client.swift
//  AppStoreConnect
//
//  Created by khoa on 14/02/2022.
//

import Get

public enum AppStoreConnectError: Error {
    case invalidJWT
}

public final class Client: APIClientDelegate {
    public let apiClient: APIClient

    public init(
        credential: Credential
    ) throws {
        let jwt = try credential.generateJWT()
        apiClient = APIClient(host: "https://api.appstoreconnect.apple.com/v1") {
            $0.sessionConfiguration.httpAdditionalHeaders = [
                "Authorization": "Bearer \(jwt)"
            ]
        }
    }
}
