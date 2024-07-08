//
//  password_gen_helper.swift
//  PassWord-algorithm
//
//  Created by Carl Raabe on 11.12.21.
//

import Foundation

/**
 - Returns random special char from constant array
 */
func genRandomSpecialChar() -> String {
    let special_chars = ["+", "-", "&", "!", "(", ")", "{", "}", "[", "]", "~", "*", "?", ":", ";"]

    return special_chars.randomElement()!
}

/**
 Returns random string of given length consisting of numbers from 0-9

 - Parameter length: Target length of string

 - Returns: Resulting string
 */
func genRandomNumberStr(length: Int) -> String {
    var res = String()
    for _ in 0 ..< length {
        res += "\(Int.random(in: 0 ..< 10))"
    }
    return res
}

/**
 Returns nil or a tuple of two word length adding up to targetLength

 - Parameter word_handler: Reference to WordHandler Object
 - Parameter targetLength: Target length (result tuple adds up to target length)
 - Parameter evenWords: If set to true will try to find equal length words first

 - Returns: Nil or tuple
 */
func getWordComposition(word_handler: WordHandler, targetLength: Int, evenWords: Bool) -> (Int, Int)? {
    let word_lengths_set = word_handler.getAvaiableWordLengths()
    if evenWords {
        // Returns a tuple of two preferrably even numbers if possible
        let length_w_1 = Int(targetLength / 2)
        let length_w_2 = targetLength - length_w_1
        if word_lengths_set.contains(length_w_1), word_lengths_set.contains(length_w_2) {
            return (length_w_1, length_w_2)
        }
    }

    // Fallback or if evenWords = false
    // Shuffle set
    let word_lengths_shuffled = word_lengths_set.shuffled()
    for idx in 0 ..< word_lengths_set.count {
        let l1 = word_lengths_shuffled[idx]
        let complement = targetLength - l1
        if word_lengths_set.contains(complement) {
            return (l1, complement)
        }
    }
    return nil
}
