//
//  String+.swift
//  SwiftyExtensions
//
//  Created by Sergey Petrachkov on 28.10.2017
//  Copyright © 2017 SwiftyExtensions. All rights reserved.
//

import UIKit

extension String {
	static func randomString(length: Int) -> String {
		
		let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		let len = UInt32(letters.length)
		
		var randomString = ""
		
		for _ in 0 ..< length {
			let rand = arc4random_uniform(len)
			var nextChar = letters.character(at: Int(rand))
			randomString += NSString(characters: &nextChar, length: 1) as String
		}
		return randomString
	}
	
	
	var localized : String {
		return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
	}

	/// Returns matches for a given regular expression
	/// - parameters:
	///		- regex: regular expression in string format
	/// - returns: string array of matches
	func matches(for regex: String) -> [String] {
		do {
			let regex = try NSRegularExpression(pattern: regex)
			let nsString = self as NSString
			let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
			return results.map { nsString.substring(with: $0.range)}
		} catch let error {
			print("invalid regex: \(error.localizedDescription)")
			return []
		}
	}
    
  func capturedGroups(withRegex pattern: String) -> [String] {
    var results = [String]()
    
    var regex: NSRegularExpression
    do {
        regex = try NSRegularExpression(pattern: pattern, options: [])
    } catch {
        return results
    }
    
    let matches = regex.matches(in: self, options: [], range: NSRange(location:0, length: self.characters.count))
    
    guard let match = matches.first else { return results }
    
    let lastRangeIndex = match.numberOfRanges - 1
    guard lastRangeIndex >= 1 else { return results }
    
    for i in 1...lastRangeIndex {
        let capturedGroupIndex = match.range(at: i)
        let matchedString = (self as NSString).substring(with: capturedGroupIndex)
        results.append(matchedString)
    }
    return results
  }

	func regexMatches(pattern: String) -> Array<String> {
		let regex: NSRegularExpression
		do {
			regex = try NSRegularExpression(pattern: pattern, options: [])
		} catch {
			return []
		}
		
		let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
		var collectMatches: Array<String> = []
		for match in matches {
			// range at index 0: full match
			// range at index 1: first capture group
			let substring = (self as NSString).substring(with: match.range(at: 1))
			collectMatches.append(substring)
		}
		return collectMatches
	}
	
	func index(of string: String) -> String.Index? {
		return range(of: string)?.lowerBound
	}
}
