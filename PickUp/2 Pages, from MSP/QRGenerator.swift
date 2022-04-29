//
//  QRGenerator.swift
//  PickUp
//
//  Created by Krish Mody on 4/28/22.
//

import UIKit

class QRGenerator: UIViewController {
    var qrText: String = ""
    var image = UIImage()
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
            super.viewDidLoad()
        print(self.qrText)
        guard let image = generateQRCode(from: self.qrText) else {fatalError()}
            imageView.image = image
        }
        
        func generateQRCode(from string: String) -> UIImage? {
            let data = string.data(using: String.Encoding.ascii)
            if let filter = CIFilter(name: "CIQRCodeGenerator") {
                filter.setValue(data, forKey: "inputMessage")
                let transform = CGAffineTransform(scaleX: 3, y: 3)

                if let output = filter.outputImage?.transformed(by: transform) {
                    return UIImage(ciImage: output)
                }
            }
            return nil
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
