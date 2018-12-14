//
//  Message.swift
//  Airbender
//
//  Created by Robert Gstöttner, Christopher Ebner, Manuel Mühlschuster on 14.11.18.
//  Copyright © 2018 Appyx. All rights reserved.
//

import Foundation

class Message {

    let type: MessageType
    var content: Any

    init(type: MessageType) {
        self.type = type
        self.content = "empty"
    }

    func with(data: RawData) -> Message {
        content = data.toDictionary()
        return self
    }

    func with(text: String) -> Message {
        content = text
        return self
    }

    func getData() -> RawData? {
        if let data = content as?[String: Any] {
            return RawData(dict: data)
        }
        return nil
    }

    func getText() -> String? {
        return content as? String
    }

    init?(dict: [String: Any]) {
        if let key = dict.keys.first, let type = MessageType.init(rawValue: key) {
            self.type = type
            self.content = dict[key]!
        } else {
            return nil
        }
    }


    func toDictionary() -> [String: Any] {
        return [type.rawValue: content]
    }
}

enum MessageType: String {
    case Control = "control"
    case Data = "data"
}
