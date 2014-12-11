(defproject parsing "0.1.0-SNAPSHOT"
  :description "Parsing benchmark"
  :url "http://example.com/FIXME"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :main parsing.core
  :dependencies [[org.clojure/clojure "1.6.0"]
                 [net.cgrand/parsley "0.9.2"  :exclusions [org.clojure/clojure]]
                 [criterium "0.4.3"]])
