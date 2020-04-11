#! /bin/bash 

. ~/.nix-profile/etc/profile.d/nix.sh

nix-env -i cabal2nix
cd
mkdir app && touch app/{Main.hs,app.cabal,default.nix} 

cd app

cat > app.cabal << DONE
name:                app
version:             0.1.0.0
synopsis:            First miso app
category:            Web
build-type:          Simple
cabal-version:       >=1.10

executable app
  main-is:             Main.hs
  ghcjs-options:
    -dedupe
  build-depends:       base, miso
  default-language:    Haskell2010
DONE

# cabal2nix . --compiler ghcjs > app.nix

cat > default.nix << DONE
with (import (builtins.fetchTarball {
  url = "https://github.com/dmjio/miso/archive/561ffad.tar.gz";
  sha256 = "1wwzckz2qxb873wdkwqmx9gmh0wshcdxi7gjwkba0q51jnkfdi41";
}) {});
pkgs.haskell.packages.ghcjs.callCabal2nix "app" ./. {}
DONE

cat > Main.hs << DONE

-- | Haskell language pragma
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

-- | Haskell module declaration
module Main where

-- | Miso framework import
import Miso
import Miso.String

-- | Type synonym for an application model
type Model = Int

-- | Sum type for application events
data Action
  = AddOne
  | SubtractOne
  | NoOp
  | SayHelloWorld
  deriving (Show, Eq)

-- | Entry point for a miso application
main :: IO ()
main = startApp App {..}
  where
    initialAction = SayHelloWorld -- initial action to be executed on application load
    model  = 0                    -- initial model
    update = updateModel          -- update function
    view   = viewModel            -- view function
    events = defaultEvents        -- default delegated events
    subs   = []                   -- empty subscription list
    mountPoint = Nothing          -- mount point for application (Nothing defaults to 'body')

-- | Updates model, optionally introduces side effects
updateModel :: Action -> Model -> Effect Action Model
updateModel action m =
  case action of
    AddOne
      -> noEff (m + 1)
    SubtractOne
      -> noEff (m - 1)
    NoOp
      -> noEff m
    SayHelloWorld
      -> m <# do consoleLog "Hello World" >> pure NoOp

-- | Constructs a virtual DOM from a model
viewModel :: Model -> View Action
viewModel x = div_ [] [
   button_ [ onClick AddOne ] [ text "+" ]
 , text (ms x)
 , button_ [ onClick SubtractOne ] [ text "-" ]
 ]
DONE

mkdir -p ~/.config/nixpkgs
cat > ~/.config/nixpkgs/config.nix << DONE
{ allowUnfree = true; }
DONE

# optional use of cache
nix-env -iA cachix -f https://cachix.org/api/v1/install
# optional use of cache
cachix use miso-haskell
# git clone https://github.com/dmjio/miso
# cd miso/sample-app
# nix-build
# open ./result/bin/app.jsexe/index.html

# nix-build
