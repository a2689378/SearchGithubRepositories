//
//  Repository.swift
//  SearchGithubRepositories
//
//  Created by 何常凱 on 2021/8/15.
//

import Foundation

struct Repository: Decodable {
    let node_id: String
    let fullName: String
    let description: String?
    let stargazersCount: Int
    let htmlUrl: URL
    let login: String
}

struct Results: Decodable {
    let items: [Repository]
}

