//
//  word_index_handler.swift
//  PassWord-algorithm
//
//  Created by Carl Raabe on 10.12.21.
//

import Foundation
/**
 Various methods to handle a given word index containing information about word length filename and wordcount
 */
class word_handler {
    // The word index
    var index: [Int: String]

    /**
     Initalizer

     - Parameter: The word index to be used
     */
    init(index: [Int: String]) {
        self.index = index
    }

    /**
     Returns smallest possible word length of word in index

     - Returns: Smallest word length as Int or nil
     */
    func getMinimumWordLength() -> Int? {
        index.keys.min() ?? nil
    }

    /**
     Returns all avaiable word lengths as an array

     - Returns: The avaiable word lengths as an array
     */
    func getAvaiableWordLengths() -> [Int] {
        Array(index.keys)
    }

    /**
     Looks up filename for given word length in index

     - Parameter word_length: The word length

     - Returns: The filename; If entry not found returns nil
     */
    func getFileName(for word_length: Int) -> String? {
        index[word_length] ?? nil
    }

    /**
     Check if a given word length is avaiable in index

     - Parameter word_length: The word length as an Int

     - Returns: true if word_length is avaiable in index; false if not
     */
    func isWordLengthAvaiable(word_length: Int) -> Bool {
        getAvaiableWordLengths().contains(word_length)
    }

    /**
     Reads the words from text file for a given word length

     - Parameter word_length: The word length as an Int
     */
    func getWords(for word_length: Int) -> [String]? {
        if let filename = getFileName(for: word_length), let wordString = readData(from: filename) {
            if filename.count != 0 {
                return splitToWords(str: wordString)
            }
        }
        return nil
    }

    /**
     Returns given string seperated new lines

     - Parameter str: The String

     - Returns: The original String split into its words
     */
    func splitToWords(str: String) -> [String] {
        str.components(separatedBy: "\n")
    }

    /**
     Reads file in folder containing all words

     - Parameter filename: The name of the file including the file suffix

     - Returns: The content of the file or nil
     */
    func readData(from filename: String) -> String? {
        guard var path = Bundle.main.resourcePath else {
            return nil
        }
        path += "/\(filename)"

        do {
            return try String(contentsOfFile: path, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    /**
     Returns the smallest possible length of the password if the password has the format WXXCW (W > Word, X > Number, C > Special character)
     */
    func getMinimumDefaultLength() -> Int? {
        if let minimum_word_length = getAvaiableWordLengths().min() {
            return minimum_word_length * 2 + 3
        }
        return nil
    }

    func getMaximumDefaultLength() -> Int? {
        if let maximum_word_length = getAvaiableWordLengths().max() {
            return maximum_word_length * 2 + 3
        }
        return nil
    }
}