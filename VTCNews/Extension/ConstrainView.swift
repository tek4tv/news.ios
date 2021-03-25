import Foundation
import AVKit
let scaleH = UIScreen.main.bounds.height / 896
let scaleW = UIScreen.main.bounds.width / 414
extension NSLayoutConstraint{
    @IBInspectable var autoConstrains: Bool {
        get { return true }
        set {
            let attribute = self.firstAttribute
            if attribute == .top || attribute == .bottom {
                self.constant = self.constant * scaleH
            } else if attribute == .leading || attribute == .trailing {
                self.constant = self.constant * scaleW
            }
            
            if attribute == .width {
                self.constant = self.constant * scaleW
            } else if attribute == .height {
                self.constant = self.constant * scaleH
            }
        }
    }
}
extension UILabel{
    @IBInspectable var myAutoFontSize: Bool{
        get{ true }
        set {
            self.font = self.font.withSize(self.font.pointSize * scale)
        }
    }
}
extension UITextView{
    @IBInspectable var myAutoFontSize: Bool{
        get{ true }
        set {
            self.font = self.font?.withSize(self.font!.pointSize * scale)
        }
    }
}
extension UITextField{
    @IBInspectable var myAutoFontSize: Bool{
        get{ true }
        set {
            self.font = self.font?.withSize(self.font!.pointSize * scale)
        }
    }
}
