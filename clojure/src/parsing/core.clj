;; contributed by @adambard

(ns parsing.core
  (:require [net.cgrand.parsley :as p]
            [criterium.core :refer :all]))

 
(def parse (p/parser :blat #{["{{" #"[a-zA-Z_\-]*" "}}"]}))
 
(defmulti render-node (fn [node _] (:tag node)))
 
;; Pull out the middle bit and look it up in the context
(defmethod render-node :blat [node context]
  (get context (nth (:content node) 1) ""))
 
;; Node is not in fact a node.
(defmethod render-node nil [node _] node)
 
;; Descend recursively
(defmethod render-node :default [node context]
  (apply str
         (mapcat render-node (:content node) (repeat context))))
 
(defn render [template-string context] (render-node (parse template-string) context))

(def template-string "Hello, {{name}}, so nice to see you.")

(def big-string (apply str (repeat 10000 template-string)))

(defn render-template [tmpl-str]
   (render tmpl-str {"name" "Guy"}))

(defn -main []
  (println "\nBenchmarking simple string rendering")
  (quick-bench (render-template template-string))
  (println "\nBenchmarking big string rendering")
  (quick-bench (render-template big-string)))
