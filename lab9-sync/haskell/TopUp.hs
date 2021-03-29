{-# OPTIONS_GHC -fno-warn-missing-signatures -fno-warn-unused-do-bind #-}
module Main where

import Control.Concurrent
import Control.Concurrent.STM

main =
    do
    logTV <- atomically $ newTVar [] -- log messages go to this variable
    forkIO $ printLogMessages logTV -- start a thread that prints log messages one by one without interleaving

    acc1TV <- atomically (newTVar initAccBalance) -- accout 1 transactionsal variable
    forkIO (makingCalls logTV "Account 1" acc1TV)
    forkIO $ toppingUp logTV "Account 1" acc1TV

    acc2TV <- atomically $ newTVar initAccBalance -- accout 2 transactionsal variable
    forkIO $ makingCalls logTV "Account 2" acc2TV

    threadDelay $ run_duration * second
    -- the forked threads will be aborted automatically now

run_duration = 20 -- seconds
second = 1000000 -- microseconds

initAccBalance :: Int
initAccBalance = 0

makingCalls logTV accName accTV =
    sequence_ $ map makeCall [1..] -- repeat makeCall forever, with costs 1,2,3,...
    where
    makeCall cost =
        do
        success <- atomically $
            do
            credit <- readTVar accTV
            if cost <= credit
                then
                    do 
                    writeTVar accTV $ credit - cost
                    pure True
                else 
                    pure False
        if success
            then log $ "Made call for " ++ show cost
            else log $ "Failed to make a call for " ++ show cost
        threadDelay second
    log msg = logWithPrefix logTV (accName ++ ": ") msg

toppingUp logTV accName accTV =
    sequence_ $ repeat topUp -- repeat topUp forever
    where
    topUp =
        do
        waitUntilNearlyEmpty 
        atomically $
            do
            credit <- readTVar accTV
            writeTVar accTV (credit + amount)
        log $ "Topped up " ++ show amount
    waitUntilNearlyEmpty =
        atomically $
            do
            credit <- readTVar accTV
            if credit < 5
                then pure ()
                else retry
    amount = 10
    log msg = logWithPrefix logTV (accName ++ ": ") msg


printLogMessages logTV =
    sequence_ $ repeat printNextMessage
    where
    printNextMessage =
        do
        msg <- waitForNextMessage
        putStrLn msg
    waitForNextMessage =        
        atomically $
            do
            msgs <- readTVar logTV
            case msgs of
                [] -> retry -- no new messages
                (msg : rest) ->
                    do
                    writeTVar logTV rest -- remove the first message
                    pure msg -- return the first message


logWithPrefix logTV prefix msg = 
    atomically $
        do
        msgs <- readTVar logTV
        writeTVar logTV $ msgs ++ [prefix ++ msg]
