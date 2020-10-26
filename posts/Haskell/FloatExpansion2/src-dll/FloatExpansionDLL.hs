{-# LANGUAGE DataKinds                #-}
{-# LANGUAGE ForeignFunctionInterface #-}

module FloatExpansionDLL
  where
import qualified Data.Vector.SEXP as DV
import           FloatExpansion
import           Foreign
import           Foreign.C
import           Foreign.R        (SEXP)
import qualified Foreign.R.Type   as R

foreign export ccall floatExpansion :: Ptr CInt -> Ptr CDouble -> Ptr (SEXP s R.Int) -> IO ()

floatExpansion :: Ptr CInt -> Ptr CDouble -> Ptr (SEXP s R.Int) -> IO ()
floatExpansion base u result = do
  base <- peek base
  u <- peek u
  let expansion = map intToInt32 $ floatExpansion' (toInteger base) u
  poke result $ DV.toSEXP $ DV.fromList expansion

intToInt32 :: Int -> Int32
intToInt32 = fromIntegral
