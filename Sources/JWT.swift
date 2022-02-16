//
//  JWT.swift
//  AppStoreConnect
//
//  Created by khoa on 14/02/2022.
//

import Foundation
import JWTKit

public struct Credential {
    let issuerId: String
    let privateKeyId: String
    let privateKey: String
    let expirationDuration: TimeInterval

    public init(
        issuerId: String,
        privateKeyId: String,
        privateKey: String,
        expirationDuration: TimeInterval = 2 * 60
    ) {
        self.issuerId = issuerId
        self.privateKeyId = privateKeyId
        self.privateKey = privateKey
        self.expirationDuration = expirationDuration
    }

    func generateJWT() throws -> String {
        guard let signer = try? JWTSigner.es256(
            key: ECDSAKey.private(pem: privateKey))
        else {
            throw AppStoreConnectError.invalidJWT
        }

        let payload = Payload(
            issueID: IssuerClaim(value: issuerId),
            expiration: ExpirationClaim(
                value: Date(
                    timeInterval: expirationDuration,
                    since: Date()
                )
            ),
            audience: AudienceClaim(
                value: "appstoreconnect-v1"
            )
        )

        guard let jwt = try? signer.sign(
            payload,
            kid: JWKIdentifier(string: privateKeyId)
        ) else {
            throw AppStoreConnectError.invalidJWT
        }

        return jwt
    }
}

struct Payload: JWTPayload {
    private enum CodingKeys: String, CodingKey {
        case issueID = "iss"
        case expiration = "exp"
        case audience = "aud"
    }

    var issueID: IssuerClaim
    var expiration: ExpirationClaim
    var audience: AudienceClaim

    func verify(using signer: JWTSigner) throws {
        try expiration.verifyNotExpired()
    }
}
