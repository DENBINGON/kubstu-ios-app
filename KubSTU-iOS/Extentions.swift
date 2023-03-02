//
//  Extentions.swift
//  KubSTU-iOS
//
//  Created by Руслан Соловьев on 07.10.2022.
//

import Foundation

extension Array {
    func choice() -> Element {
        let randomIndex = Int(arc4random()) % count
        return self[randomIndex]
    }
}
