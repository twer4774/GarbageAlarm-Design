//
//  Helper.swift
//
//  Copyright (c) 2017-Present Jochen Pfeiffer
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import JJFloatingActionButton
import UIKit

internal struct Helper {

    static func showAlert(for item: JJActionItem) {
    buttonColor: .blue, otherButtonTitle: "취소", otherButtonColor: .red, theOtherButtonTitle:"알람끄기", theOtherButtonColor: .darkGray){
            (isOtherButton, isTheOtherButton) -> Void in
            if isOtherButton == true && isTheOtherButton == false{
                _ = SweetAlert().showAlert("취소!", subTitle: "취소되었습니다", style: AlertStyle.error)
            }else if isOtherButton == false && isTheOtherButton == true{
                _ = SweetAlert().showAlert("알람끄기", subTitle: "알람이 꺼졌습니다.", style: AlertStyle.success)
            }
            else {
                _ = SweetAlert().showAlert("저장!", subTitle: "저장되었습니다", style: AlertStyle.success)
            }
        }
    }
}
