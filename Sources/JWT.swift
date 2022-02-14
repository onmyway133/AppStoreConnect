//
//  JWT.swift
//  AppStoreConnect
//
//  Created by khoa on 14/02/2022.
//

import JWTKit

public struct Credential {
    let issuerId: String
    let privateKeyId: String
    let privateKey: String

    public init(
        issuerId: String,
        privateKeyId: String,
        privateKey: String
    ) {
        self.issuerId = issuerId
        self.privateKeyId = privateKeyId
        self.privateKey = privateKey
    }

    func generateJWT() throws -> String {
        let audience = "appstoreconnect-v1"

        guard let signer = try? JWTSigner.es256(
            key: ECDSAKey.private(pem: privateKey))
        else {
            throw AppStoreConnectError.invalidJWT
        }

        let payload = Payload(
            issueID: .init(value: issuerId),
            expiration: .init(
                value: .init(
                    timeInterval: 2 * 60,
                    since: Date()
                )
            ),
            audience: AudienceClaim.init(
                value: audience
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
