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

;; Game Configuration Constants
(define-constant MAX-LEVEL u100)
(define-constant BASE-XP-REQUIREMENT u100)
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ENERGY-COOLDOWN-PERIOD u3600) ;; 1 hour

;; Error Codes (Expanded)
(define-constant ERR-NOT-OWNER (err u1))
(define-constant ERR-MAX-LEVEL (err u2))
(define-constant ERR-INSUFFICIENT-XP (err u3))
(define-constant ERR-INVALID-ITEM (err u4))
(define-constant ERR-INVENTORY-FULL (err u5))
(define-constant ERR-INSUFFICIENT-ENERGY (err u6))



