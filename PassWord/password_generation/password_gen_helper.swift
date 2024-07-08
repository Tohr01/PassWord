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

func genRandomNumberStr(length: Int) -> String {
    var res = String()
    for _ in 0 ..< length {
        res += "\(Int.random(in: 0 ..< 10))"
    }
    return res
}

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

func sort(arr: [Int], smallest_value: Int) -> [Int] {
    // [2,3,5,4,6,7,8] 3
    // [4,5,6,7,8,2,3]
    let high_val_arr = arr.filter { $0 > smallest_value }
    let small_val_arr = arr.filter { $0 <= smallest_value }
    return high_val_arr + small_val_arr
}
