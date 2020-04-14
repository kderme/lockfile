{-# Language DeriveAnyClass #-}

module Main where

import Control.Exception
import Control.Concurrent
import Control.Concurrent.Async
import System.FileLock
import System.IO
import System.Timeout

import GHC.IO.Handle.Lock



main :: IO ()
main = do
    lockInt

lockG :: IO ()
lockG = do
    h <- openFile "lock" WriteMode
    putStrLn "locking.."
    hLock h ExclusiveLock
    putStrLn "locked"
    {-}
    print b
    b' <- hLock h ExclusiveLock
    print b'
    putStrLn ""
    -}
    threadDelay 200000000
    {-}
    h' <- openFile "lock" WriteMode
    b <- hTryLock h' ExclusiveLock
    print b
    putStrLn ""
    putStrLn "locked"
    threadDelay 200000000
-}
lock :: IO ()
lock = do
    putStrLn "locking.."
    withAsync (lockFile "lock_file" Exclusive) $ \a -> do
        putStrLn "waiting"
        lock <- wait a
    --    h <- openFile "lock_file" WriteMode
        putStrLn "locked"
        threadDelay 200000000
        unlockFile lock
--    putStrLn "locking again.."
--    lock' <- lockFile "lock_file" Exclusive
--    unlockFile lock'
        return ()

lockInt :: IO ()
lockInt = do    
    putStrLn "locking.."
    mlock <- timeout 1000000 $ lockFile "lock_file" Exclusive
    
    case mlock of
        Nothing -> putStrLn "found locked"
        Just lock -> do
            putStrLn "unlocking in ..."
            threadDelay 2000000000
            unlockFile lock
    threadDelay 2000000000

trylock :: IO ()
trylock = do
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