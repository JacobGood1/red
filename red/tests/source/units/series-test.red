Red [
	Title:   "Red case series test script"
	Author:  "Nenad Rakocevic & Peter W A Wood"
	File: 	 %series-test.red
	Tabs:	 4
	Rights:  "Copyright (C) 2011-2012, 2012 Nenad Rakocevic & Peter W A Wood. All rights reserved."
	License: "BSD-3 - https://github.com/dockimbel/Red/blob/origin/BSD-3-License.txt"
]

;; counters
qt-run-tests: 0 
qt-run-asserts: 0
qt-run-passes: 0
qt-run-failures: 0
qt-file-tests: 0 
qt-file-asserts: 0 
qt-file-passes: 0 
qt-file-failures: 0

;; group switches
qt-group-name-not-printed: true
qt-group?: false

_qt-init-group: func [] [
  qt-group-name-not-printed: true
  qt-group?: false
  qt-group-name: ""
]

qt-init-run: func [] [
  qt-run-tests: 0 
  qt-run-asserts: 0
  qt-run-passes: 0
  qt-run-failures: 0
  _qt-init-group
]

qt-init-file: func [] [
  qt-file-tests: 0 
  qt-file-asserts: 0 
  qt-file-passes: 0 
  qt-file-failures: 0
  _qt-init-group
]

***start-run***: func[
    title [string!]
][
  qt-init-run
  qt-run-name: title
  prin "***Starting*** " 
  print title
]

~~~start-file~~~: func [
  title [string!]
][
  qt-init-file
  prin "~~~started test~~~ "
  print title
  qt-file-name: title
  qt-group?: false
]

===start-group===: func [
  title [string!]
][
  qt-group-name: title
  qt-group?: true
]

--test--: func [
  title [string!]
][
  qt-test-name: title
  qt-file-tests: qt-file-tests + 1
]

--assert: func [
  assertion [logic!]
][

  qt-file-asserts: qt-file-asserts + 1
  
  either assertion [
     qt-file-passes: qt-file-passes + 1
  ][
    qt-file-failures: qt-file-failures + 1
    if qt-group? [  
      if qt-group-name-not-printed [
        prin "===group=== "
        print qt-group-name
        qt-group-name-not-printed: false
      ]
    ]
    prin "--test-- " 
    prin qt-test-name
    print " FAILED**************"
  ]
]
 
===end-group===: func [] [
  _qt-init-group
]

qt-print-totals: func [
  tests     [integer!]
  asserts   [integer!]
  passes    [integer!]
  failures  [integer!]
][
  prin  "  Number of Tests Performed:      " 
  print tests 
  prin  "  Number of Assertions Performed: "
  print asserts
  prin  "  Number of Assertions Passed:    "
  print passes
  prin  "  Number of Assertions Failed:    "
  print failures
  if failures <> 0 [
    print "****************TEST FAILURES****************"
  ]
]

~~~end-file~~~: func [] [
  print ""
  prin "~~~finished test~~~ " 
  print qt-file-name
  qt-print-totals qt-file-tests qt-file-asserts qt-file-passes qt-file-failures
  print ""
  
  ;; update run totals
  qt-run-passes: qt-run-passes + qt-file-passes
  qt-run-asserts: qt-run-asserts + qt-file-asserts
  qt-run-failures: qt-run-failures + qt-file-failures
  qt-run-tests: qt-run-tests + qt-file-tests
]

***end-run***: func [][
  prin "***Finished*** "
  print qt-run-name
  qt-print-totals qt-run-tests
                  qt-run-asserts
                  qt-run-passes
                  qt-run-failures
]

~~~start-file~~~ "series"

===start-group=== "first, second, third, fourth, fifth"

	--test-- "series-fstff-1"
	  sf1-ser:  [1 2 3 4 5]
	--assert 1 = first sf1-ser
	--assert 2 = second sf1-ser
	--assert 3 = third sf1-ser
	--assert 4 = fourth sf1-ser
	--assert 5 = fifth sf1-ser
	--assert 5 = last sf1-ser

	--test-- "series-fstff-2"
	  sf2-ser:  [1 2 3 4 5]
	--assert 2 = first next sf2-ser
	
	--test-- "series-fstff-3"
	  sf3-ser:  "12345"
	--assert 49 = first sf3-ser
	--assert 53 = last sf3-ser
	
	--test-- "series-fstff-4"
	  sf4-ser:  [1 2 3 4 5]
	--assert none = fifth next sf4-ser
	
	--test-- "series-fstff-5"
	  sf5-ser:  "12345"
	--assert 53 = fifth sf5-ser
	
	--test-- "series-fstff-6"
	  stf6-ser: #{000102}
	;;--assert 0 = first stf6-ser
	
	--test-- "series-fstff-7"
	;--assert 'a = first [a b c d]
	  
===end-group===

