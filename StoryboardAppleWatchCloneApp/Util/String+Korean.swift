//
//  String+Korean.swift
//  StoryboardAppleWatchCloneApp
//
//  Created by racoon on 6/17/24.
//

import Foundation

extension String {
    var chosung: String? {
        guard trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else {
            return nil
        }
        
        guard let firstString = first, let uniCodeScalar = UnicodeScalar(String(firstString)) else {
            return nil
        }
        
        guard (0xAC00 ... 0xD7AF).contains(uniCodeScalar.value) else {
            return String(firstString)
        }
        
        let chosungList = Array("ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ")
        
        let chosungIndex = (uniCodeScalar.value - 0xAC00) / (21 * 28)
        
        return String(chosungList[Int(chosungIndex)])
    }
}
