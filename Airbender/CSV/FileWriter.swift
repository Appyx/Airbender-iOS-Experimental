//
//  Exporter.swift
//  SmartRing
//
//  Created by Robert Gstöttner, Christopher Ebner, Manuel Mühlschuster on 14.11.18.
//  Copyright © 2018 Appyx. All rights reserved.
//

import Foundation

class FileWriter {
    private let manager = FileManager.default
    private var dir: URL
    private var file: URL?
    private let appending:Bool

    init(appending:Bool=true,directory: URL? = nil) {
        self.appending=appending
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

        if manager.fileExists(atPath: file!.path) && appending{
            print("appending to file: \(filename)")
        } else {
            print("creating file: \(filename)")
            manager.createFile(atPath: file!.path, contents: nil, attributes: nil)
        }
    }

    func writeLines(lines: [String]) throws {
        guard let file = file else {throw FileWriterError.fileNotFound}
        guard let handle = try? FileHandle(forWritingTo: file) else {throw FileWriterError.fileNotFound}
        guard manager.fileExists(atPath: file.path) else {throw FileWriterError.fileNotFound}
        
        handle.seekToEndOfFile()
        for line in lines {
            let str = "\(line)\n"
            handle.write(Data(str.utf8))
        }
        handle.closeFile()
    }
}

enum FileWriterError:Error{
    case fileNotFound
}
