    func selectFavoriteCharacter(index: Int) {
        let character = getCharacterData(index: index)
        
        isLoading.value = true
        
        if isFavoriteCharacter(id: character.id) {
            removeFavoriteCharacter(character)
        } else {
            handleNonFavoriteCharacter(character)
        }
    }
    
    func isFavoriteCharacter(id: String) -> Bool {
        return favoriteCharacterIds.contains(where: { $0 == id })
    }
    
    private func removeFavoriteCharacter(_ character: CharacterData) {
        repositoryManager.removeFavoriteCharacter(id: character.id) { [weak self] in
            self?.fetchFavoriteCharacters()
        }
    }
    
    private func handleNonFavoriteCharacter(_ character: CharacterData) {
        if favoriteCharacterIds.count >= 5 {
            removeOldestAndSaveNewFavoriteCharacter(character)
        } else {
            saveNewFavoriteCharacter(character)
        }
    }
    
    private func removeOldestAndSaveNewFavoriteCharacter(_ character: CharacterData) {
        repositoryManager.removeOldestFavoriteCharacter { [weak self] in
            self?.saveNewFavoriteCharacter(character)
        }
    }
    
    private func saveNewFavoriteCharacter(_ character: CharacterData) {
        repositoryManager.saveFavoriteCharacter(
            id: character.id,
            characterName: character.name,
            characterDescription: character.description,
            characterImage: character.imageURL.absoluteString,
            saveDate: Date()
        ) { [weak self] in
            self?.fetchFavoriteCharacters()
        }
    }
