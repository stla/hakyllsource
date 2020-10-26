module FloatExpansion
  where
import Numeric (floatToDigits)

floatExpansion' :: RealFloat a => Integer -> a -> [Int]
floatExpansion' base u = replicate (- snd expansion) 0 ++ fst expansion
  where
    expansion = floatToDigits base u
