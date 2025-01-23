;; Identity Management Contract

(define-data-var identity-counter uint u0)

(define-map identities principal {
    did: (string-ascii 50),
    public-key: (buff 33),
    created-at: uint,
    updated-at: uint
})

(define-public (register-identity (did (string-ascii 50)) (public-key (buff 33)))
    (let
        ((new-id (+ (var-get identity-counter) u1)))
        (asserts! (is-none (get-identity tx-sender)) (err u403)) ;; Ensure the identity doesn't already exist
        (map-set identities tx-sender {
            did: did,
            public-key: public-key,
            created-at: block-height,
            updated-at: block-height
        })
        (var-set identity-counter new-id)
        (ok new-id)
    )
)

(define-public (update-identity (did (string-ascii 50)) (public-key (buff 33)))
    (let
        ((identity (unwrap! (get-identity tx-sender) (err u404))))
        (ok (map-set identities tx-sender
            (merge identity {
                did: did,
                public-key: public-key,
                updated-at: block-height
            })
        ))
    )
)

(define-read-only (get-identity (user principal))
    (map-get? identities user)
)

(define-read-only (get-identity-count)
    (var-get identity-counter)
)
