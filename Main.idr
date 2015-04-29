module Main

--%include javascript "helper.js"

data HTMLElement : Type where
  Elem : Ptr -> HTMLElement

data NodeList : Type where
  Nodes : Ptr -> NodeList

query : String -> JS_IO NodeList
query q = do
  e <- foreign FFI_JS "document.querySelectorAll" (String -> JS_IO Ptr) q
  return (Nodes e)

item : NodeList -> Int -> JS_IO HTMLElement
item (Nodes p) i = do
  i <- foreign FFI_JS ".item" (Ptr -> Int -> JS_IO Ptr) p i
  return (Elem i)

getId : HTMLElement -> JS_IO String
getId (Elem p) = foreign FFI_JS ".id" (Ptr -> JS_IO String) p

setText : HTMLElement -> String -> JS_IO ()
setText (Elem p) s = foreign FFI_JS ".textContent=" (Ptr -> String -> JS_IO ()) p s

main : JS_IO ()
main = do
  e <- query "#test"
  i <- item e 0
  s <- getId i
  setText i (s ++ ": SUPERFOO!!!")
