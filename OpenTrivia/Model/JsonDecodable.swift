//
//  JsonDecodable.swift
//  OpenTrivia
//
//  Created by Sailor on 18/08/2019.
//  Copyright © 2019 sailor.OpenTrivia. All rights reserved.
//


import Foundation


struct Question: JsonDecodable {
    let category: String?
    let type: String?
    let difficulty: String?
    let question: String?
    let correctAnswer: String?
    let incorrectAnswers: [String]?
    
    enum CodingKeys: String, CodingKey {
        case category = "category"
        case type = "type"
        case difficulty = "difficulty"
        case question = "question"
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}

struct Trivia: JsonDecodable {
    let response_code: Int?
    let questions: [Question]?
    
    enum CodingKeys: String, CodingKey {
        case response_code
        case questions = "results"
    }
}







