#lang racketscript/base

(require (for-syntax syntax/parse
                     racket/base))

(define-syntax (with-css stx)
  (syntax-parse stx
    [(_ ([k v] ...+) body ...+)
     #'(let ()
         (define body-res
           (let ()
             body ...))

         (add-style! body-res (symbol->string 'k) (symbol->string 'v))
         ...
         body-res)]))
  
(define DOM #js*.document)

(define BODY-NODE #js.DOM.body)

(define (base-node type) (#js.DOM.createElement (js-string type)))
(define (div-node) (base-node "div"))

(define (text-node str) (#js.DOM.createTextNode (js-string str)))

(define (add-click-evt! node f) (($ node 'addEventListener) #js"click" f))

(define (add-child! node child)
  (($ node 'appendChild) child)
  (void))

(define (update-content! node content)
  ($/:= ($ node 'textContent) content))

(define (button-node label on-click)
  (let ([node (base-node "button")]
        [child (text-node label)])
    (add-click-evt! node on-click)
    (add-child! node child)
    node))

(define (add-top-text! parent str)
  (let ([new-node (text-node str)])
    (add-child! parent new-node)))

(define (create-counter! parent)
  (let ([cnt (box 0)]
        [display-node (div-node)])
    (define (updater)
      (set-box! cnt (add1 (unbox cnt)))
      (update-content! display-node (unbox cnt)))

    (update-content! display-node 0)

    (define btn
      (with-css ([margin-left 10px])
        (button-node "Click me!" (λ (_) (updater)))))

;;     (define btn (button-node "Click me!" (λ (_) (updater))))

    (add-child! parent display-node)
    (add-child! parent btn)))

(define (add-style! node prop-name val)
  (let ([curr-style ($ node 'style)])
    (($ curr-style 'setProperty)
     (js-string prop-name)
     (or (js-string val) #js""))))

(with-css ([padding 10px]
           [display flex])
  (create-counter! BODY-NODE)
  BODY-NODE)

;; (add-style! BODY-NODE "padding" "10px")
;; (add-style! BODY-NODE "display" "flex")
;; (create-counter! BODY-NODE)
