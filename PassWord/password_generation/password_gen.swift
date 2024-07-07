//
//  password_gen.swift
//  PassWord-algorithm
//
//  Created by Carl Raabe on 13.12.21.
//

import Foundation

/**
 Generates a memorable password with the given length

 Password format: WXXCW (W > Word, X > Number, C > Special character)

 - Parameter targetLength: The length of the password
 - Parameter evenWords: When set to true: The generator will try to generate a wordpair with evenly distributed letter count

 - Returns: The password or nil if targetLength is too short or a if an error occurred
 */
func genPass(targetLength: Int, handler: word_handler, evenWords: Bool = true) -> String? {
    let words = handler

    // The number included in the password (X)
    var number = Int()

    if let minimum_password_length = words.getMinimumDefaultLength(), let maximum_password_length = words.getMaximumDefaultLength() {
        if minimum_password_length > targetLength {
            // The number ranging from 0 - 10 if targetLength is lower than minimum_password_length
            number = Int.random(in: 0 ..< 10)
        } else if maximum_password_length == targetLength {
            number = Int.random(in: 10 ..< 100)
        } else {
            // The number ranging from 0 - 99 if targetLength is higher than minimum_password_length
            number = Int.random(in: 0 ..< 100)
        }
    } else {
        return nil
    }

    // The special character
    let special_char = genRandomSpecialChar()
    // Total word length of the two words without the number or the special character
    let totalWordLength = targetLength - String(number).count - 1

    // Shuffle array of avaiable word lengths and filter out every value that is higher than the total word length
    let formatted_word_length_arr = sort(arr: words.getAvaiableWordLengths().filter { $0 < totalWordLength }.shuffled(), smallest_value: 3)
    if let wordLengths = getWordComposition(in: formatted_word_length_arr, targetLength: totalWordLength, evenWords: evenWords) {
        if let wordlist1 = words.getWords(for: wordLengths.0), let wordlist2 = words.getWords(for: wordLengths.1) {
            let wordIndex1 = arc4random_uniform(UInt32(wordlist1.count))
            let wordIndex2 = arc4random_uniform(UInt32(wordlist2.count))
            // Word1
            var word1 = wordlist1[Int(wordIndex1)]
            // Capitalizes first letter with a chance of 50%
            word1 = trueOrFalse() ? word1.uppercaseFirstLetter : word1.lowercaseFirstLetter

            // Word2
            var word2 = wordlist2[Int(wordIndex2)]
            // Capitalizes first letter with a chance of 50%
            word2 = trueOrFalse() ? word2.uppercaseFirstLetter : word2.lowercaseFirstLetter

            return word1 + String(number) + special_char + word2
        }
    }
    return nil
}
