//
//  Client.swift
//  AppStoreConnect
//
//  Created by khoa on 14/02/2022.
//

import Get
import Foundation

public enum AppStoreConnectError: Error {
    case invalidJWT
    case invalid(String)
}

public final class Client: APIClientDelegate {
    public let apiClient: APIClient

    public init(
        credential: Credential,
        decoder: JSONDecoder = Client.customDecoder()
    ) throws {
        let jwt = try credential.generateJWT()
        apiClient = APIClient(host: "api.appstoreconnect.apple.com") {
            $0.sessionConfiguration.httpAdditionalHeaders = [
                "Authorization": "Bearer \(jwt)"
            ]
            $0.decoder = decoder
        }
    }

    public static func customDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .customStrategy
        return decoder
    }
}
