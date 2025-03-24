### `callout2latex.lua`：将 Markdown Callout 块转换为 \LaTeX\ 环境

## 描述

`callout2latex.lua` 是一个 Pandoc Lua 过滤器，可将 [GitHub](https://github.com/orgs/community/discussions/16925)、[Typora](https://github.com/typora-community-plugin/typora-plugin-callout)、[Obsidian](https://help.obsidian.md/callouts#:~:text=To%20create%20a%20callout%2C%20add%20%60%5B%21info%5D%60%20to%20the,identifier%20determines%20how%20the%20callout%20looks%20and%20feels.) 和 [Microsoft](https://learn.microsoft.com/en-us/contribute/content/markdown-reference#alerts-note-tip-important-caution-warning)[^1] 风格的 Markdown Callout 块（也称为 Alert Blocks、 Message Boxes 或 Admonitions[^2]）转换为 \LaTeX\ 环境。

到目前为止，该脚本的基本功能已正确实现，但仍存在一些细节问题，我计划在后续更新中进行修复。

这个脚本的大部分内容都是在 [ChatGPT](https://chatgpt.com/) 和 [DeepSeek](https://chat.deepseek.com/) 的帮助下完成的，我只进行了极少的修改。

## 主要特性

与现有的将 adminition 转化为 \LaTeX\ 的 pandoc 过滤器 [pandoc-latex-admonition](https://github.com/chdemko/pandoc-latex-admonition) 过滤器相比，这个脚本具有如下的几个优势：

1. 使用更普遍的 Adminition 语法 (而不是 pandoc 原生的 `Div`)，能够被更多的编辑器和平台支持，且不引入额外的语法。
- 无论用户如何指定 Adimintion 的名称，脚本都只会简单地将 Adimintion 的名称“原封不动”地传递给 \LaTeX\ 的环境名称，从而给予用户最大的自由度。
- 足够轻量（仅一个 Lua 脚本），简单易用。

## 使用方法

如需使用此过滤器脚本，可通过 Pandoc 的 `--lua-filter` 参数将其指定为 Lua 过滤器。转换命令示例如 [`command.sh`](command.sh) 或 [`command.ps1`](command.ps1) 中所示。

```bash
pandoc file.md --output file.pdf --lua-filter callout2latex.lua
```

### 语法示例

如果您的 Markdown 文件包含以下内容：

```markdown {.numberLines}
带有标题的 note 提示块：

> [!note] 这是提示标题
> 这里是一些提示信息。

没有标题的 note 提示块：

> [!note]
> 这里是一些提示信息
> 可能包含多行，
>
> 甚至是一个新段落。
```

它将被转换为如下的 \LaTeX\ 样式：

```tex {.numberLines}
带有标题的 note 提示块：

\begin{note}[这是提示标题]

这里是一些提示信息。

\end{note}

没有标题的 note 提示块：

\begin{note}

这里是一些提示信息

可能包含多行，

甚至是一个新段落。

\end{note}
```

> [!TIP]
> 以防你不知道：Pandoc 内置 Lua 解释器，因此无需安装或配置独立的 Lua 运行环境。

## 注意事项

关于该过滤器脚本，有以下几点需要注意[^3]：

1. 目前，不支持在提示块中使用有序列表 (`enumerate`) 和无序列表 (`itemize`)。
2. 提示块中的每一行都会被转换成 \LaTeX\ 中的一个段落。

> [!WARNING]
> **不要在类型标签后加空格！**
>
> 在提示块类型标签 `[!TYPE]` 后留有空格 (或其他空白字符) 可能会导致不希望的 \LaTeX\ 格式错误。例如：
>
> ```markdown {.numberLines}
> > [!NOTE]
> > 注意 `[!NOTE]` 标签后有两个空格。
> ```
>
> 虽然你看不见这些空白字符，但是它们如果存在的话，就会被转化为：
>
> ```tex {.numberLines}
> \begin{note}[注意 `[!NOTE]` 标签后有两个空格。 ]
> \end{note}
> ```
>
> 这可能导致生成的内容格式不符合预期。

## 安装

要安装 `callout2latex.lua` 并使其在本地计算机上的任意位置可用，请按照以下步骤操作：

### 查找 Pandoc 的用户数据目录

Pandoc 将用户特定的数据（包括过滤器）存储在其用户数据目录中。要找到此目录，请在终端或命令提示符中运行以下命令：

```bash
pandoc --version
```

然后查找显示 `User data directory:` 的行，其路径通常类似于：

```txt
User data directory: /home/username/.pandoc
```

不同系统的典型路径如下：

- **Linux:** `~/.pandoc/`
- **macOS:** `~/Library/Application Support/pandoc/`
- **Windows:** `C:\Users\username\AppData\Roaming\pandoc\`

如果该目录不存在，可以选择手动创建。

### 复制此过滤器脚本到 filters 目录

在用户数据目录中，定位或创建 `filters` 子目录：

```bash
mkdir -p ~/.pandoc/filters
```

将 `callout2latex.lua` 复制到 `filters` 目录 (以 `~/.pandoc/finters` 为例)：

```bash
cp callout2latex.lua ~/.pandoc/filters/
```

### 验证安装

确保过滤器已正确安装，运行以下命令：

```bash
ls ~/.pandoc/filters/
```

应能看到 `callout2latex.lua` 出现在列表中。

### 全局使用过滤器

安装完成后，可以在任何目录中通过以下命令应用过滤器：

```bash
pandoc file.md --output file.pdf --lua-filter callout2latex.lua
```

或者，直接从用户数据目录中引用过滤器，而无需指定完整路径：

```bash
pandoc file.md --output file.pdf --lua-filter callout2latex.lua
```

### 在 Linux 或 Mac 上创建全局别名（可选）

为了简化使用，可以创建一个 shell 别名：

```bash {.numberLines}
echo 'alias callout2latex="pandoc --lua-filter=$HOME/.pandoc/filters/callout2latex.lua"' >> ~/.bashrc
source ~/.bashrc
```

现在可以直接使用：

```bash
callout2latex file.md -o file.pdf
```

## 示例

### 提示框

考虑以下 Markdown 语法：

```markdown {.numberLines}
> [!NOTE]
> 突出用户需要注意的信息，即使是在浏览时。

> [!TIP]
> 帮助用户更成功的可选信息。

> [!IMPORTANT]
> 用户成功所必需的重要信息。

> [!WARNING]
> 由于潜在风险，需要用户立即注意的关键内容。

> [!CAUTION]
> 行动可能产生的负面后果。
```

使用 Lua 过滤器运行 `pandoc` 后，上述块将转换为 \LaTeX\ 环境。（请确保在文档类[^4]中定义了所需的环境。有关定义请参见 `example.cls`。）

> [!NOTE]
> 突出用户需要注意的信息，即使是在浏览时。

> [!TIP]
> 帮助用户更成功的可选信息。

> [!IMPORTANT]
> 用户成功所必需的重要信息。

> [!WARNING]
> 由于潜在风险，需要用户立即注意的关键内容。

> [!CAUTION]
> 行动可能产生的负面后果。

### 定理环境

该脚本支持自定义的 \LaTeX\ 环境。例如[^5]，如果你在文档类中正确定义了 `definition` 和 `theorem` 环境，可以使用以下语法：

> [!definition] 左陪集
> 设 $H$ 是群 $G$ 的一个子群。$H$ 在 $G$ 中的 \emph{左陪集} 是形如 $xH$ 的 $G$ 的一个子集，其中 $x \in G$ 且 $xH = \{ xh : h \in H \}$。类似地，$H$ 在 $G$ 中的 \emph{右陪集} 是形如 $Hx$ 的 $G$ 的一个子集，其中 $Hx = \{ hx : h \in H \}$

> [!theorem] Lagrange 定理
> 设 $G$ 是一个有限群，$H$ 是 $G$ 的子群，则 $|H|$ 整除 $|G|$。

这些块将转换为：

```tex
\begin{definition}[左陪集]
设 $H$ 是群 $G$ 的一个子群。$H$ 在 $G$ 中的 \emph{左陪集} 是形如 $xH$ 的 $G$ 的一个子集，其中 $x \in G$ 且 $xH = \{ xh : h \in H \}$。类似地，$H$ 在 $G$ 中的 \emph{右陪集} 是形如 $Hx$ 的 $G$ 的一个子集，其中 $Hx = \{ hx : h \in H \}$。
\end{definition}

\begin{theorem}[Lagrange 定理]
设 $G$ 是一个有限群，$H$ 是 $G$ 的子群，则 $|H|$ 整除 $|G|$。
\end{theorem}
```

如需查看 \LaTeX\ 输出中排版好的 Theorem 环境，请查看 [`README.pdf`](README.pdf)。

## 许可证

本项目基于 MIT 许可证发布。查看 [`LICENSE`](LICENSE) 以了解许可证信息。

[^1]: 在不同的平台上，这一语法可能存在一些极小的差异。
[^2]: 这些名称所指的是同一个东西。
[^3]: 这些限制将会在脚本后续的更新中被解决。
[^4]: 请确保所需的这些环境已经在您的 \LaTeX\ 环境中被正确定义。
[^5]: 示例的文本来自 [ElegantNote](https://github.com/ElegantLaTeX/ElegantNote/blob/master/elegantnote-cn.tex)。

