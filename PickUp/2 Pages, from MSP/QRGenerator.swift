//
//  QRGenerator.swift
//  PickUp
//
//  Created by Krish Mody on 4/28/22.
//

import UIKit

class QRGenerator: UIViewController {
    var qrText: String = ""
    var image: UIImage!
    @IBOutlet weak var imageView: UIImageView!
    //segue from add student page, given student id to generate QR code
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
                    let context = CIContext()
                    guard let cgImage = context.createCGImage(output, from: output.extent) else { return nil }
                    return UIImage(cgImage: cgImage)
                }   
            }
            return nil
        }
    @IBAction func addPhotos(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(self.imageView.image!, nil, nil, nil)
        //add to photos
        print("Here")
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
