;; title: game_NFT
;; Token and Character Definitions
(define-non-fungible-token GameCharacter uint)
(define-non-fungible-token GameItem uint)

;; [NEW] Metadata URI for NFT
(define-map token-uri {token-id: uint} {uri: (string-ascii 256)})
(define-constant TRANSFER-FEE-PERCENTAGE u5) ;; 5% transfer fee
(define-constant ROYALTY-PERCENTAGE u10) ;; 10% royalty on secondary sales

;; Add pausable functionality
(define-data-var contract-paused bool false)

;; Add whitelist for minting
(define-map minting-whitelist {address: principal} {is-whitelisted: bool})

(define-map admin-roles {address: principal} {is-admin: bool})

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

(define-constant CHARACTER-RARITY-TIERS 
  {
    common: u1, 
    rare: u2, 
    epic: u3, 
    legendary: u4
  }
)

(define-public (add-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-OWNER)
    (map-set admin-roles {address: new-admin} {is-admin: true})
    (ok true)
  )
)

(define-public (remove-admin (admin principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-OWNER)
    (map-set admin-roles {address: admin} {is-admin: false})
    (ok true)
  )
)

(define-public (toggle-contract-pause)
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-OWNER)
    (var-set contract-paused (not (var-get contract-paused)))
    (ok (var-get contract-paused))
  )
)

(define-public (add-to-whitelist (address principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-OWNER)
    (map-set minting-whitelist {address: address} {is-whitelisted: true})
    (ok true)
  )
)


;; [NEW] Set token URI for specific token
(define-public (set-token-uri (token-id uint) (uri (string-ascii 256)))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-OWNER)
    (map-set token-uri {token-id: token-id} {uri: uri})
    (ok true)
  )
);; [NEW] Set token URI for specific token


;; [NEW] Provenance and ownership tracking
(define-map token-provenance 
  {token-id: uint} 
  {
    original-creator: principal,
    creation-block: uint,
    transfer-history: (list 10 principal)
  }
)

(define-map contract-upgrades
  {version: uint}
  {
    implementation-address: principal,
    upgrade-timestamp: uint,
    upgrade-description: (string-ascii 100)
  }
)

(define-map role-permissions
  {
    role: (string-ascii 20),
    permission: (string-ascii 50)
  }
  {
    allowed: bool,
    max-actions: (optional uint)
  }
)

(define-map governance-proposals
  {
    proposal-id: uint,
    proposer: principal
  }
  {
    proposal-type: (string-ascii 30),
    votes-for: uint,
    votes-against: uint,
    execution-block: uint,
    proposal-status: (string-ascii 20)
  }
)

(define-map character-staking
  {
    token-id: uint,
    staker: principal
  }
  {
    stake-start-block: uint,
    rewards-accumulated: uint,
    is-active: bool
  }
)

(define-map nft-components
  {token-id: uint}
  {
    base-character: uint,
    attachments: (list 5 uint),
    modification-level: uint
  }
)

(define-map contract-events
  {event-id: uint}
  {
    event-type: (string-ascii 30),
    event-data: (string-ascii 200),
    timestamp: uint,
    initiator: principal
  }
)

(define-map character-insurance
  {token-id: uint}
  {
    is-insured: bool,
    insurance-value: uint,
    expiration-block: uint
  }
)

(define-map cross-chain-registry
  {token-id: uint}
  {
    original-chain: (string-ascii 20),
    target-chains: (list 5 (string-ascii 20)),
    bridge-contract: (optional principal)
  }
)

;; Dynamic Rarity Scoring System
(define-map character-rarity-score
  {token-id: uint}
  {
    base-rarity: uint,
    dynamic-multiplier: uint,
    last-updated-block: uint
  }
)

;; Fractional NFT Ownership
(define-map fractional-ownership
  {token-id: uint}
  {
    total-shares: uint,
    share-holders: (list 10 {
      owner: principal, 
      shares: uint
    })
  }
)

;; Comprehensive Character Validation
(define-read-only (validate-character (token-id uint))
  (let 
    (
      (stats (map-get? character-stats {token-id: token-id}))
      (inventory (map-get? character-inventory {token-id: token-id}))
      (provenance (map-get? token-provenance {token-id: token-id}))
    )
    (if (and 
          (is-some stats)
          (is-some inventory)
          (is-some provenance)
        )
        (ok true)
        (err ERR-INVALID-ITEM)
    )
  )
)


