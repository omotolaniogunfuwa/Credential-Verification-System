;; Credential Issuance Contract

(define-data-var credential-counter uint u0)

(define-map credentials uint {
    issuer: principal,
    holder: principal,
    credential-type: (string-ascii 50),
    hash: (buff 32),
    issued-at: uint,
    expiration: uint
})

(define-public (issue-credential (holder principal) (credential-type (string-ascii 50)) (hash (buff 32)) (expiration uint))
    (let
        ((new-id (+ (var-get credential-counter) u1)))
        (map-set credentials new-id {
            issuer: tx-sender,
            holder: holder,
            credential-type: credential-type,
            hash: hash,
            issued-at: block-height,
            expiration: expiration
        })
        (var-set credential-counter new-id)
        (ok new-id)
    )
)

(define-read-only (get-credential (credential-id uint))
    (map-get? credentials credential-id)
)

(define-read-only (get-credential-count)
    (var-get credential-counter)
)
