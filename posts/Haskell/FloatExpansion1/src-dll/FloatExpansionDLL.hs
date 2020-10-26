module FloatExpansionDLL
  where
import Foreign
import Foreign.C
import FloatExpansion

foreign export ccall floatExpansion :: Ptr CInt -> Ptr CDouble -> Ptr CString -> IO ()

floatExpansion :: Ptr CInt -> Ptr CDouble -> Ptr CString -> IO ()
floatExpansion base u result = do
  base <- peek base
  u <- peek u
  expansion <- newCString $ show $ floatExpansion' (toInteger base) u
  poke result expansion
