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

;; Utility Variables
(define-data-var last-token-id uint u0)
(define-data-var total-characters uint u0)

;; Character Creation with Enhanced Metadata
(define-public (mint-character (character-name (string-ascii 50)))
  (let 
    (
      (new-token-id (+ (var-get last-token-id) u1))
    )
    (try! (nft-mint? GameCharacter new-token-id tx-sender))
    
    ;; Set initial character stats
    (map-set character-stats 
      {token-id: new-token-id}
      {
        level: u1, 
        experience: u0, 
        health: u100, 
        strength: u10,
        energy: u100,
        last-activity: stacks-block-height
      }
    )
    
    ;; Initialize empty inventory
    (map-set character-inventory
      {token-id: new-token-id}
      {
        items: (list),
        equipped-weapon: none,
        equipped-armor: none
      }
    )
    
    ;; Update tracking variables
    (var-set last-token-id new-token-id)
    (var-set total-characters (+ (var-get total-characters) u1))
    
    (ok new-token-id)
  )
)


