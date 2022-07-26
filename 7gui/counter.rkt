#lang racketscript/base

(define DOM #js*.document)

(define BODY-NODE #js.DOM.body)

(define (text-node str) (#js.DOM.createTextNode (js-string str)))

(define (button-node label)
  (let ([node (#js.DOM.createElement #js"button")]
        [child (text-node "alert button")])
    (($ node 'addEventListener) #js"click" (λ (evt) (#js*.alert #js"wow")))
    (($ node 'appendChild) child)
    node))

(define (add-top-text node text)
  (let ([new-node (text-node text)])
    (($ node 'appendChild) new-node)))

(($ BODY-NODE 'appendChild) (button-node "foobar"))

