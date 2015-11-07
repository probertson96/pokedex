//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Patrick Robertson on 5/11/2015.
//  Copyright © 2015 Patrick Robertson. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var pokedexIdLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var currentEvolutionImage: UIImageView!
    @IBOutlet weak var nextEvolutionImage: UIImageView!
    @IBOutlet weak var evolutionTextLabel: UILabel!
    
    
    
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = pokemon.name
        let image = UIImage(named: "\(pokemon.pokedexId)")
        mainImage.image = image
        currentEvolutionImage.image = image
        
        
        pokemon.downloadPokemonDetails { () -> () in
            self.updateUI()
        }

    }
    
    func updateUI() {
        descriptionLabel.text = pokemon.description
        typeLabel.text = pokemon.type
        defenseLabel.text = pokemon.defense
        attackLabel.text = pokemon.attack
        heightLabel.text = pokemon.height
        pokedexIdLabel.text = "\(pokemon.pokedexId)"
        weightLabel.text = pokemon.weight
        
        if pokemon.nextEvolutionId == "" {
            evolutionTextLabel.text = "No Evolutions!"
            nextEvolutionImage.hidden = true
        } else if pokemon.nextEvolutionLevel == ""{
            var str = "Next Evolution: \(pokemon.nextEvolutionText)"
            evolutionTextLabel.text = str
            nextEvolutionImage.hidden = false
            nextEvolutionImage.image = UIImage(named: pokemon.nextEvolutionId)
        
        } else {
            nextEvolutionImage.hidden = false
            nextEvolutionImage.image = UIImage(named: pokemon.nextEvolutionId)
            var str = "Next Evolution: \(pokemon.nextEvolutionText)"
            
            if pokemon.nextEvolutionLevel != "" {
                str += " - LVL \(pokemon.nextEvolutionLevel)"
                
                evolutionTextLabel.text = str
            }
        }
        
    }

    @IBAction func backButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}
