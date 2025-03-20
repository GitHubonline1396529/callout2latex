#!/usr/bin/env bash
#
# Name: command.sh
#
# Description: This file contains a simple pandoc command-line to convert the
# `README.md` file of this project into an PDF. This script is a part of the
# project `callout2latex.lua`, which is a simple Lua script allow user to
# convert Markdown Callout Block syntax to LaTeX environment. In the
# `README.md` here are many examples to display the effect, so it should be
# convert to PDF. 
#
# Usage: You can simply just run this file in PowerShell on Linux/MacOS.
#
# Author: Githubonline1396529
# Version: 0.1.0.0
# Created Date: 2025/03/20
# Updated Date: 2025/03/20

pandoc README.md `
--output=README.pdf `
--metadata-file=README.metadata.yaml `
--shift-heading-level-by=-1 `
--lua-filter=callout2latex.lua
