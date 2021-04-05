//
//  SearchByDate.swift
//  VDigitalExam
//
//  Created by Cristian on 02-04-21.
//
import Foundation

// MARK: - Welcome
struct SearchByDate: Codable {
    let hits: [Hit]
    let nbHits, page, nbPages, hitsPerPage: Int
    let exhaustiveNbHits: Bool
    let query: String
    let params: String
    let processingTimeMS: Int
}

// MARK: - Hit
struct Hit: Codable {
    let createdAt: String
    let title: String?
    let url: JSONNull?
    let author: String
    let points: Int?
    let storyText, commentText: String?
    let numComments, storyID: Int?
    let storyTitle: String?
    let storyURL: String?
    let parentID: Int?
    let createdAtI: Int
    let tags: [String]
    let objectID: String
    let highlightResult: HighlightResult

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case title, url, author, points
        case storyText = "story_text"
        case commentText = "comment_text"
        case numComments = "num_comments"
        case storyID = "story_id"
        case storyTitle = "story_title"
        case storyURL = "story_url"
        case parentID = "parent_id"
        case createdAtI = "created_at_i"
        case tags = "_tags"
        case objectID
        case highlightResult = "_highlightResult"
    }
}

// MARK: - HighlightResult
struct HighlightResult: Codable {
    let author: Author
    let commentText, storyTitle, storyURL, title: Author?
    let storyText: Author?

    enum CodingKeys: String, CodingKey {
        case author
        case commentText = "comment_text"
        case storyTitle = "story_title"
        case storyURL = "story_url"
        case title
        case storyText = "story_text"
    }
}

// MARK: - Author
struct Author: Codable {
    let value: String
    let matchLevel: MatchLevel
    let matchedWords: [String]
    let fullyHighlighted: Bool?
}

enum MatchLevel: String, Codable {
    case full = "full"
    case none = "none"
}

//enum Query: String, Codable {
//    case mobile = "mobile"
//}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

