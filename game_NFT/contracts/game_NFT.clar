;; title: game_NFT
;; Token and Character Definitions
(define-non-fungible-token GameCharacter uint)
(define-non-fungible-token GameItem uint)

;; Persistent Storage
(define-map character-stats 
  {token-id: uint}
  {
    level: uint,
    experience: uint,
    health: uint,
    strength: uint,
    energy: uint,
    last-activity: uint
  }
)

(define-map character-inventory
  {token-id: uint}
  {
    items: (list 10 uint),
    equipped-weapon: (optional uint),
    equipped-armor: (optional uint)
  }
)

(define-map item-metadata
  {item-id: uint}
  {
    item-type: (string-ascii 20),
    rarity: (string-ascii 10),
    power: uint,
    durability: uint
  }
)


