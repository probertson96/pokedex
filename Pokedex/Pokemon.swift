//
//  Pokemon.swift
//  Pokedex
//
//  Created by Patrick Robertson on 4/11/2015.
//  Copyright © 2015 Patrick Robertson. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonUrl: String!
    
    var name: String {
        return _name
    }
    var pokedexId: Int {
        return _pokedexId
    }
    var description: String {
        get {
            if _description == nil {
                _description = ""
            }
            return _description
        }
    }
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = ""
        }
        return _nextEvolutionText
    }
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    // "/api/v1/pokemon/1/"
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: _pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON { (response) -> Void in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    
                    if let name = types[0]["name"] {
                        self._type = name.capitalizedString
                    }
                    
                    if types.count > 1 {
                        for var x = 1; x < types.count; x++ {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                
                print(self._type)
                
                if let descriptionArray = dict["descriptions"] as? [Dictionary<String, String>] where descriptionArray.count > 0 {
                    
                    if let url = descriptionArray[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, nsurl).responseJSON { (response) in
                            
                            let descriptionResult = response.result
                            if let descriptionDictionary = descriptionResult.value as? Dictionary<String,AnyObject> {
                                if let description = descriptionDictionary["description"] as? String {
                                    self._description = description
                                    print(self._description)
                                }
                            }
                            
                            completed()
                        }
                    }
                    
                } else {
                    self._description = ""
                }
                
                if let evolutionsArray = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutionsArray.count > 0 {
                    if let to = evolutionsArray[0]["to"] as? String {
                        if to.rangeOfString("mega") == nil {
                            if let uri = evolutionsArray[0]["resource_uri"] as? String {
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                
                                let pokemonNumber = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                if let level = evolutionsArray[0]["level"] as? Int {
                                    self._nextEvolutionLevel = "\(level)"
                                } else {
                                    self._nextEvolutionLevel = ""
                                }
                                
                                self._nextEvolutionId = pokemonNumber
                                self._nextEvolutionText = to.capitalizedString
                            }
                        
                        }
                    }
                }
            }
        }
    }
}