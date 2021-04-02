//
//  SearchByDate.swift
//  VDigitalExam
//
//  Created by Cristian on 02-04-21.
//

import Foundation

// swiftlint:disable identifier_name
struct SearchByDate: Codable {
    let hits: [Hits]
}

struct Hits: Codable {
    let created_at: String
    let title: String
    let url: String
    let author: String
    let points: String
    let story_text: String
    let comment_text: String
    let num_comments: String
    let story_id: Int
    let story_title: String
    let story_url: String
    let parent_id: Int
    let created_at_i: Int
    let _tags: [String]
    let objectID: String
    let _highlightResult: HighlightResult
}

struct HighlightResult: Codable {
    let author: [LinkedValue]
    let comment_text: [LinkedValue]
    let story_title: [LinkedValue]
    let story_url: [LinkedValue]
}

struct LinkedValue: Codable {
    let value: String
    let matchLevel: String
    let matchedWords: [String]
}
