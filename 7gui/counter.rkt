#lang racketscript/base

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

(define (add-top-text node text)
  (let ([new-node (text-node text)])
    (($ node 'appendChild) new-node)))

(define (create-counter parent)
  (let ([cnt (box 0)]
        [display-node (div-node)])
    (define (updater)
      (set-box! cnt (add1 (unbox cnt)))
      (update-content! display-node (unbox cnt)))

    (update-content! display-node 0)
    (define btn (button-node "Click me!" (λ (_) (updater))))

    (add-child! parent display-node)
    (add-child! parent btn)))
  
(create-counter BODY-NODE)
