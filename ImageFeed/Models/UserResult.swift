//
//  UserResult.swift
//  ImageFeed
//
//  Created by Created by Nataliya TRUFANOVA on 10/10/2023.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage?
}

struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?
}
