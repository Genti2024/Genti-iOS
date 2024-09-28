//
//  MaintenanceInfoResponseDTO.swift
//  Genti_iOS
//
//  Created by uiskim on 9/28/24.
//

import Foundation

struct MaintenanceInfoResponseDTO: Codable {
    let status: Bool
    var message: String?
}

extension MaintenanceInfoResponseDTO {
    var toEntitiy: CheckInspectionTimeEntity {
        return .init(canMake: self.status, message: self.message)
    }
}
