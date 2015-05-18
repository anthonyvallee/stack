{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}

-- | Constants used throughout the project.

module Stackage.Constants where

import Data.Text (Text)
import Filesystem.Path.CurrentOS ()
import Path as FL
import Prelude
import Stackage.Config
import System.Directory

-- | Extensions used for Haskell files.
haskellFileExts :: [Text]
haskellFileExts = ["hs","hsc","lhs"]

-- | Default name used for config path.
configFileName :: Path Rel File
configFileName = $(mkRelFile "stackage-build.config")

-- | The filename used for completed build indicators.
builtFileFromDir :: Path Abs Dir -> Path Abs File
builtFileFromDir fp =
  distDirFromDir fp </>
  $(mkRelFile "stackage-build.gen")

-- | The filename used for completed build indicators.
builtConfigFileFromDir :: Path Abs Dir -> Path Abs File
builtConfigFileFromDir fp = fp </> builtConfigRelativeFile

-- | Relative location of completed build indicators.
builtConfigRelativeFile :: Path Rel File
builtConfigRelativeFile =
  distRelativeDir </>
  $(mkRelFile "stackage-build.config")

-- | Default shake thread count for parallel builds.
defaultShakeThreads :: Int
defaultShakeThreads = 4

-- | Hoogle database file.
hoogleDatabaseFile :: Path Abs Dir -> Path Abs File
hoogleDatabaseFile docLoc =
  docLoc </>
  $(mkRelFile "default.hoo")

-- | Extension for hoogle databases.
hoogleDbExtension :: String
hoogleDbExtension = "hoo"

-- | Extension of haddock files
haddockExtension :: String
haddockExtension = "haddock"

-- | User documentation directory.
userDocsDir :: Path Abs Dir -> Path Abs Dir
userDocsDir homeDir = homeDir </> $(mkRelDir ".stackage/doc/")

-- | Package's build artifacts directory.
distDirFromDir :: Path Abs Dir -> Path Abs Dir
distDirFromDir fp = fp </> distRelativeDir

-- | Relative location of build artifacts.
distRelativeDir :: Path Rel Dir
distRelativeDir = $(mkRelDir "dist/")

-- | Get the package index directory.
getIndexDir :: IO (Path Abs Dir)
getIndexDir =
  do homeDir <- getHomeDirectory >>= parseAbsDir
     return (homeDir </>
             $(mkRelDir ".stackage/pkg-index"))

pkgUnpackDir :: Stackage.Config.Config -> Path Abs Dir
pkgUnpackDir config =
  configStackageRoot config </>
  $(mkRelDir "unpacked")

pkgIndexDir :: Stackage.Config.Config -> Path Abs Dir
pkgIndexDir config =
  configStackageRoot config </>
  $(mkRelDir "package-index")

pkgIndexFile :: Stackage.Config.Config -> Path Abs File
pkgIndexFile config =
  pkgIndexDir config </>
  $(mkRelFile "00-index.tar")
