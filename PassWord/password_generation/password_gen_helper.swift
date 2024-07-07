//
//  password_gen_helper.swift
//  PassWord-algorithm
//
//  Created by Carl Raabe on 11.12.21.
//

import Foundation

func genRandomSpecialChar() -> String {
    let special_chars = ["+", "-", "&", "!", "(", ")", "{", "}", "[", "]", "~", "*", "?", ":", ";"]

    return special_chars.randomElement()!
}

func getWordComposition(in letter_count_list: [Int], targetLength: Int, evenWords: Bool) -> (Int, Int)? {
    if evenWords {
        // Returns a tuple of two preferrably even numbers if possible
        let preffered_length_word_1 = targetLength / 2
        for i in letter_count_list {
            if i + preffered_length_word_1 == targetLength {
                return (preffered_length_word_1, i)
            }
        }
    }
    // Fallback if first test doesn't return a result
    for i in letter_count_list {
        for j in letter_count_list {
            if i + j == targetLength {
                return (i, j)
            }
        }
    }
    return nil
}

func trueOrFalse() -> Bool {
    let random = arc4random_uniform(2)

    return random == 1 ? true : false
}

func sort(arr: [Int], smallest_value: Int) -> [Int] {
    // [2,3,5,4,6,7,8] 3
    // [4,5,6,7,8,2,3]
    let high_val_arr = arr.filter { $0 > smallest_value }
    let small_val_arr = arr.filter { $0 <= smallest_value }
    return high_val_arr + small_val_arr
}
