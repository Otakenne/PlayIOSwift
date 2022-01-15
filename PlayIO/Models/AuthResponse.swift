//
//  AuthResponse.swift
//  PlayIO
//
//  Created by Otakenne on 12/01/2022.
//

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let token_type: String?
}
