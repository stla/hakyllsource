module BinarySplitting
  (bsplitting)
  where
import Data.Ratio ((%))

split0 :: ([Rational], [Rational]) -> [Rational]
split0 u_v = map (\i -> (u !! (2*i)) * (v !! (2*i+1))) [0 .. m]
  where (u, v) = u_v
        m = div (length u) 2 - 1

split1 :: ([Rational], [Rational], [Rational]) ->
               ([Rational], [Rational], [Rational])
split1 adb = split adb (length alpha)
  where (alpha, _, _) = adb
        split :: ([Rational], [Rational], [Rational]) -> Int ->
                             ([Rational], [Rational], [Rational])
        split u_v_w n =
          if n == 1
            then u_v_w
            else split (x, split0 (v,v), split0 (w,w)) (div n 2)
          where (u, v, w) = u_v_w
                x  = zipWith (+) (split0 (u, w)) (split0 (v, u))

bsplitting :: Int -> [Rational] -> [Rational] -> Rational
bsplitting m u v = num / den + 1
  where ([num], _, [den]) = split1 (take (2^m) u, take (2^m) u, take (2^m) v)
