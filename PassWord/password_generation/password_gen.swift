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
func genPass(targetLength: Int, word_handler: WordHandler, evenWords: Bool = true) -> String? {
    // The number included in the password (X)
    var passNumber = String()

    let minimum_password_length = word_handler.getMinimumDefaultLength()
    let maximum_password_length = word_handler.getMaximumDefaultLength()
    assert(targetLength >= minimum_password_length, "Target length cannot be smaller than min. password length")
    assert(targetLength <= maximum_password_length, "Target length cannot be bigger than max. password length")
    if minimum_password_length == targetLength {
        // The number str should be of length 1 because user selected minimum available pw length
        passNumber = genRandomNumberStr(length: 1)
    } else if maximum_password_length == targetLength {
        // The number str should be of length 3 because user selected maximum available pw length
        passNumber = genRandomNumberStr(length: 3)
    } else {
        // Target lenth is in interval (min_size; max_size)
        passNumber = genRandomNumberStr(length: Int.random(in: 2 ... 3))
    }
    
    
    // The special character
    let special_char = genRandomSpecialChar()
    // Total word length of the two words without the number or the special character
    let totalWordLength = targetLength - passNumber.count - 1

    // Shuffle array of avaiable word lengths and filter out every value that is higher than the total word length
    let formatted_word_length_arr = sort(arr: word_handler.getAvaiableWordLengths().filter { $0 < totalWordLength }.shuffled(), smallest_value: 3)
    if let wordLengths = getWordComposition(word_handler: word_handler, targetLength: totalWordLength, evenWords: evenWords) {
        if let wordlist1 = word_handler.getWords(for: wordLengths.0), let wordlist2 = word_handler.getWords(for: wordLengths.1) {
            let wordIndex1 = arc4random_uniform(UInt32(wordlist1.count))
            let wordIndex2 = arc4random_uniform(UInt32(wordlist2.count))
            // Word1
            var word1 = wordlist1[Int(wordIndex1)]
            // Capitalizes first letter with a chance of 50%
            word1 = Bool.random() ? word1.uppercaseFirstLetter : word1.lowercaseFirstLetter

            // Word2
            var word2 = wordlist2[Int(wordIndex2)]
            // Capitalizes first letter with a chance of 50%
            word2 = Bool.random() ? word2.uppercaseFirstLetter : word2.lowercaseFirstLetter

            return word1 + passNumber + special_char + word2
        }
    }
    return nil
}
