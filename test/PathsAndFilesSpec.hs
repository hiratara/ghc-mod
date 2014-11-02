{-# LANGUAGE CPP #-}
module PathsAndFilesSpec where

import Language.Haskell.GhcMod.PathsAndFiles
#if __GLASGOW_HASKELL__ <= 706
import Language.Haskell.GhcMod.Types
import Language.Haskell.GhcMod.GhcPkg
#endif

import System.Directory
import System.FilePath ((</>))
import Test.Hspec

spec :: Spec
spec = do
    describe "getSandboxDb" $ do
-- ghc < 7.8
#if __GLASGOW_HASKELL__ <= 706
        it "does include a sandbox with ghc < 7.8" $ do
            cwd <- getCurrentDirectory
            getPackageDbStack "test/data/" `shouldReturn` [GlobalDb, PackageDb $ cwd </> "test/data/.cabal-sandbox/i386-osx-ghc-7.6.3-packages.conf.d"]
#endif

        it "can parse a config file and extract the sandbox package-db" $ do
            cwd <- getCurrentDirectory
            pkgDb <- getSandboxDb "test/data/"
            pkgDb `shouldBe` Just (cwd </> "test/data/.cabal-sandbox/i386-osx-ghc-7.6.3-packages.conf.d")

        it "returns Nothing if the sandbox config file is broken" $ do
            getSandboxDb "test/data/broken-sandbox" `shouldReturn` Nothing