//
//  UserResult.swift
//  ImageFeed
//
//  Created by Nataliya MASSOL on 10/10/2023.
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
