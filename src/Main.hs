{-# Language DeriveAnyClass #-}

module Main where

import Control.Exception
import Control.Concurrent
import System.FileLock



main :: IO ()
main = do
    lock

lock :: IO ()
lock = do
    putStrLn "trying lock.."
    mlock <- tryLockFile "lock_file" Exclusive
    case mlock of
        Nothing -> do
            putStrLn "file locked!"
            throwIO LockedFile
        Just a -> do
            putStrLn "sleeping.."
            threadDelay 1000000000
            putStrLn "morning!"

data LockedFile = LockedFile deriving (Show, Exception)