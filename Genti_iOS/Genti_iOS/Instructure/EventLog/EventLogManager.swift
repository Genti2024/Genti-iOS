//
//  EventLogManager.swift
//  Genti_iOS
//
//  Created by uiskim on 8/14/24.
//

import Foundation

import Amplitude

final class EventLogManager {
    
    static let shared = EventLogManager()
    
    private init() {}
    
    func logEvent(_ type: LogEventType) {
        Amplitude.instance().logEvent(type.eventName, withEventProperties: type.property)
    }
    
    func addUserPropertyCount(to type: LogUserPropertyType) {
        let identify = AMPIdentify().add(type.propertyName, value: NSNumber(value: 1))
        guard let identify = identify else {return}
        Amplitude.instance().identify(identify)
    }

    func addUserProperty(to type: LogUserPropertyType) {
        guard let dict = type.property, let key = dict.keys.first, let value = dict[key] as? NSObject else { return }
        let identify = AMPIdentify().set(key, value: value)
        guard let identify = identify else {return}
        Amplitude.instance().identify(identify)
    }
}
