(in-package :interval-test)

(defvar *aa*)

(defmethod checkl:result-translate ((result interval:tree))
  (interval:tree-dump result))

(defmethod checkl:result-translate ((result interval:node))
  (interval:node-value result))

(check (:name :make-tree)
  (setf *aa* (interval:make-tree))
  (results *aa*))

(check (:name :basic-insertion)
  (run :make-tree)
  (dotimes (i 100)
    (interval:insert *aa* (interval:make-interval :start i :end (+ i i))))
  (results *aa*))

(check (:name :find-all)
  (run :basic-insertion)
  (results
   (interval:find-all *aa* 1)
   (interval:find-all *aa* 2)
   (interval:find-all *aa* 4)
   (interval:find-all *aa* 50)
   (interval:find-all *aa* 80)
   (interval:find-all *aa* 90)))

(check (:name :find-all-2)
  (run :basic-insertion)
  (results
   (interval:find-all *aa* '(0 . 5))
   (interval:find-all *aa* '(10 . 20))
   (interval:find-all *aa* '(20 . 25))))

(check (:name :basic-find)
  (run :basic-insertion)
  (results
   (interval:find *aa* '(1 . 2))
   (interval:find *aa* '(7 . 14))
   (interval:find *aa* '(15 . 16))
   (interval:find *aa* '(15 . 30))
   (interval:find *aa* '(92 . 184))
   (interval:find *aa* '(100 . 200))))

(check (:name :validate)
  (results
   (interval:tree-validate *aa*)))

(check (:name :delete)
  (run :basic-insertion)
  (dotimes (i 500)
    (let ((n (random 100)))
      (interval:delete *aa* n)
      (interval:tree-validate *aa*)))
  (results))

(check ()
 (time
  (progn
    (run :make-tree)
    (dotimes (i 100000)
      (interval:insert *aa* i))
    (dotimes (i 100000)
      (interval:find *aa* i))
    (dotimes (i 100000)
      (interval:delete *aa* i)))))