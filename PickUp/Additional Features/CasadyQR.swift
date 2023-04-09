//
//  CasadyQR.swift
//  PickUp
//
//  Created by Krish Patel on 4/8/23.
//

import UIKit
import AVFoundation

class CasadyQR: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var positionNumber: UITextField!
    var number: Int = 0
    var captureSession: AVCaptureSession!
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue", attributes: .concurrent)
    }()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var studentNumber: String = "" {
        didSet {
            //scanText.text = "Scanned"
            //DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
              //  self.scanText.text = ""
            //}
            let instance = DATABASE()
            self.background.async {
                var children = instance.FindIDWithNumber(DATABASE.ApplyHash(self.studentNumber))
                if children != [""] {
                    for child in children {
                        self.number = Int(self.positionNumber.text ?? "0")!
                        instance.EditCasady(child, String(self.number))
                        instance.EditInfo(child, "here")
                    }
                    DispatchQueue.main.async {
                        self.positionNumber.text = String(self.number + 1)
                        //auto number changing
                    }
                }
            }
        }
    }
    //set up the camera

    override func viewDidLoad() {
        super.viewDidLoad()
        self.positionNumber.text = String(POSITION)
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .vga640x480
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        //captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        //dismiss(animated: true)
    }

    func found(code: String) {
        if code != studentNumber {
            studentNumber = code
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
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
