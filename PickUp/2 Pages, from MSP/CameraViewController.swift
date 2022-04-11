//
//  CameraViewController.swift
//  PickUp
//
//  Created by Krish Patel on 4/7/22.
//
import UIKit
import AVKit
import Vision
import VideoToolbox
import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var image:CGImage? = nil
    var requestGoing = false
    var bufferSize: CGSize = .zero
    var liscenseDict: [String: Int] = [:]
    private var requests = [VNRequest]()
    var pixelBuffer1:CVPixelBuffer? = nil
    let minimumZoom: CGFloat = 1.0
    let maximumZoom: CGFloat = 10.0
    var lastZoomFactor: CGFloat = 1.0
    var device: AVCaptureDevice? = nil
    //var idNums: [String] = [""]
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue", attributes: .concurrent)
    }()
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    var currentPlate: String = "" {
        willSet {}
        didSet {
            //print(currentPlate)
            self.background.async {
                let instance: DATABASE = DATABASE()
                var idNums = instance.FindIDWithPlate(DATABASE.ApplyHash(self.currentPlate))
                for plate in idNums {
                    self.background.async {
                        let instance: DATABASE = DATABASE()
                        instance.EditInfo(plate, "here")
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var plateNum: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVision()
        self.plateNum.text = "Need Plate"
        
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .vga640x480
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                          for: .video, position: .unspecified) else { return }
        self.device = captureDevice
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
    
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action:#selector(pinch(_:)))
        self.view.addGestureRecognizer(pinchRecognizer)
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.alwaysDiscardsLateVideoFrames = true
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            print("Could not add video data output to the session")
            captureSession.commitConfiguration()
            return
        }
        let captureConnection = dataOutput.connection(with: .video)
        // Always process the frames
        captureConnection?.isEnabled = true
        do {
            try  captureDevice.lockForConfiguration()
            captureDevice.unlockForConfiguration()
        } catch {
            print(error)
        }
        captureSession.commitConfiguration()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @objc func pinch(_ pinch: UIPinchGestureRecognizer) {
            // Return zoo   m value between the minimum and maximum zoom values
            func minMaxZoom(_ factor: CGFloat) -> CGFloat {
                return min(min(max(factor, minimumZoom), maximumZoom), device!.activeFormat.videoMaxZoomFactor)
            }

            func update(scale factor: CGFloat) {
                do {
                    try device!.lockForConfiguration()
                    defer { device!.unlockForConfiguration() }
                    device!.videoZoomFactor = factor
                } catch {
                    print("\(error.localizedDescription)")
                }
            }

            let newScaleFactor = minMaxZoom(pinch.scale * lastZoomFactor)

            switch pinch.state {
            case .began: fallthrough
            case .changed: update(scale: newScaleFactor)
            case .ended:
                lastZoomFactor = minMaxZoom(newScaleFactor)
                update(scale: lastZoomFactor)
            default: break
            }
        }
    @discardableResult
    func setupVision() -> NSError? {
        // Setup Vision parts
        let error: NSError! = nil
        
        guard let modelURL = Bundle.main.url(forResource: "LisencePlate2780", withExtension: "mlmodelc") else {
            return NSError(domain: "VisionObjectRecognitionViewController", code: -1, userInfo: [NSLocalizedDescriptionKey: "Model file is missing"])
        }
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                if request.results?[0].value(forKey: "boundingBox") != nil {
                       
                    self.cropImage(request.results?[0].value(forKey: "boundingBox"), self.pixelBuffer1!)
                    }})
            objectRecognition.imageCropAndScaleOption = .scaleFill
            self.requests = [objectRecognition]
        } catch let error as NSError {
            print("Model loading went wrong: \(error)")
        }
        
        return error
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        connection.videoOrientation = AVCaptureVideoOrientation.portrait
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up)
            try? handler.perform(requests)
        self.pixelBuffer1 = pixelBuffer
        }
    
    func cropImage(_ cropBox1: Any?, _ CVimage: CVPixelBuffer?) {
        
        var image: CGImage?
        VTCreateCGImageFromCVPixelBuffer(CVimage!, options: nil, imageOut: &image)
        guard let image = image else {
            return }
        
        var firstImage = UIImage(cgImage: image)

        var rect = cropBox1 as! CGRect
        rect.origin.y = 1 - rect.origin.y
        
        var cropBox = VNImageRectForNormalizedRect(rect, 480, 640)
        cropBox.origin.y = cropBox.origin.y - cropBox.height
        let newCGimage = (image.cropping(to: cropBox))!
        getNumber(newCGimage)
        var newImage = UIImage(cgImage: newCGimage)
        
    }
    func getNumber(_ cgImage: CGImage){
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)

        // Create a new request to recognize text.
        if #available(iOS 13.0, *) {
            let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
            request.recognitionLevel = .accurate
            request.recognitionLanguages = ["en_US"]
            request.usesLanguageCorrection = false
            do {
                try requestHandler.perform([request])
            } catch {
                print("Unable to perform the requests: \(error).")
            }

        } else {
            return
        }
            }
    
    
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        if #available(iOS 13.0, *) {
            guard let observations =
                    request.results as? [VNRecognizedTextObservation] else {
                return
            }
            let recognizedStrings = observations.compactMap { observation in
                // Return the string of the top VNRecognizedText instance.
                return observation.topCandidates(1).first?.string
            }
            
            // Process the recognized strings.
            let removeCharacters: Set<Character> = [" ", "-", "•", "[", "]", "(", ")", "!", "*", "+"]
            let numbSet: Set<Character> = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

            
            for str in recognizedStrings {
                var string = str
                string.removeAll(where: { removeCharacters.contains($0)})
               
                if string.count >= 6 && !numbSet.isDisjoint(with: string) {
                    //print(string)
                    if self.liscenseDict[string] == nil {
                        self.liscenseDict[string] = 1
                    }
                    else if self.liscenseDict[string]! >= 20 {
                        self.liscenseDict = [:]
                        DispatchQueue.main.async {
                            self.plateNum.text = string
                            
                            if self.currentPlate != string {
                                self.currentPlate = string
                            }
                        }
                    }
                    else {
                        self.liscenseDict[string]! += 1
                    }
                    break
                }
            }
            return
            
        } else {
            return
        }
    }
}