===start-group=== "pick"

  --test-- "series-pick-1"
  --assert none = pick "" 1
  
  --test-- "series-pick-2"
  --assert none = pick "" 0
  
  --test-- "series-pick-3"
  --assert none = pick "" 2
  
  --test-- "series-pick-4"
  --assert 49 = pick "12345" 1
  
  --test-- "series-pick-5"
  --assert 53 = pick "12345" 5
  
  --test-- "series-pick-6"
  --assert 1 = pick [1 2 3 4 5] 1
  
  --test-- "series-pick-7"
  --assert 2 = pick [1 2 3 4 5] 2
  
  --test-- "series-pick-8"
  --assert 4 = pick [1 2 3 4 5] 4
  
  --test-- "series-pick-9"
  --assert 5 = pick [1 2 3 4 5] 5
  
  --test-- "series-pick-10"
  --assert 2 = pick next next next [1 2 3 4 5] -2
  
  --test-- "series-pick-11"
  --assert 3 = pick next next next [1 2 3 4 5] -1
  
  --test-- "series-pick-12"
  --assert none = pick next next next [1 2 3 4 5] 0
  
===end-group===

===start-group=== "select"
  --test-- "series-select-1"
  ;--assert 2 = select [1 2 3 4 5] 1
===end-group===

===start-group=== "next"
  --test-- "series-next-1"
  --assert 2 = first next [1 2 3 4 5]
  --test-- "series-next-2"
  --assert 3 = first next next [1 2 3 4 5]
  --test-- "series-next-3"
  --assert 4 = first next next next [1 2 3 4 5]
  --test-- "series-next-4"
  --assert 5 = first next next next next [1 2 3 4 5]
  --test-- "series-next-5"
  --assert none = first next next next next next [1 2 3 4 5]
  --test-- "series-next-6"
  --assert 50 = first next "12345"
  --test-- "series-next-7"
  --assert 51 = first next next "12345"
  --test-- "series-next-8"
  --assert 52 = first next next next "12345"
  --test-- "series-next-9"
  --assert 53 = first next next next next "12345"
  --test-- "series-next-10"
  --assert none = first next next next next next "12345"  
===end-group===

===start-group=== "back"
--test-- "series-back-1"
  --assert 1 = first back next [1 2 3 4 5]
  --test-- "series-back-2"
  --assert 1 = first back back next next [1 2 3 4 5]
  --test-- "series-back-3"
  --assert 1 = first back back back next next next [1 2 3 4 5]
  --test-- "series-back-4"
  --assert 1 = first back back back back next next next next [1 2 3 4 5]
  --test-- "series-back-5"
  --assert 1 = first back back back back back next next next next next [1 2 3 4 5]
  --test-- "series-back-6"
  --assert 49 = first back next "12345"
  --test-- "series-back-7"
  --assert 50 = first back next next "12345"
  --test-- "series-back-8"
  --assert 51 = first back next next next "12345"
  --test-- "series-back-9"
  --assert 52 = first back next next next next "12345"
  --test-- "series-back-10"
  --assert 53 = first back next next next next next "12345"
  --test-- "series-back-11"
  --assert 49 = first back "12345"
===end-group===

===start-group=== "tail"
  --test-- "series-tail-1"
  --assert 5 = first back tail [1 2 3 4 5]
  --test-- "seried-tail-2" 
  --assert none = pick tail [1 2 3 4 5] 1
===end-group===

===start-group=== "append"
  --test-- "series-append-1"
  --assert 6 = last append [1 2 3 4 5] 6
  --test-- "series-append-2"
  --assert 6 = last append [1 2 3 4] [5 6]
  --assert 4 = fourth append [1 2 3 4] [5 6]
  --assert 5 = fifth append [1 2 3 4] [5 6]
  --test-- "series-append-3"
  --assert 55 = last append "12345" "67"
  --test-- "series-append-4"
  --assert 233 = last append "abcde" "é" ;; utf-8 C3 A9
  --test-- "series-append-5"
  --assert 49 = last append "abcdeé" "1" ;; utf-8 C3 A9
  --test-- "series-append-6"
  --assert 10000 = last append "abcde" "^(E2)^(9C)^(90)" 
  --test-- "series-append-7"
  --assert 48 = last append "abcde^(E2)^(9C)^(90)" "0"
  --test-- "series-append-8"
  --assert 10000 = last append "abcdeé" "^(E2)^(9C)^(90)"
  --test-- "series-append-9"
  --assert 233 = last append "abcde^(E2)^(9C)^(90)" "é"
  --test-- "series-append-10"
  --assert 65536 = last append "abcde" "^(F0)^(90)^(80)^(80)"   
  --test-- "series-append-11"
  --assert 48 = last append "abcde^(F0)^(90)^(80)^(80)" "0"
  --test-- "series=append-12"
  --assert 65536 = last append "abcde^(E2)^(9C)^(90)é" "^(F0)^(90)^(80)^(80)" 
  
===end-group===

~~~end-file~~~
