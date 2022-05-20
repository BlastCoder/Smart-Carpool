//
//  QRCodeScannerVC.swift
//  PickUp
//
//  Created by Krish Patel on 4/28/22.
//

import UIKit
import AVFoundation



class QRCodeScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var scanText: UILabel!
    var captureSession: AVCaptureSession!
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue", attributes: .concurrent)
    }()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var studentID: String = "" {
        didSet {
            scanText.text = "Scanned"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.scanText.text = ""
            }
            let instance = DATABASE()
            //marks student present after QRcode is scanned
            self.background.async {
                if instance.checkID(self.studentID) {
                    if instance.GetInfoWithID(self.studentID)["Status"] as! String != "gone" {
                        instance.EditInfo(self.studentID, "here")
                    }
                    else {
                        //if the child is checked out, then throw error
                        DispatchQueue.main.async {
                            self.scanText.text = "Child Already Checked Out"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                self.scanText.text = ""
                            }
                        }
                    }
                }
            }
        }
    }
    //set up the camera

    override func viewDidLoad() {
        super.viewDidLoad()
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
            //AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        //dismiss(animated: true)
    }

    func found(code: String) {
        if code != studentID {
            studentID = code
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
