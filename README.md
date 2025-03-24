# callout2latex.lua: Convert Markdown Callout Blocks into \LaTeX\ Environments

## Description

`callout2latex.lua` is a Pandoc Lua filter for converting [GitHub](https://github.com/orgs/community/discussions/16925), [Typora](https://github.com/typora-community-plugin/typora-plugin-callout), [Obsidian](https://help.obsidian.md/callouts#:~:text=To%20create%20a%20callout%2C%20add%20%60%5B%21info%5D%60%20to%20the,identifier%20determines%20how%20the%20callout%20looks%20and%20feels.), and [Microsoft](https://learn.microsoft.com/en-us/contribute/content/markdown-reference#alerts-note-tip-important-caution-warning)[^1] styled Markdown Callout Blocks (also known as Alert Blocks, Message Boxes, or Admonitions[^2]) into \LaTeX\ environments.

The basic functionality of this script has been implemented correctly, although some issues still remain, which I plan to address in future updates.

Most of this script was generated with the assistance of [ChatGPT](https://chatgpt.com/) and [DeepSeek](https://chat.deepseek.com/), with minor modifications made by me.

## Key Features

Comparing with the [pandoc-latex-admonition](https://github.com/chdemko/pandoc-latex-admonition), which is a pandoc filter which allows you to add markdown admonitions to divs or codeblocks elements, this script has the following different features:

1. Use a more common syntax of admonition (Instead of using pandoc native `Div`), which is more commonly supported by different platforms and editors, and no additional syntax is introduced.
2. No matter what the admonition name is specified to be, this script always simply just pass the admonition type name to the the \LaTeX\ environment name *intactly*, which provides users with maximized freedom.
3. Lightweight (just one Lua script), simple and easy to use.

## Usage

To use this filter script, specify it as a Lua filter for Pandoc using the `--lua-filter` flag. Examples of conversion commands are provided in [`command.sh`](command.sh) and [`command.ps1`](command.ps1).

```bash
pandoc file.md --output file.pdf --lua-filter callout2latex.lua
```

### Syntax Example

If your Markdown file contains the following:

```markdown {.numberLines}
A note callout block with a title:

> [!note] This is the note title
> This is a line of info.

A note callout block without a title:

> [!note]
> This is a line of info
> It may contain multiple lines,
> 
> Or even a new paragraph. 
```

It will be converted to \LaTeX\ as:

```tex {.numberLines}
A note callout block with a title:

\begin{note}[This is the note title]

This is a line of info.

\end{note}

A note callout block without a title:

\begin{note}

This is a line of info

It may contain multiple lines,

Or even a new paragraph.

\end{note}
```

> [!TIP]
> In case you didn't know: Pandoc has a built-in Lua interpreter, so you don't need to install or configure an independent Lua runtime environment.

## Announcements

Here are a few things to note about this filter script[^3]:

1. Currently, ordered lists (`enumerate`) and unordered lists (`itemize`) are not supported within callout blocks.
2. Every single line in the callout block will be converted into one paragraph in \LaTeX\.

> [!WARNING]
> **DO NOT USE SPACE AFTER THE TYPE LABEL.**
>
> Leaving a space (or any other blank character) after the callout block type label `[!TYPE]` may cause unwanted and unexpected \LaTeX\ formatting. For example:
>
> ```markdown {.numberLines}
> > [!NOTE]
> > Notice the two spaces after the `[!NOTE]` label.
> ```
>
> You may can't see the spaces but they do exist. This will be converted to:
>
> ```tex {.numberLines}
> \begin{note}[Notice the two spaces after the `[!NOTE]` label. ]
> \end{note}
> ```
>
> This may result in unexpected formatting of the content.

## Installation

To install `callout2latex.lua` and make it accessible globally on localhost, follow these steps:

### Locate Pandoc's User Data Directory

Pandoc stores user-specific data, including filters, in its user data directory. To find the directory, you should firstly run the following command in your terminal or command prompt:

```bash
pandoc --version
```

Then Look for the line that shows `User data directory:`, which might look something like:

```txt
User data directory: /home/username/.pandoc
```

On different systems, the typical paths are:

- **Linux:** `~/.pandoc/`
- **macOS:** `~/Library/Application Support/pandoc/`
- **Windows:** `C:\Users\username\AppData\Roaming\pandoc\`

If the directory does not exist, create it manually.

### Copy the Filter to the Filters Directory

Inside the user data directory, locate or create a `filters` subdirectory (`~/.pandoc/finters` as an example):

```bash
mkdir -p ~/.pandoc/filters
```

Copy `callout2latex.lua` to the `filters` directory:

```bash
cp callout2latex.lua ~/.pandoc/filters/
```

### Verify the Installation

To ensure the filter is correctly installed, run:

```bash
ls ~/.pandoc/filters/
```

You should see `callout2latex.lua` in the list.

### Using the Filter Globally

After installation, you can apply the filter from any directory by running:

```bash
pandoc file.md --output file.pdf --lua-filter callout2latex.lua
```

Or, simply refer to the filter from the user data directory without specifying the full path:

```bash
pandoc file.md --output file.pdf --lua-filter callout2latex.lua
```

### Optionally Create a Global Alias on Linux or Mac

To simplify usage, you can create a shell alias:

```bash {.numberLines}
echo 'alias callout2latex="pandoc --lua-filter=$HOME/.pandoc/filters/callout2latex.lua"' >> ~/.bashrc
source ~/.bashrc
```

Now you can use:

```bash
callout2latex file.md -o file.pdf
```

## Examples

### Alert Boxes

Consider the following Markdown syntax:

```markdown {.numberLines}
> [!NOTE]
> Highlights information that users should take into account, even when skimming.

> [!TIP]
> Optional information to help a user be more successful.

> [!IMPORTANT]
> Crucial information necessary for users to succeed.

> [!WARNING]
> Critical content demanding immediate user attention due to potential risks.

> [!CAUTION]
> Negative potential consequences of an action.
```

After running `pandoc` with the Lua filter, the above blocks will be converted into \LaTeX\ environments. (Ensure the required environments are defined in your document class[^4]. See `example.cls` for their definitions.)

> [!NOTE]
> Highlights information that users should take into account, even when skimming.

> [!TIP]
> Optional information to help a user be more successful.

> [!IMPORTANT]
> Crucial information necessary for users to succeed.

> [!WARNING]
> Critical content demanding immediate user attention due to potential risks.

> [!CAUTION]
> Negative potential consequences of an action.

### Theorem Environments

This script supports custom \LaTeX\ environments. For example[^5], if you've defined `definition` and `theorem` environments correctly in your document class, you can use the following syntax:

> [!definition] Left Coset
> Let $H$ be a subgroup of a group~$G$.  A \emph{left coset} of $H$ in $G$ is a subset of $G$ that is of the form $xH$, where $x \in G$ and $xH = \{ xh : h \in H \}$. Similarly, a \emph{right coset} of $H$ in $G$ is a subset of $G$ that is of the form $Hx$, where $Hx = \{ hx : h \in H \}$

> [!theorem] Lagrange's Theorem
> Let $G$ be a finite group, and let $H$ be a subgroup of $G$. Then the order of $H$ divides the order of $G$.

See [`README.pdf`](README.pdf) for the formatted Theorem of the \LaTeX\ output.

## License

This project is licensed under the MIT License. See the [`LICENSE`](LICENSE) file for details.

[^1]: There are some minor differences between the syntax formats defined across different platforms.
[^2]: These terms are interchangeable and refer to the same feature.
[^3]: These limitations will be addressed in future updates.
[^4]: Make sure to define the required environments in your \LaTeX\ document class.
[^5]: This is an example from [ElegantNote](https://github.com/ElegantLaTeX/ElegantNote/blob/master/elegantnote-cn.tex).
