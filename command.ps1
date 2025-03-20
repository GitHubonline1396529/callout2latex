<# command.ps1
.SYNOPSIS
    Pandoc command to convert README.md to README.pdf.

.DESCRIPTION
    This file contains a simple pandoc command-line to convert the `README.md`
    file of this project into an PDF. This script is a part of the project
    `callout2latex.lua`, which is a simple Lua script allow user to convert
    Markdown Callout Block syntax to LaTeX environment. In the `README.md` here
    are many examples to display the effect, so it should be convert to PDF. 

.EXAMPLE
    You can simply just run this file in PowerShell on Windows.

.NOTES
    Version: 0.1.0.0
    Author: Githubonline1396529
    Created: 2025/03/20
    Updated: 2025/03/20
#>

pandoc README.md `
--output=README.pdf `
--metadata-file=README.metadata.yaml `
--shift-heading-level-by=-1 `
--lua-filter=callout2latex.lua
