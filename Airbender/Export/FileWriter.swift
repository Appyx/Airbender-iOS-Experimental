//
//  Exporter.swift
//  SmartRing
//
//  Created by Robert Gstöttner on 01.11.18.
//  Copyright © 2018 Robert Gstöttner. All rights reserved.
//

import Foundation

class FileWriter {
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
    
    func using(file: String)->FileWriter{
        createFile(filename: file)
        return self
    }

    private func createFile(filename: String) {
        file = dir.appendingPathComponent("\(filename)")

        if manager.fileExists(atPath: file!.path) {
            print("appending to file: \(filename)")
        } else {
            print("creating file: \(filename)")
            manager.createFile(atPath: file!.path, contents: nil, attributes: nil)
        }
    }

    func writeLines(lines: [String]) -> Bool {
        guard let file = file else {return false}
        guard let handle = try? FileHandle(forWritingTo: file) else { return false }
        guard manager.fileExists(atPath: file.path) else { return false }

        handle.seekToEndOfFile()
        for line in lines {
            let str = "\(line)\n"
            handle.write(Data(str.utf8))
        }
        handle.closeFile()
        return true
    }

    func writeLine(line: String) -> Bool {
        return writeLines(lines: [line])
    }
}
