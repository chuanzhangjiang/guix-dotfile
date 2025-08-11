(define-module (chuanguix home-services ydotool)
  #:use-module (gnu)
  #:use-module (gnu packages linux)
  #:use-module (gnu services shepherd)
  #:use-module (gnu home services)
  #:use-module (gnu home services shepherd)
  #:use-module (guix gexp)
  #:export (home-ydotool-service-type))

(define (home-ydotool-shepherd-service config)
  (list
   (shepherd-service
    (provision '(ydotoold))
    (documentation "Run ydotool daemon")
    (start #~(make-forkexec-constructor
             (list "/run/privileged/bin/ydotoold")))
    (stop #~(make-kill-destructor)))))

(define home-ydotool-service-type
  (service-type
   (name 'home-ydotool)
   (extensions
    (list
     (service-extension
           home-shepherd-service-type
           home-ydotool-shepherd-service)))
   (default-value #f)
   (description "Run ydotool daemon for user-level input simulation")))
