module ESE160311 where

-- Types
-- :t 42, "ciao", 1 == 1, head (car), tail (cdr)
-- :t (==), elem

-- 1) myReverse :: [Int] -> [Int] Binded to integers, not generic
-- 2) change to
myReverse :: [a] -> [a]
myReverse [] = []
myReverse (x:xs) = myReverse xs ++ [x]

-- myReverse [1,2,3]
-- myReverse [0.1,0.2,0.3]
-- myReverse [0.1, 0.3 .. 1] Watch out when using floating point numbers in ranges!
-- myReverse ['a', 'b', 'c']

-- if vs guards

myRange :: Int -> Int -> [Int] -- currying
myRange a b = if a > b
    then error "Low > High"
    else if a < b
        then a : myRange (a + 1) b
        else [a]

myRange2 :: Int -> Int -> [Int]
myRange2 a b 
    | a > b = error "Low > High"
    | a == b = [a]
    | a < b = myRange2 (a + 1) b

-- WARNING: infinite list, use "take"! 
-- take 3 (myRange3 10) 
-- This makes sens in presence of call-by-need
myRange3 :: Int -> [Int]
myRange3 a = a : myRange3 (a + 1)

-- More on infinite Lists
-- cycle (task a list and cycles it into an infinite list)

myCycle :: [a] -> [a]
myCycle [] = error "Empty List"
myCycle (x:xs) = x:xs ++ myCycle(x:xs)

-- First Class Functions
-- Map

myMap :: (a -> b) -> [a] -> [b]
myMap f [] = []
myMap f (x:xs) = (f x): myMap f xs 

-- myMap (\x -> 1 + x) [1,2,3]

-- FoldL

myFoldL :: (a -> a -> a) -> a -> [a] -> a
myFoldL f x [] = x
myFoldL f x (y:ys) = myFoldL f (f x y) ys

-- myFoldL (\x y -> y + x) 0 [1,2,3]

myFilter :: (a -> Bool) -> [a] -> [a]
myFilter _ [] = []
myFilter f (x:xs)
    | f x = x: myFilter f xs
    | otherwise = myFilter f xs

-- More on List
-- Zip

myZip :: [a] -> [b] -> [(a,b)]
myZip l [] = []
myZip [] l = []
myZip (x:xs) (y:ys) = (x,y):(myZip xs ys)
-- myZip [1,2,3] ['a','b','c']

-- L:List comprehensions

-- List Comprehension
-- [x*2 | x <- [1..10]]

rightTriangles :: [(Integer, Integer, Integer)]
rightTriangles = [(a,b,c) | c <- [1..10], b <- [1..c], a <- [1..b], a^2 + b^2 == c^2, a + b + c == 24]

-- And there's our answer! This is a common pattern in functional programming. 
-- You take a starting set of solutions and then you apply 
-- transformations to those solutions and filter them until you get the right ones.

factorial :: Int -> Int
factorial n = product [1..n]

factorialBig :: Integer -> Integer
factorialBig n = product [1..n]

fib :: Int -> Int
fib n 
    | n == 0 = 0
    | n == 1 = 1  
    | n == 2 = 1
    | n > 2 = fib (n - 1) + fib (n - 2)

fib2 :: Int -> Int
fib2 0 = 0
fib2 1 = 1
fib2 2 = 1
fib2 n = fib2 (n - 1) + fib2 (n - 2)

--Eq and Ord types that support equality tests and ordering
-- Show presented as string

-- Pack (helper pattern)
-- => requires a to be an Eq

packHelper :: Eq a => [a] -> [[a]] -> [a] -> [[a]]
packHelper [] acc sub = sub:acc
packHelper (x:xs) acc [] = packHelper xs acc [x]
packHelper (x:xs) acc (y:ys)
    | x == y = packHelper xs acc (x:sub)
    | otherwise = packHelper xs (sub:acc) [x]
    where sub = y:ys

-- encapsulate subsequent equal elements of a list into a list
-- [10, 10, 100, 10, 11,  11] -> [[10,10],[100],[10],[11,11]]
pack :: Eq a => [a] -> [[a]] 
pack input = reverse (packHelper input [] [])

-- Encode e.g. substitute the #of element with the count
encode :: Eq a => [a] -> [(a, Int)]
encode input = zip (map head packed) (map length packed)
    where packed = pack input

-- names after the where are visible across the guards

cylinder :: (RealFloat a) => a -> a -> a  
cylinder r h = 
    let sideArea = 2 * pi * r * h  
        topArea = pi * r ^2  
    in  sideArea + 2 * topArea 

 -- let <bindings> in <expression> 
-- The names that you define in the 
-- let part are accessible to the expression after the in part. 

-- Implementing a type class
-- 
-- Definition from the Prelude:
-- class Eq a where
--     (==) :: a -> a -> Bool
--     (/=) :: a -> a -> Bool
--     x == y = not (x /= y)
--     x /= y = not (x == y)
--
-- This means that a) we have to implement both "equals" and "not equals"
-- and b) since "x is equal to y if x is not equal to y" and viceversa,
-- we can just define "equals" or "not equals" and Haskell will infer the
-- other one.

-- Do not need to instantiate sicne they are nullary constructor
-- kind of Enum or Boolean

-- SUM

data TrafficLight = Red | Yellow | Green

instance Eq TrafficLight where
    Red == Red = True
    Green == Green = True
    Yellow == Yellow = True
    _ == _ = False

instance Ord TrafficLight where
    compare Red _ = LT
    compare Green _ = GT
    compare Yellow Green = LT
    compare Yellow Red = GT

instance Show TrafficLight where
    show Red = "Red light"
    show Yellow = "Yellow light"
    show Green = "Green light"

-- PRODUCT

data Point = Point Float Float deriving (Show)

getx (Point x _) = x
gety (Point _ y) = y

data ClikePoint = ClikePoint {x, y :: Float}

pointx (ClikePoint x _) = x
pointy (ClikePoint _ y) = y

-- Useful for complex stuff
data Person1 = Person1 String String Int Float String String deriving (Show)  

data Person = Person { firstName :: String  
                     , lastName :: String  
                     , age :: Int  
                     } deriving (Show)

-- let mikeD = Person {firstName = "Michael", lastName = "Diamond", age = 43}  




-- Homeworks

quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x:xs) =
    let right = quicksort [a | a <- xs, a <= x]
        left = quicksort [a | a <- xs, a > x]
    in right ++ [x] ++ left


