//
//  ViewController.swift
//  kickstarter_predict
//
//  Created by 刘祥 on 11/3/18.
//  Copyright © 2018 shaneliu90. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource,UINavigationControllerDelegate {
    
    var user_input: [String:Double]=[:]
    let min_duration : Double = 0.00
    let max_duration : Double = 91.00
    let min_goal : Double = 0.01
    let max_goal : Double = 166361390.70
    var result : [String:Double] = [:]

    @IBOutlet weak var goalTextfield: UITextField!
    @IBOutlet weak var durationTextfield: UITextField!
    @IBOutlet weak var countryTextfield: UITextField!
    @IBOutlet weak var categoryTextfield: UITextField!
    
    var categoryPickerView : UIPickerView!
    var countryPickerView : UIPickerView!
    
    let categoryOption : [String] = ["Art", "Comics", "Crafts", "Dance", "Design", "Fashion", "FilmVideo", "Food", "Games", "Journalism", "Music", "Photography", "Publishing", "Technology", "Theater"]
//    let categoryOption : [String] = ["ThreeDPrinting", "Academic", "Accessories", "Action", "Animals",
//                                     "Animation", "Anthologies", "Apparel", "Apps", "Architecture","Art",
//        "ArtBooks", "Audio" ,"Bacon", "Blues", "Calendars", "CameraEquipment",
//        "Candles", "Ceramics", "ChildrensBooks", "Childrenswear", "Chiptune",
//        "CivicDesign", "ClassicalMusic", "Comedy", "ComicBooks", "Comics",
//        "CommunityGardens", "ConceptualArt", "Cookbooks", "CountryFolk",
//        "Couture", "Crafts", "Crochet", "DIY", "DIYElectronics", "Dance", "Design",
//        "DigitalArt", "Documentary", "Drama", "Drinks","ElectronicMusic",
//        "Embroidery", "Events", "Experimental", "FabricationTools", "Faith" ,"Family",
//        "Fantasy" ,"FarmersMarkets", "Farms" ,"Fashion", "Festivals", "Fiction",
//        "FilmVideo", "FineArt", "Flight", "Food", "FoodTrucks", "Footwear",
//        "Gadgets", "Games", "GamingHardware", "Glass", "GraphicDesign",
//        "GraphicNovels", "Hardware", "HipHop", "Horror", "Illustration", "Immersive",
//        "IndieRock", "Installations", "InteractiveDesign", "Jazz", "Jewelry",
//        "Journalism", "Kids", "Knitting", "Latin", "Letterpress", "LiteraryJournals",
//        "LiterarySpaces", "LiveGames", "Makerspaces", "Metal", "MixedMedia",
//        "MobileGames", "MovieTheaters", "Music", "MusicVideos", "Musical",
//        "NarrativeFilm" ,"Nature", "Nonfiction", "Painting", "People",
//        "PerformanceArt", "Performances", "Periodicals" ,"PetFashion", "Photo",
//        "Photobooks", "Photography", "Places", "PlayingCards", "Plays" ,"Poetry",
//        "Pop", "Pottery", "Print", "Printing", "ProductDesign" ,"PublicArt",
//        "Publishing" ,"Punk", "Puzzles", "Quilts", "RB", "RadioPodcasts",
//        "Readytowear", "Residencies", "Restaurants", "Robots", "Rock", "Romance",
//        "ScienceFiction", "Sculpture", "Shorts", "SmallBatch", "Software", "Sound",
//        "SpaceExploration", "Spaces", "Stationery", "TabletopGames", "Taxidermy",
//        "Technology" ,"Television" ,"Textiles" ,"Theater", "Thrillers" ,"Translations",
//        "Typography" ,"Vegan" ,"Video", "VideoArt" ,"VideoGames" ,"Wearables",
//        "Weaving" ,"Web", "Webcomics" ,"Webseries", "Woodworking" ,"Workshops",
//        "WorldMusic" ,"YoungAdult" ,"Zines"]
    let countryOption : [String] = ["AT","AU","BE","CA","CH","DE","DK","ES","FR","GB","HK","IE","IT","JP","LU","MX","OTHER","NL","NO","NZ","SE","SG","US"]
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTextfield.delegate = self
        countryTextfield.delegate = self
    }


    @IBAction func predictTapped(_ sender: UIButton) {
        
        guard let category = categoryTextfield.text, !category.isEmpty else{
            return
        }
        guard let country = countryTextfield.text, !country.isEmpty else{
            return
        }
        guard let goal = goalTextfield.text, !goal.isEmpty else{
            return
        }
        guard let duration = durationTextfield.text, !duration.isEmpty else{
            return
        }
        
        //normalization using min max scaler
        if var goalInDouble = Double(goal) {
            goalInDouble = (goalInDouble - min_goal) / (max_goal - min_goal)
            user_input["normalGoal"] = goalInDouble
        } else {
            return
        }
        
        if var durationInDouble = Double(duration) {
            durationInDouble = (durationInDouble - min_duration) / (max_duration - min_duration)
            
            user_input["normalDuration"] = durationInDouble
        } else {
            return
        }
        
        //assign value to global variable user input
        for countryID in countryOption{
            if countryID == country{
                user_input[countryID] = 1.00
            }else{
                user_input[countryID] = 0.00
            }
        }
        for cateID in categoryOption{
            if cateID == category{
                user_input[cateID] = 1.00
            }else{
                user_input[cateID] = 0.00
            }
        }
        
        if user_input.count == 40{
            result = predictUsingModel(userInput: user_input)
        }
        
        if result.count == 2{
            performSegue(withIdentifier: "gotoResult", sender: self)
        }
        
        
        
    }

    func predictUsingModel(userInput:[String:Double]) -> [String:Double]{
        let coreMLModel = bestmodel()
        guard let caseStatePredict = try? coreMLModel.prediction(normalDuration: user_input["normalDuration"]!, normalGoal: user_input["normalGoal"]!, AT: user_input["AT"]!, AU: user_input["AU"]!, BE: user_input["BE"]!, CA: user_input["CA"]!, CH: user_input["CH"]!, DE: user_input["DE"]!, DK: user_input["DK"]!, ES: user_input["ES"]!, FR: user_input["FR"]!, GB: user_input["GB"]!, HK: user_input["HK"]!, IE: user_input["IE"]!, IT: user_input["IT"]!, JP: user_input["JP"]!, LU: user_input["LU"]!, MX: user_input["MX"]!, OTHER: user_input["OTHER"]!, NL: user_input["NL"]!, NO_: user_input["NO"]!, NZ: user_input["NZ"]!, SE: user_input["SE"]!, SG: user_input["SG"]!, US: user_input["US"]!, Art: user_input["Art"]!, Comics: user_input["Comics"]!, Crafts: user_input["Crafts"]!, Dance: user_input["Dance"]!, Design: user_input["Design"]!, Fashion: user_input["Fashion"]!, FilmVideo: user_input["FilmVideo"]!, Food: user_input["Food"]!, Games: user_input["Games"]!, Journalism: user_input["Journalism"]!, Music: user_input["Music"]!, Photography: user_input["Photography"]!, Publishing: user_input["Publishing"]!, Technology: user_input["Technology"]!, Theater: user_input["Theater"]!) else {
            fatalError("Unexpected runtime error.") }
//        guard let caseStatePredict = try? coreMLModel.prediction(normalDuration:user_input["normalDuration"]!, normalGoal:user_input["normalGoal"]!, AT:user_input["AT"]!, AU:user_input["AU"]!, BE:user_input["BE"]!, CA:user_input["CA"]!, CH:user_input["CH"]!,
//            DE:user_input["DE"]!, DK:user_input["DK"]!, ES:user_input["ES"]!, FR:user_input["FR"]!, GB:user_input["GB"]!,
//            HK:user_input["HK"]!, IE:user_input["IE"]!, IT:user_input["IT"]!, JP:user_input["JP"]!, LU:user_input["LU"]!,
//            MX:user_input["MX"]!, OTHER:user_input["OTHER"]!, NL:user_input["NL"]!, NO_:user_input["NO"]!, NZ:user_input["NZ"]!,
//            SE:user_input["SE"]!, SG:user_input["SG"]!, US:user_input["US"]!, ThreeDPrinting:user_input["ThreeDPrinting"]!, Academic:user_input["Academic"]!,
//            Accessories:user_input["Accessories"]!, Action:user_input["Action"]!, Animals:user_input["Animals"]!,
//            Animation:user_input["Animation"]!, Anthologies:user_input["Anthologies"]!,
//            Apparel:user_input["Apparel"]!, Apps:user_input["Apps"]!, Architecture:user_input["Architecture"]!,
//            Art:user_input["Art"]!, ArtBooks:user_input["ArtBooks"]!, Audio:user_input["Audio"]!,
//            Bacon:user_input["Bacon"]!, Blues:user_input["Blues"]! , Calendars:user_input["Calendars"]!,
//            CameraEquipment:user_input["CameraEquipment"]! , Candles:user_input["Candles"]!, Ceramics:user_input["Ceramics"]!,
//            ChildrensBooks:user_input["ChildrensBooks"]!, Childrenswear:user_input["Childrenswear"]!, Chiptune:user_input["Chiptune"]!,
//            CivicDesign:user_input["CivicDesign"]!, ClassicalMusic:user_input["ClassicalMusic"]!, Comedy:user_input["Comedy"]!,
//            ComicBooks:user_input["ComicBooks"]!, Comics:user_input["Comics"]!, CommunityGardens:user_input["CommunityGardens"]!,
//            ConceptualArt:user_input["ConceptualArt"]!, Cookbooks:user_input["Cookbooks"]!, CountryFolk:user_input["CountryFolk"]!,
//            Couture:user_input["Couture"]!, Crafts:user_input["Crafts"]!, Crochet:user_input["Crochet"]!,
//            DIY:user_input["DIY"]!, DIYElectronics:user_input["DIYElectronics"]!, Dance:user_input["Dance"]!, Design:user_input["Design"]!,
//            DigitalArt:user_input["DigitalArt"]!, Documentary:user_input["Documentary"]!, Drama:user_input["Drama"]!,
//            Drinks:user_input["Drinks"]!, ElectronicMusic:user_input["ElectronicMusic"]!, Embroidery:user_input["Embroidery"]!,
//            Events:user_input["Events"]!, Experimental:user_input["Experimental"]!, FabricationTools:user_input["FabricationTools"]!,
//            Faith:user_input["Faith"]! ,Family:user_input["Family"]!, Fantasy:user_input["Fantasy"]!,
//            FarmersMarkets:user_input["FarmersMarkets"]!, Farms:user_input["Farms"]!, Fashion:user_input["Fashion"]!,
//            Festivals:user_input["Festivals"]!, Fiction:user_input["Fiction"]!, FilmVideo:user_input["FilmVideo"]!,
//            FineArt:user_input["FineArt"]!, Flight:user_input["Flight"]!, Food:user_input["Food"]!,
//            FoodTrucks:user_input["FoodTrucks"]!, Footwear:user_input["Footwear"]!, Gadgets:user_input["Gadgets"]!,
//            Games:user_input["Games"]!, GamingHardware:user_input["GamingHardware"]!, Glass:user_input["Glass"]!, GraphicDesign:user_input["GraphicDesign"]!,
//            GraphicNovels:user_input["GraphicNovels"]!, Hardware:user_input["Hardware"]!, HipHop:user_input["HipHop"]!,
//            Horror:user_input["Horror"]!, Illustration:user_input["Illustration"]!, Immersive:user_input["Immersive"]!,
//            IndieRock:user_input["IndieRock"]!, Installations:user_input["Installations"]!, InteractiveDesign:user_input["InteractiveDesign"]!,
//            Jazz:user_input["Jazz"]!, Jewelry:user_input["Jewelry"]!, Journalism:user_input["Journalism"]!,
//            Kids:user_input["Kids"]!, Knitting:user_input["Knitting"]!, Latin:user_input["Latin"]!, Letterpress:user_input["Letterpress"]!,
//            LiteraryJournals:user_input["LiteraryJournals"]!, LiterarySpaces:user_input["LiterarySpaces"]!, LiveGames:user_input["LiveGames"]!,
//            Makerspaces:user_input["Makerspaces"]!, Metal:user_input["Metal"]!, MixedMedia:user_input["MixedMedia"]!,
//            MobileGames:user_input["MobileGames"]!, MovieTheaters:user_input["MovieTheaters"]!, Music:user_input["Music"]!,
//            MusicVideos:user_input["MusicVideos"]!, Musical:user_input["Musical"]!,
//            NarrativeFilm:user_input["NarrativeFilm"]!, Nature:user_input["Nature"]!, Nonfiction:user_input["Nonfiction"]!,
//            Painting:user_input["Painting"]!, People:user_input["People"]!,
//            PerformanceArt:user_input["PerformanceArt"]!, Performances:user_input["Performances"]!, Periodicals:user_input["Performances"]!,
//            PetFashion:user_input["PetFashion"]!, Photo:user_input["Photo"]!,
//            Photobooks:user_input["Photobooks"]!, Photography:user_input["Photography"]!, Places:user_input["Places"]!,
//            PlayingCards:user_input["PlayingCards"]!, Plays:user_input["Plays"]!, Poetry:user_input["Poetry"]!,
//            Pop:user_input["Pop"]!, Pottery:user_input["Pottery"]!, Print:user_input["Print"]!, Printing:user_input["Printing"]!,
//            ProductDesign:user_input["ProductDesign"]!, PublicArt:user_input["PublicArt"]!,
//            Publishing:user_input["Publishing"]!, Punk:user_input["Punk"]!, Puzzles:user_input["Puzzles"]!, Quilts:user_input["Quilts"]!,
//            RB:user_input["RB"]!, RadioPodcasts:user_input["RadioPodcasts"]!,
//            Readytowear:user_input["Readytowear"]!, Residencies:user_input["Residencies"]!, Restaurants:user_input["Restaurants"]!,
//            Robots:user_input["Robots"]!, Rock:user_input["Rock"]!, Romance:user_input["Romance"]!,
//            ScienceFiction:user_input["ScienceFiction"]!, Sculpture:user_input["Sculpture"]!, Shorts:user_input["Shorts"]!,
//            SmallBatch:user_input["SmallBatch"]!, Software:user_input["Software"]!, Sound:user_input["Sound"]!,
//            SpaceExploration:user_input["SpaceExploration"]!, Spaces:user_input["Spaces"]!, Stationery:user_input["Stationery"]!,
//            TabletopGames:user_input["TabletopGames"]!, Taxidermy:user_input["Taxidermy"]!,
//            Technology:user_input["Technology"]!, Television:user_input["Television"]!, Textiles:user_input["Textiles"]!, Theater:user_input["Theater"]!,
//            Thrillers:user_input["Thrillers"]!, Translations:user_input["Translations"]!, Typography:user_input["Typography"]!,
//            Vegan:user_input["Vegan"]!, Video:user_input["Video"]!, VideoArt:user_input["VideoArt"]!, VideoGames:user_input["VideoGames"]!,
//            Wearables:user_input["Wearables"]!, Weaving:user_input["Weaving"]!, Web:user_input["Web"]!, Webcomics:user_input["Webcomics"]!,
//            Webseries:user_input["Webseries"]!, Woodworking:user_input["Woodworking"]!, Workshops:user_input["Workshops"]!,
//            WorldMusic:user_input["WorldMusic"]!, YoungAdult:user_input["YoungAdult"]!, Zines:user_input["Zines"]!) else {
//            fatalError("Unexpected runtime error.")
//        }
        
        let state = Double(caseStatePredict.Y)
        let probability = Double(caseStatePredict.classProbability[1]!)
//        print(probability[1]!)
//        print(probability[0]!)
//        print(state)
        
        
        return ["state": state, "confidence": probability]
    }
    
    
    
    // MARK - FUNCTION TO CREATE UIPickerView with ToolBar
    func pickUp(_ textField : UITextField){

        
        // UIPickerView for category 0 -  country 1
        if textField.tag == 0{

            self.categoryPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
            self.categoryPickerView.delegate = self
            self.categoryPickerView.dataSource = self
            self.categoryPickerView.backgroundColor = UIColor.white
            textField.inputView = self.categoryPickerView
            
        }else if textField.tag == 1{
            self.countryPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
            self.countryPickerView.delegate = self
            self.countryPickerView.dataSource = self
            self.countryPickerView.backgroundColor = UIColor.white
            textField.inputView = self.countryPickerView
        }
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    // MARK - DATA SOURCE METHOD OF PICKERVIEW
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPickerView{
            return categoryOption.count
        }else if pickerView == countryPickerView{
            return countryOption.count
        }else{
            return 0
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPickerView{
            return categoryOption[row]
        }else if pickerView == countryPickerView{
            return countryOption[row]
        }else{
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == categoryPickerView{
            categoryTextfield.text = categoryOption[row]
        }else if pickerView == countryPickerView{
            countryTextfield.text = countryOption[row]
        }
    }
    
    // MARK - TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0{
            self.pickUp(categoryTextfield)
        }else if textField.tag == 1{
            self.pickUp(countryTextfield)
        }
    }
    
    // - MARK - FUNCTIONS FOR TOOLBAR BUTTON
    @objc func doneClick(textField: UITextField) {
        self.view.endEditing(true)
    }
    @objc func cancelClick(textField: UITextField) {
        self.view.endEditing(true)
    }
    
    // MARK - to make return key as done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag
        {
        case 0:
            categoryTextfield.resignFirstResponder();
        case 1:
            countryTextfield.resignFirstResponder();
        case 2:
            durationTextfield.resignFirstResponder();
        case 3:
            goalTextfield.resignFirstResponder();
        default:
            break
        }
        return true
    }
    
    
    
    //for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoResult"{
            let destinationVC = segue.destination as! ResultVC
            destinationVC.passedResult = Int(self.result["state"]!)
            destinationVC.confidence = self.result["confidence"]!
        }
    }
}

