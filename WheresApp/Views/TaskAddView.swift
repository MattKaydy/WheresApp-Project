//
//  TaskAddView.swift
//  WheresApp
//
//  Created by macuser on 16/3/2023.
//

import SwiftUI
import CoreData
import MLImage
import MLKit
import UIKit
import CoreLocation
import Foundation
import Reg
#if canImport(Vision)
import Vision


struct TaskAddView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var viewRouter: ViewRouter
    
    @State var receipt_location: String
    @State var receipt_time: String
    @State var receipt_name: String
    @State var receipt_item_names: [String]
    @State var receipt_item_prices: [Decimal]
    @State var receipt_grand_total: Float
    @State var keywords: [String]
    @State var name: String
    @State var nature: String
    @State var type: String
    @State var loc_langtitude: String
    @State var loc_longtitude: String
    @State var loc_string: String
    @State var credit_card_no: String
    @State var credit_card_expiry_date: String
    @State var credit_card_name: String
    @State var keywords_string: String
    
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    var catagories = ["General" , "Credit Card", "Receipts"]
    @State var selectedCatagory = "General"
    @State var keywordsText = "";
    
    @State private var showingAlert = false
    
    //var dateComponents = $credit_card_expiry_date
    //dateComponents?.calendar = Calendar.current
    //let dateFormater = DateFormatter()
    //dateFormater.dateStyle = .short
    //let date = dateComponents?.date.flatMap(dateFormater.string)
    
    //private lazy var analyzer = ImageAnalyzer(delegate: self)
    
    
    private let numberFormatter: NumberFormatter = {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.generatesDecimalNumbers = true
                return formatter
            }()
    
    var body: some View {
        
        NavigationView{
            VStack {
                Button {
                    shouldShowImagePicker.toggle()
                } label: {
                    VStack {
                        if let image = self.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 143, height: 200)
                        } else {
                            Image(systemName: "photo.fill")
                                .font(.system(size: 80))
                                .padding()
                                .foregroundColor(Color(.label))
                        }
                    }
//                    .overlay(RoundedRectangle(cornerRadius: 80)
//                        .stroke(Color.black, lineWidth: 3)
//                    )
                }
                
                Form {
                    Section() {
                        Button("Save", action: saveAction)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    
                    Section(header: Text("Catagory")) {
                        Picker("Select a Catagory", selection: $selectedCatagory) {
                            ForEach(catagories, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                    
                    if (selectedCatagory != "Receipts") {
                        Section(header: Text("Item Name")) {
                            TextField("Item Name", text: $name )
                            
                        }
                    }
                    
                    
                    if (selectedCatagory == "General") {
                        Section(header: Text("Type")) {
                            TextField("Type", text: $type )
                        }
                        
                        Section(header: Text("Location")) {
                            TextField("Location", text: $loc_string )
                                .disabled(true)
                        }
                        
                        Section(header: Text("Keywords")) {
    //                        TextField("Keywords", text: $keywordsText)
    //                            .disabled(true)
                            List(keywords, id: \.self) { keyword in
                                Text(keyword)
                            }
                            
                        }
                    }
                    
                    else if (selectedCatagory == "Credit Card") {
                        Section(header: Text("Location")) {
                            TextField("Location", text: $loc_string )
                                .disabled(true)
                        }
                        
                        Section(header: Text("Credit Card Name")) {
                            TextField("Credit Card Name", text: $credit_card_name )
                                .disabled(true)
                        }
                        
                        Section(header: Text("Credit Card No")) {
                            TextField("Credit Card No", text: $credit_card_no )
                                .disabled(true)
                        }
                        
                        
                       
                        Section(header: Text("Credit Card Expr Date")) {
                            TextField("Credit Card Expr Date", text: $credit_card_expiry_date )
                                .disabled(true)
                        }
                    }
                    
                    else if (selectedCatagory == "Receipts") {
                        Section(header: Text("Store Name")) {
                            TextField("Store Name", text: $receipt_name )
                                .disabled(true)
                        }
                        
                        Section(header: Text("Time")) {
                            TextField("Time", text: $receipt_time )
                                .disabled(true)
                        }
                        
                        Section(header: Text("Location")) {
                            TextField("Location", text: $receipt_location )
                                .disabled(true)
                        }
                        
                        Section(header: Text("Items")) {
                            List(receipt_item_names, id: \.self) { receipt_item_name in
                                Text(receipt_item_name)
                            }
                        }
                        
                        Section(header: Text("Grand Total")) {
                            let grandTotal = $receipt_grand_total
                            TextField("Grand Total", value: $receipt_grand_total, formatter: numberFormatter)
                        }
                        
                        
                    }
                    
                    
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(selectedCatagory: $selectedCatagory, name: $name, nature: $nature, image: $image, keywordsText: $keywordsText, keywords: $keywords, type: $type, loc_langtitude: $loc_langtitude, loc_longtitude: $loc_longtitude, loc_string: $loc_string, credit_card_no: $credit_card_no, credit_card_expiry_date: $credit_card_expiry_date, credit_card_name: $credit_card_name, receipt_location: $receipt_location, receipt_time: $receipt_time, receipt_name: $receipt_name, receipt_item_names: $receipt_item_names, receipt_item_prices: $receipt_item_prices, receipt_grand_total: $receipt_grand_total, keywords_string: $keywords_string )
                .ignoresSafeArea()
        }
        .alert(isPresented: $showingAlert, content: { NameIsEmptyError() })
        
        
    }
    
    func NameIsEmptyError() -> Alert {
                Alert(
                    title: Text("Error"),
                    message: Text("Please assign a name before saving"),
                    dismissButton: .default(Text("Okay")))
        }
    
    func clearScreen() {
        name = ""
        keywords = []
        nature = ""
        type = ""
        loc_langtitude = ""
        loc_longtitude = ""
        loc_string = ""
        image = nil
        keywords_string = ""
 
        receipt_time = ""
        receipt_name = ""
        receipt_item_prices = []
        receipt_item_names = []
        receipt_grand_total = 0
        
        credit_card_no = ""
        credit_card_expiry_date = ""
        credit_card_name = ""
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func saveAction() {
        
        
//        @State var keywords: [String]
//        @State var name: String
//        @State var nature: String
//        @State var type: String
//        @State var loc_langtitude: String
//        @State var loc_longtitude: String
//        @State var loc_string: String
        
        
        
        if (selectedCatagory != "Receipts" && (name == "" || image == nil)) {
            showingAlert = true
        }
        else if (selectedCatagory == "Receipts" && image == nil) {
            showingAlert = true
        }
        else {
            let newItem = Item(context: viewContext)
            
            newItem.name = name
            newItem.keywords = keywords
            newItem.nature = nature
            newItem.type = type
            newItem.loc_langtitude = loc_langtitude
            newItem.loc_longtitude = loc_longtitude
            newItem.loc_string = loc_string
            newItem.credit_card_name = credit_card_name
            newItem.credit_card_no = credit_card_no
            newItem.credit_card_expiry_date = credit_card_expiry_date
            newItem.receipt_location = receipt_location
            newItem.receipt_time = receipt_time
            newItem.receipt_name = receipt_name
            newItem.receipt_item_names = receipt_item_names
            newItem.receipt_item_prices = receipt_item_prices
            newItem.receipt_grand_total = receipt_grand_total
            
            newItem.keywords_string = keywords.joined(separator: " ")
            
            print(newItem.keywords_string)
            
            if (selectedCatagory == "General") {
                newItem.nature = "General"
            }
            else if (selectedCatagory == "Credit Card") {
                newItem.nature = "Credit Card"
            }
            else if (selectedCatagory == "Receipts") {
                newItem.nature = "Receipts"
            }
            
            if (image != nil) {
                let pngImageData = image?.pngData()
                newItem.image_data = pngImageData
                
            }
            
            do {
                try self.viewContext.save()
            }
            catch let error as NSError {
                print("Failed: \(error)")
            }
            
            
            
            clearScreen()
            
            if (selectedCatagory == "General") {
                viewRouter.currentView = .item
            }
            else if (selectedCatagory == "Credit Card") {
                viewRouter.currentView = .search
            }
            else if (selectedCatagory == "Receipts") {
                viewRouter.currentView = .receipt
            }
            
            
        }
        
    }
    
    func addKeyword() {
        
    }
    
    func deleteKeyword() {
        
    }
    
    
    
    
    
    struct ImagePicker: UIViewControllerRepresentable {
        
        @Binding var selectedCatagory: String
        @Binding var name: String
        @Binding var nature: String
        @Binding var image: UIImage?
        @Binding var keywordsText : String
        @Binding var keywords: [String]
        @Binding var type: String
        @Binding var loc_langtitude: String
        @Binding var loc_longtitude: String
        @Binding var loc_string: String
        @Binding var credit_card_no: String
        @Binding var credit_card_expiry_date: String
        @Binding var credit_card_name: String
        @Binding var receipt_location: String
        @Binding var receipt_time: String
        @Binding var receipt_name: String
        @Binding var receipt_item_names: [String]
        @Binding var receipt_item_prices: [Decimal]
        @Binding var receipt_grand_total: Float
        @Binding var keywords_string: String
        
        @StateObject var locationDataManager = LocationDataManager()
        
        
        
        let controller = UIImagePickerController()
        let formatter = NumberFormatter()
        
        
        func decimal(with string: String) -> NSDecimalNumber {
            return formatter.number(from: string) as? NSDecimalNumber ?? 0
        }
        
        func toFloat(with string: String) -> Float {
            let numberFormatter = NumberFormatter()
            let number = numberFormatter.number(from: string)
            if (number != nil) {
                let numberFloatValue = number!.floatValue
                
                return numberFloatValue
            }
            else {
                return 0
            }
            
        }
        
        
        enum Candidate: Hashable {
            case number(String), name(String)
            case expireDate(DateComponents)
        }
        
        typealias PredictedCount = Int
        
        @State var predictedCardInfo: [Candidate: PredictedCount] = [:]
        
        
        func makeCoordinator() -> Coordinator {
            return Coordinator(parent: self)
        }
        
        class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
            
            let parent: ImagePicker
            var resultsText = ""
            
            init(parent: ImagePicker) {
                self.parent = parent
            }
            
            func clearScreen() {
                parent.name = ""
                parent.keywords = []
                parent.nature = ""
                parent.type = ""
                parent.loc_langtitude = ""
                parent.loc_longtitude = ""
                parent.loc_string = ""
                parent.image = nil
                parent.keywords_string = ""
         
                parent.receipt_time = ""
                parent.receipt_name = ""
                parent.receipt_item_prices = []
                parent.receipt_item_names = []
                parent.receipt_grand_total = 0
                
                parent.credit_card_no = ""
                parent.credit_card_expiry_date = ""
                parent.credit_card_name = ""
            }
            
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                
                clearScreen()
                
                parent.image = info[.originalImage] as? UIImage
                picker.dismiss(animated: true)
                print("Image is picked");
                
                
                
                
                // After the image is picked, send the image for processing.
                
                if (self.parent.selectedCatagory == "Credit Card") {
                    self.parent.analyzeCreditCard(image: (parent.image)!)
                }
                else if (self.parent.selectedCatagory == "General") {
                    detectTextOnDevice(image: parent.image)
                    detectLabelOnDevice(image: parent.image)
                    self.parent.getLocation()
                }
                else if (self.parent.selectedCatagory == "Receipts") {
                    self.parent.analyzeReceipt(image: parent.image)
                }
                
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                picker.dismiss(animated: true)
            }
            
            private func detectLabelOnDevice(image:UIImage?) {
                guard let image = image else { return }
                
                let options: CommonImageLabelerOptions!
                options = ImageLabelerOptions()
                let labeler = ImageLabeler.imageLabeler(options: options)
                
                // Initialize a `VisionImage` object with the given `UIImage`.
                let visionImage = VisionImage(image: image)
                visionImage.orientation = image.imageOrientation
                
                self.resultsText += "Running Image Labeling..\n"
                process(visionImage, with: labeler)
            }
            
            
            
            private func process(_ visionImage: VisionImage, with labeler: ImageLabeler?) {
                
                print("Processing image for image labeling for " + VisionImage.description())
                
                weak var weakSelf = self
                
                guard let strongSelf = weakSelf else {
                    print("Self is nil!")
                    return
                }
                
                labeler?.process(visionImage) { labels, error in
                    guard let strongSelf = weakSelf else {
                        print("Self is nil!")
                        return
                    }
                    
                    guard error == nil, let labels = labels else {
                        // Error handling
                        let errorString = error?.localizedDescription ?? Constants.detectionNoResultsMessage
                        strongSelf.resultsText = "Image labeler recognizer failed with error: \(errorString)"
                        let resultsAlertController = UIAlertController(
                            title: "Detection Results",
                            message: nil,
                            preferredStyle: .actionSheet
                        )
                        resultsAlertController.addAction(
                            UIAlertAction(title: "OK", style: .destructive) { _ in
                                resultsAlertController.dismiss(animated: true, completion: nil)
                            }
                        )
                        resultsAlertController.message = strongSelf.resultsText
                        print(strongSelf.resultsText)
                        
                        return
                    }
                    
                    
                    
                    print("printing labels...")
                    for label in labels {
                        let labelText = label.text
                        let confidence = label.confidence
                        let index = label.index
                        
                        print(labelText, " ", confidence, " ", index)
                    }
                    
                    let t = DispatchTime.now() + 2.0
                    
                    DispatchQueue.main.asyncAfter(deadline: t) {
                        self.parent.type = labels[0].text
                    }
                    
                    
                }
            }
            
            private func detectTextOnDevice(image: UIImage?) {
                guard let image = image else { return }
                let textRecognizer = TextRecognizer.textRecognizer()
                
                // Initialize a `VisionImage` object with the given `UIImage`.
                let visionImage = VisionImage(image: image)
                visionImage.orientation = image.imageOrientation
                
                self.resultsText += "Running Text Recognition...\n"
                process(visionImage, with: textRecognizer)
            }
            
            private func process(_ visionImage: VisionImage, with textRecognizer: TextRecognizer?) {
                print("Processing image for text recognition for " + VisionImage.description())
                
                weak var weakSelf = self
                
                textRecognizer?.process(visionImage) { result, error in
                    guard let  strongSelf = weakSelf else {
                        print("Self is nil!")
                        return
                    }
                    
                    guard error == nil, let result = result else {
                        // Error handling
                        let errorString = error?.localizedDescription ?? Constants.detectionNoResultsMessage
                        strongSelf.resultsText = "Text recognizer failed with error: \(errorString)"
                        let resultsAlertController = UIAlertController(
                            title: "Detection Results",
                            message: nil,
                            preferredStyle: .actionSheet
                        )
                        resultsAlertController.addAction(
                            UIAlertAction(title: "OK", style: .destructive) { _ in
                                resultsAlertController.dismiss(animated: true, completion: nil)
                            }
                        )
                        resultsAlertController.message = result?.text
                        print(self.resultsText)
                        
                        return
                    }
                    
                    
                    // Recognized text
                    let resultText = result.text
                    
                    let t = DispatchTime.now() + 2.0
                    DispatchQueue.main.asyncAfter(deadline: t) {
                        self.parent.keywords.removeAll()
                        self.parent.keywordsText = resultText
                        for block in result.blocks {
                            for line in block.lines {
                                let lineText = line.text
                                self.parent.keywords.append(lineText)
                            }
                        }
                    }
                    
                    print(resultText)
                    
                }
                
            }
            
            /*
            private func analyzeReceipt(image: UIImage?) {
                
                guard let image = image else { return }
                let textRecognizer = TextRecognizer.textRecognizer()
                
                let processedImage = parent.convertImageToGrayScale(originalImage: image)
                
                // Initialize a `VisionImage` object with the given `UIImage`.
                let visionImage = VisionImage(image: image)
                visionImage.orientation = image.imageOrientation
                
                self.resultsText += "Running Text Recognition...\n"
                process(visionImage, with: textRecognizer)
            }
            
            private func performAnalyzeReceipt(_ visionImage: VisionImage, with textRecognizer: TextRecognizer?) {
                print("Analyzing Receipt " + VisionImage.description())
                
                weak var weakSelf = self
                
                textRecognizer?.process(visionImage) { result, error in
                    guard let  strongSelf = weakSelf else {
                        print("Self is nil!")
                        return
                    }
                    
                    guard error == nil, let result = result else {
                        // Error handling
                        let errorString = error?.localizedDescription ?? Constants.detectionNoResultsMessage
                        strongSelf.resultsText = "Text recognizer failed with error: \(errorString)"
                        let resultsAlertController = UIAlertController(
                            title: "Detection Results",
                            message: nil,
                            preferredStyle: .actionSheet
                        )
                        resultsAlertController.addAction(
                            UIAlertAction(title: "OK", style: .destructive) { _ in
                                resultsAlertController.dismiss(animated: true, completion: nil)
                            }
                        )
                        resultsAlertController.message = result?.text
                        print(self.resultsText)
                        
                        return
                    }
                    
                    
                    // Recognized text
                    let resultText = result.text
                    var analyzedText:[String] = []
                    
                    let t = DispatchTime.now() + 2.0
                    DispatchQueue.main.asyncAfter(deadline: t) {
                        self.parent.keywords.removeAll()
                        self.parent.keywordsText = resultText
                        for block in result.blocks {
                            for line in block.lines {
                                let lineText = line.text
                                print(lineText)
                                analyzedText.append(lineText)
                            }
                        }
                        self.parent.getPrices(listOfRecognizedText: analyzedText)
                        self.parent.getReceiptLocation(listOfRecognizedText: analyzedText)
                        self.parent.getReceiptTime(listOfRecognizedText: analyzedText)
                    }
                    
                    
                    
                }
                
            }
            */
            
        }
        
        func makeUIViewController(context: Context) -> some UIViewController {
            controller.delegate = context.coordinator
            
            #if targetEnvironment(simulator)
            controller.sourceType = .photoLibrary
            #else
            controller.sourceType = .camera
            #endif
            /*
            if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
                //controller.sourceType = .camera
                
            }
            else {
                controller.sourceType = .photoLibrary
            }
             */
            
            return controller
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        
        func getLocation() {
            
            switch locationDataManager.locationManager.authorizationStatus {
            case .authorizedWhenInUse:
                let t = DispatchTime.now() + 2.0
                
                
                DispatchQueue.main.asyncAfter(deadline: t) {
                    loc_langtitude = locationDataManager.locationManager.location?.coordinate.latitude.description ?? "0"
                    loc_longtitude = locationDataManager.locationManager.location?.coordinate.longitude.description ?? "0"
                    getAddressFromLatLon(pdblLatitude: loc_langtitude, withLongitude: loc_longtitude)
                    print("Location: ", loc_langtitude, " ", loc_longtitude, " ", loc_string)
                }
                
                
            default:
                print("No permissions")
            }
            
            
        }
        
        func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            //21.228124
            let lon: Double = Double("\(pdblLongitude)")!
            //72.833770
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon
            
            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
            
            var addressString : String = ""
            
            ceo.reverseGeocodeLocation(loc, completionHandler:
                                        {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country)
                    print(pm.locality)
                    print(pm.subLocality)
                    print(pm.thoroughfare)
                    print(pm.postalCode)
                    print(pm.subThoroughfare)
                    //var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                    print(addressString)
                    loc_string = addressString
                    
                    
                }
            })
            
            
            
        }
        
        // MARK: Credit Card Scanner stuff:
        
        
        
        func analyzeCreditCard(image: UIImage) {
            let processedImage = binarizeImage(image, threshold: 126)
            
            let requestHandler = VNImageRequestHandler(
                cgImage: (processedImage?.cgImage!)!,
                orientation: .up,
                options: [:]
            )
            
            
            lazy var requestHandlerSettings: ((VNRequest, Error?) -> Void)? = { request, _ in
                let creditCardNumber: Regex = #"(?:\d[ -]*?){13,16}"#
                let month: Regex = #"(\d{2})\/\d{2}"#
                let year: Regex = #"\d{2}\/(\d{2})"#
                let wordsToSkip = ["mastercard", "jcb", "visa", "express", "bank", "card", "platinum", "reward"]
                // These may be contained in the date strings, so ignore them only for names
                let invalidNames = ["expiration", "valid", "since", "from", "until", "month", "year"]
                let name: Regex = #"([A-z]{2,}\h([A-z.]+\h)?[A-z]{2,})"#
                var credit_card_expiry_date_obj: DateComponents?
                
                guard let results = request.results as? [VNRecognizedTextObservation] else { return }
                
                let maxCandidates = 1
                for result in results {
                    guard
                        let candidate = result.topCandidates(maxCandidates).first,
                        candidate.confidence > 0.1
                    else { continue }
                    
                    
                    
                    let string = candidate.string
                    let containsWordToSkip = wordsToSkip.contains { string.lowercased().contains($0) }
                    if containsWordToSkip { continue }
                    
                    if let cardNumber = creditCardNumber.firstMatch(in: string)?
                        .replacingOccurrences(of: " ", with: "")
                        .replacingOccurrences(of: "-", with: "") {
                        credit_card_no = cardNumber
                        
                        // the first capture is the entire regex match, so using the last
                    } else if let month = month.captures(in: string).last.flatMap(Int.init),
                              // Appending 20 to year is necessary to get correct century
                              let year = year.captures(in: string).last.flatMap({ Int("20" + $0) }) {
                        credit_card_expiry_date_obj = DateComponents(year: year, month: month)
                        
                        
                    } else if let name = name.firstMatch(in: string) {
                        let containsInvalidName = invalidNames.contains { name.lowercased().contains($0) }
                        if containsInvalidName { continue }
                        credit_card_name = name
                        
                    } else {
                        continue
                    }
                }
                
                // Name
                let temp_name = credit_card_name
                let name_count = predictedCardInfo[.name(temp_name), default: 0]
                predictedCardInfo[.name(temp_name)] = name_count + 1
                if name_count > 2 {
                    credit_card_name = temp_name
                }
                
                // ExpireDate
                
                
                let date = credit_card_expiry_date_obj
                let date_count: Int
                if (date != nil) {
                    date_count = predictedCardInfo[.expireDate(date!), default: 0]
                    predictedCardInfo[.expireDate(date!)] = date_count + 1
                }
                else {
                    date_count = 0
                }
                
                
                
                if date_count > 2 {
                    credit_card_expiry_date_obj = date
                    
                }
                
                
                
                // Number
                let temp_number = credit_card_no
                let num_count = predictedCardInfo[.number(temp_number), default: 0]
                predictedCardInfo[.number(temp_number)] = num_count + 1
                if num_count > 2 {
                    credit_card_no = temp_number
                }
                
                if (credit_card_expiry_date_obj != nil) {
                    let test = Calendar.current.date(from: credit_card_expiry_date_obj!)
                    var dateComponents = credit_card_expiry_date_obj
                    dateComponents?.calendar = Calendar.current
                    let dateFormater = DateFormatter()
                    dateFormater.dateStyle = .short
                    credit_card_expiry_date = dateFormater.string(from: test!)
                    print("expiry date: " + credit_card_expiry_date)
                }
                else {
                    credit_card_expiry_date = ""
                }
                
                if credit_card_no != nil {
                    
                }
            }
            
            lazy var request = VNRecognizeTextRequest(completionHandler: requestHandlerSettings)
            
            do {
                
                try requestHandler.perform([request])
                
            } catch {
                
            }
            
            // Testing Pods
        }
        
        // MARK: Receipt Scanner Handler
        
        func convertImageToGrayScale(originalImage: UIImage) -> UIImage {
            var noir: UIImage? {
                let context = CIContext(options: nil)
                guard let currentFilter = CIFilter(name: "CIPhotoEffectNoir") else { return nil }
                currentFilter.setValue(CIImage(image: originalImage), forKey: kCIInputImageKey)
                if let output = currentFilter.outputImage,
                   let cgImage = context.createCGImage(output, from: output.extent) {
                    return UIImage(cgImage: originalImage.cgImage!, scale: originalImage.scale, orientation: originalImage.imageOrientation)
                }
                return nil
            }
            
            return noir!
            
            
        }
        
        func binarizeImage(_ image: UIImage, threshold: Float) -> UIImage? {
            guard let inputCGImage = image.cgImage else {
                return nil
            }
            
            let width = inputCGImage.width
            let height = inputCGImage.height
            
            let colorSpace = CGColorSpaceCreateDeviceGray()
            let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
            let bytesPerRow = width
            
            guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
                return nil
            }
            
            let rect = CGRect(x: 0, y: 0, width: width, height: height)
            context.draw(inputCGImage, in: rect)
            
            guard let data = context.data else {
                return nil
            }
            
            let buffer = data.bindMemory(to: UInt8.self, capacity: width * height)
            
            for i in 0..<width * height {
                let pixelValue = Float(buffer[i])
                if pixelValue > threshold {
                    buffer[i] = 255
                } else {
                    buffer[i] = 0
                }
            }
            
            guard let outputCGImage = context.makeImage() else {
                return nil
            }
            
            let outputImage = UIImage(cgImage: outputCGImage)
            return outputImage
        }
        
        func applyGaussianBlur(to image: UIImage, withRadius radius: CGFloat) -> UIImage? {
            let context = CIContext(options: nil)
            
            guard let inputImage = CIImage(image: image) else {
                return nil
            }
            
            let filter = CIFilter(name: "CIGaussianBlur")
            filter?.setValue(inputImage, forKey: kCIInputImageKey)
            filter?.setValue(radius, forKey: kCIInputRadiusKey)
            
            guard let outputImage = filter?.outputImage,
                  let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
                return nil
            }
            
            let blurredImage = UIImage(cgImage: cgImage)
            return blurredImage
        }
        
        
        func getPrices(listOfRecognizedText: [String]) {
            
            let regexDollar = try! Regex("[+-]?([0-9]*[.])?[0-9]+")
            let regexNoDollar = try! Regex("^[0-9]{1,5}\\.[0-9]{2}$")
            let regexFloatAndWhole = try! Regex("\\d*\\.\\d*")
            var processedFloatResults = [Float]()
            var floatLineID = [Int]()
            
            var lineCount = 0
            
            // Replace floats
            for var textStrings in listOfRecognizedText {
                if (textStrings.contains("$")) {
                    textStrings = textStrings.replacingOccurrences(of: "$", with: "")
                }
                if (regexFloatAndWhole.hasMatch(in: textStrings)) {
                    processedFloatResults.append(Float(textStrings) ?? 0)
                    floatLineID.append(lineCount)
                }
                lineCount += 1
            }
            
            // Get total
            if (processedFloatResults != nil && !(processedFloatResults.isEmpty)) {
                receipt_grand_total = processedFloatResults.max()!
            }
            
            // Get store name
            
            if (listOfRecognizedText.count == 0 || listOfRecognizedText == nil) {
                return
            }
            
            receipt_name = listOfRecognizedText[0]
            
            // Get items
            var i = 0
            if (processedFloatResults != nil && !(processedFloatResults.isEmpty)) {
                for floatID in floatLineID {
                    if (toFloat(with: listOfRecognizedText[floatID]) != receipt_grand_total) {
                        if (floatID != 0) {
                            
                            var curString = listOfRecognizedText[floatID]
                            
                            if (curString.contains("$")) {
                                curString = curString.replacingOccurrences(of: "$", with: "")
                            }
                            
                            if (toFloat(with: curString) != receipt_grand_total) {
                                receipt_item_prices.append(decimal(with: curString) as Decimal)
                                receipt_item_names.append(listOfRecognizedText[floatID - 1] + " = " + listOfRecognizedText[floatID])
                            }
                            
                                                        
                        }
                        
                        
                    }
                    i += 1
                }
            }
            
            
        }
        
        func getReceiptLocation(listOfRecognizedText: [String]) {
            let regexAddress = try! Regex("(.* \\d{4})")
            
            for textStrings in listOfRecognizedText {
                if (regexAddress.hasMatch(in: textStrings)) {
                    receipt_location = textStrings
                    break
                }
            }
            
        }
        
        func getReceiptTime(listOfRecognizedText: [String]) {
            let regexDate = try! Regex("(?=((?:(?:(?:0[1-9]|1[0-2]|[1-9])[\\-/., ](?:3[0-1]|0[1-9]|[1-2]\\d|[1-9])|(?:3[0-1]|0[1-9]|[1-2]\\d|[1-9])[\\-/., ](?:0[1-9]|1[0-2]|[1-9]))[-/., ](?:19|20)?\\d{2}(?!\\:)|(?:19|20)?\\d{2}[\\-/., ](?:0[1-9]|1\\d|[1-9])[\\-/., ](?:3[0-1]|0[1-9]|[1-2]\\d|[1-9](?!\\d)))))")
            let regexTime = try! Regex("(?=((?: |^)[0-2]?\\d[:. ]?[0-5]\\d(?:[:. ]?[0-5]\\d)?(?:[ ]?[ap]\\.?m?\\.?)?(?: |$)))")
            
            for textStrings in listOfRecognizedText {
                if (regexDate.hasMatch(in: textStrings)) {
                    
                    let parsedDate = regexDate.captures(in: textStrings).last
                    let parsedTime = regexTime.captures(in: textStrings).last
                    
                    let chrono = Chrono.shared
                    
                    if (parsedDate != nil) {
                        var date = chrono.dateFrom(naturalLanguageString: textStrings)
                        print(date)
                        if (date != nil) {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateStyle = .short
                            dateFormatter.timeStyle = .medium
                            receipt_time = dateFormatter.string(from: date!)
                            print(receipt_time)
                        }
                        
                    }
                    
                    break
                }
                
            }
            
        }
        
        
        
        func analyzeReceipt(image: UIImage?) {
            
            
            let binarizedImage = binarizeImage(image!, threshold: 127)
            let processedImage = applyGaussianBlur(to: binarizedImage!, withRadius: 1.0)
            
            
            let recognizeTextRequest = VNRecognizeTextRequest  { (request, error) in
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    print("Error: \(error! as NSError)")
                    return
                }
                
                var lineCount = 0
                
                var listOfRecognizedText = [String]()
                
                for currentObservation in observations {
                    let topCandidate = currentObservation.topCandidates(3)
                    var recognizedText = topCandidate[0]
                    var temp_receipt_name = ""
                    //OCR Results
                    print(recognizedText.string)
                    
                    listOfRecognizedText.append(recognizedText.string)
                    
                    lineCount+=1
                        
                }
                getPrices(listOfRecognizedText: listOfRecognizedText)
                getReceiptLocation(listOfRecognizedText: listOfRecognizedText)
                getReceiptTime(listOfRecognizedText: listOfRecognizedText)
            }
            
           
            recognizeTextRequest.recognitionLevel = .accurate
            recognizeTextRequest.minimumTextHeight = 0.0
            recognizeTextRequest.usesLanguageCorrection = true
            recognizeTextRequest.revision = 1
            recognizeTextRequest.recognitionLanguages = ["en_US"]
            
            performReceiptAnalyzer(processedImage!, recognizeTextRequest: recognizeTextRequest)
            
        }
        
        
        func performReceiptAnalyzer(_ image: UIImage, recognizeTextRequest: VNRecognizeTextRequest) {
            guard let cgImage = image.cgImage else {
                return
            }
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                DispatchQueue.global(qos: .userInteractive).async {
                    do {
                        try handler.perform([recognizeTextRequest])
                    }
                    catch let error as NSError {
                        print("Failed: \(error)")
                    }
                }
        }
        
        
     
    }
}

// MARK: - Enums

private enum Constants {
  static let images = ["image_has_text.jpg"]
  static let detectionNoResultsMessage = "No results returned."
  static let failedToDetectObjectsMessage = "Failed to detect objects in image."
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKeyDictionary(
  _ input: [UIImagePickerController.InfoKey: Any]
) -> [String: Any] {
  return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value) })
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey)
  -> String
{
  return input.rawValue
}



#endif
