//
//  FileReader.swift
//  Airbender
//
//  Created by Robert Gstöttner, Christopher Ebner, Manuel Mühlschuster on 14.11.18.
//  Copyright © 2018 Appyx. All rights reserved.
//

import Foundation

class FileReader {
    private let manager = FileManager.default
    var dir: URL
    var file: URL?

    init(directory: URL? = nil) {
        if let directory = directory {
            self.dir = directory
        } else {
            self.dir = manager.urls(for: .documentDirectory, in: .userDomainMask).last!
        }
    }

    func using(file: String) -> FileReader {
        self.file = dir.appendingPathComponent("\(file)")
        return self
    }

    func readLines() throws -> [String]  {
        guard let file = file else { throw FileReaderError.fileNotFound }
        guard let handle = try? FileHandle(forReadingFrom: file) else { throw FileReaderError.fileNotFound }
        guard manager.fileExists(atPath: file.path) else { throw FileReaderError.fileNotFound }
        
        let data = handle.readDataToEndOfFile()
        let text = String(bytes: data, encoding: .utf8)
        handle.closeFile()
        guard let content=text else{
            throw FileReaderError.contentIncompatible
        }
        let lines = content.split(separator: "\n")
        return lines.map {String($0)}
    }
}

enum FileReaderError:Error{
    case fileNotFound
    case contentIncompatible
}
