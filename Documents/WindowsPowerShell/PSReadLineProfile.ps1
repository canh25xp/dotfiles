# ==============================================
# PSREADLINE SETTINGS
# ==============================================

using namespace System.Management.Automation
using namespace System.Management.Automation.Language

$PSReadLine = [Microsoft.PowerShell.PSConsoleReadLine]

# Commands default parameter
$PSDefaultParameterValues.Add('Format-*:AutoSize', $true)
$PSDefaultParameterValues.Add('Format-*:Wrap', $true)
$PSDefaultParameterValues.Add('Receive-Job:Keep', $true)
$PSDefaultParameterValues.Add('Get-Command:All', $true)

function OnViModeChange {
    if ($args[0] -eq 'Command') {
        # Set the cursor to a blinking block.
        Write-Host -NoNewLine "`e[1 q"
    } else {
        # Set the cursor to a blinking line.
        Write-Host -NoNewLine "`e[5 q"
    }
}

#Set-PsReadLineOption -EditMode Vi
#Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange
Set-PSReadLineOption -HistorySearchCursorMovesToEnd:$true

# Ignore some of the commands (not add to history)
Set-PSReadLineOption -AddToHistoryHandler {
    Param([string]$line)
    # Ignored git commands
    # if ($line -match "^git") {
    #     return $false
    # }
    if (@("exit", "dir", "ls", "la", "pwd", "cd ..", "cls", "clear", "exp .", "pwsh").Contains($line.ToLowerInvariant())) {
        return $false
    }
    return $true
}

# Save history in home directory
Set-PSReadLineOption -HistorySavePath "$HOME\.pwsh_history"

# ==============================================
# KEY BINDINGS
# ==============================================

# Kill whole line
Set-PSReadLineKeyHandler -Chord Alt+l -Function RevertLine

# Dynamic help (like F1)
# Set-PSReadLineKeyHandler -Chord "Ctrl+/" -Function ShowCommandHelp

# Change directory interactively
Set-PSReadLineKeyHandler -Chord Ctrl+o -ScriptBlock {
    $PSReadLine::RevertLine()
    $PSReadLine::Insert("cdi")
    $PSReadLine::AcceptLine()
}

# CaptureScreen is good for blog posts or email showing a transaction
# of what you did when asking for help or demonstrating a technique.
Set-PSReadLineKeyHandler -Chord 'Ctrl+k,Ctrl+c' -Function CaptureScreen

# Get help about the current command
Set-PSReadLineKeyHandler -Chord "Ctrl+h" `
                         -BriefDescription GetHelp `
                         -LongDescription "Get help about the current command" `
                         -ScriptBlock {
    $PSReadLine::BeginningOfLine()
    $PSReadLine::Insert("help ")
    $PSReadLine::AcceptLine()
}

# Smart Insert/Delete

# Matching quotes parens, and braces 

Set-PSReadLineKeyHandler -Key '"',"'" `
                         -BriefDescription SmartInsertQuote `
                         -LongDescription "Insert paired quotes if not already on a quote" `
                         -ScriptBlock {
    param($key, $arg)

    $quote = $key.KeyChar

    $selectionStart = $null
    $selectionLength = $null
    $PSReadLine::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

    $line = $null
    $cursor = $null
    $PSReadLine::GetBufferState([ref]$line, [ref]$cursor)

    # If text is selected, just quote it without any smarts
    if ($selectionStart -ne -1)
    {
        $PSReadLine::Replace($selectionStart, $selectionLength, $quote + $line.SubString($selectionStart, $selectionLength) + $quote)
        $PSReadLine::SetCursorPosition($selectionStart + $selectionLength + 2)
        return
    }

    $ast = $null
    $tokens = $null
    $parseErrors = $null
    $PSReadLine::GetBufferState([ref]$ast, [ref]$tokens, [ref]$parseErrors, [ref]$null)

    function FindToken {
        param($tokens, $cursor)

        foreach ($token in $tokens) {
            if ($cursor -lt $token.Extent.StartOffset) { continue }
            if ($cursor -lt $token.Extent.EndOffset) {
                $result = $token
                $token = $token -as [StringExpandableToken]
                if ($token) {
                    $nested = FindToken $token.NestedTokens $cursor
                    if ($nested) { $result = $nested }
                }

                return $result
            }
        }
        return $null
    }

    $token = FindToken $tokens $cursor

    # If we're on or inside a **quoted** string token (so not generic), we need to be smarter
    if ($token -is [StringToken] -and $token.Kind -ne [TokenKind]::Generic) {
        # If we're at the start of the string, assume we're inserting a new string
        if ($token.Extent.StartOffset -eq $cursor) {
            $PSReadLine::Insert("$quote$quote ")
            $PSReadLine::SetCursorPosition($cursor + 1)
            return
        }

        # If we're at the end of the string, move over the closing quote if present.
        if ($token.Extent.EndOffset -eq ($cursor + 1) -and $line[$cursor] -eq $quote) {
            $PSReadLine::SetCursorPosition($cursor + 1)
            return
        }
    }

    if ($null -eq $token -or
        $token.Kind -eq [TokenKind]::RParen -or $token.Kind -eq [TokenKind]::RCurly -or $token.Kind -eq [TokenKind]::RBracket) {
        if ($line[0..$cursor].Where{$_ -eq $quote}.Count % 2 -eq 1) {
            # Odd number of quotes before the cursor, insert a single quote
            $PSReadLine::Insert($quote)
        }
        else {
            # Insert matching quotes, move cursor to be in between the quotes
            $PSReadLine::Insert("$quote$quote")
            $PSReadLine::SetCursorPosition($cursor + 1)
        }
        return
    }

    # If cursor is at the start of a token, enclose it in quotes.
    if ($token.Extent.StartOffset -eq $cursor) {
        if ($token.Kind -eq [TokenKind]::Generic -or $token.Kind -eq [TokenKind]::Identifier -or 
            $token.Kind -eq [TokenKind]::Variable -or $token.TokenFlags.hasFlag([TokenFlags]::Keyword)) {
            $end = $token.Extent.EndOffset
            $len = $end - $cursor
            $PSReadLine::Replace($cursor, $len, $quote + $line.SubString($cursor, $len) + $quote)
            $PSReadLine::SetCursorPosition($end + 2)
            return
        }
    }

    # We failed to be smart, so just insert a single quote
    $PSReadLine::Insert($quote)
}

# Insert matching braces
Set-PSReadLineKeyHandler -Key '(','{','[' `
                         -BriefDescription InsertPairedBraces `
                         -LongDescription "Insert matching braces" `
                         -ScriptBlock {
    param($key, $arg)

    $closeChar = switch ($key.KeyChar) {
        <#case#> '(' { [char]')'; break }
        <#case#> '{' { [char]'}'; break }
        <#case#> '[' { [char]']'; break }
    }

    $selectionStart = $null
    $selectionLength = $null
    $PSReadLine::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

    $line = $null
    $cursor = $null
    $PSReadLine::GetBufferState([ref]$line, [ref]$cursor)

    if ($selectionStart -ne -1) {
      # Text is selected, wrap it in brackets
      $PSReadLine::Replace($selectionStart, $selectionLength, $key.KeyChar + $line.SubString($selectionStart, $selectionLength) + $closeChar)
      $PSReadLine::SetCursorPosition($selectionStart + $selectionLength + 2)
    } else {
      # No text is selected, insert a pair
      $PSReadLine::Insert("$($key.KeyChar)$closeChar")
      $PSReadLine::SetCursorPosition($cursor + 1)
    }
}

# Insert closing brace or skip
Set-PSReadLineKeyHandler -Key ')',']','}' `
                         -BriefDescription SmartCloseBraces `
                         -LongDescription "Insert closing brace or skip" `
                         -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    $PSReadLine::GetBufferState([ref]$line, [ref]$cursor)

    if ($line[$cursor] -eq $key.KeyChar) {
        $PSReadLine::SetCursorPosition($cursor + 1)
    }
    else {
        $PSReadLine::Insert("$($key.KeyChar)")
    }
}

# Delete previous character or matching quotes/parens/braces
Set-PSReadLineKeyHandler -Key Backspace `
                         -BriefDescription SmartBackspace `
                         -LongDescription "Delete previous character or matching quotes/parens/braces" `
                         -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    $PSReadLine::GetBufferState([ref]$line, [ref]$cursor)

    if ($cursor -gt 0) {
        $toMatch = $null
        if ($cursor -lt $line.Length) {
            switch ($line[$cursor]) {
                <#case#> '"' { $toMatch = '"'; break }
                <#case#> "'" { $toMatch = "'"; break }
                <#case#> ')' { $toMatch = '('; break }
                <#case#> ']' { $toMatch = '['; break }
                <#case#> '}' { $toMatch = '{'; break }
            }
        }

        if ($toMatch -ne $null -and $line[$cursor-1] -eq $toMatch) {
            $PSReadLine::Delete($cursor - 1, 2)
        }
        else {
            $PSReadLine::BackwardDeleteChar($key, $arg)
        }
    }
}

# Save command in the history (don't actually execute it)
Set-PSReadLineKeyHandler -Key Alt+w `
                         -BriefDescription SaveInHistory `
                         -LongDescription "Save current line in history but do not execute" `
                         -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    $PSReadLine::GetBufferState([ref]$line, [ref]$cursor)
    $PSReadLine::AddToHistory($line)
    $PSReadLine::RevertLine()
}

# Paste the clipboard text as a here string
Set-PSReadLineKeyHandler -Key Ctrl+V `
                         -BriefDescription PasteAsHereString `
                         -LongDescription "Paste the clipboard text as a here string" `
                         -ScriptBlock {
    param($key, $arg)

    Add-Type -Assembly PresentationCore
    if ([System.Windows.Clipboard]::ContainsText()) {
        # Get clipboard text - remove trailing spaces, convert \r\n to \n, and remove the final \n.
        $text = ([System.Windows.Clipboard]::GetText() -replace "\p{Zs}*`r?`n","`n").TrimEnd()
        $PSReadLine::Insert("@'`n$text`n'@")
    }
    else
    {
        $PSReadLine::Ding()
    }
}

# Put parenthesis around the selection or entire line and move the cursor to after the closing parenthesis
Set-PSReadLineKeyHandler -Key 'Alt+(' `
                         -BriefDescription ParenthesizeSelection `
                         -LongDescription "Put parenthesis around the selection or entire line and move the cursor to after the closing parenthesis" `
                         -ScriptBlock {
    param($key, $arg)

    $selectionStart = $null
    $selectionLength = $null
    $PSReadLine::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

    $line = $null
    $cursor = $null
    $PSReadLine::GetBufferState([ref]$line, [ref]$cursor)
    if ($selectionStart -ne -1)
    {
        $PSReadLine::Replace($selectionStart, $selectionLength, '(' + $line.SubString($selectionStart, $selectionLength) + ')')
        $PSReadLine::SetCursorPosition($selectionStart + $selectionLength + 2)
    }
    else
    {
        $PSReadLine::Replace(0, $line.Length, '(' + $line + ')')
        $PSReadLine::EndOfLine()
    }
}

# Toggle quotes on the argument under the cursor
Set-PSReadLineKeyHandler -Key "Alt+'" `
                         -BriefDescription ToggleQuoteArgument `
                         -LongDescription "Toggle quotes on the argument under the cursor" `
                         -ScriptBlock {
    param($key, $arg)

    $ast = $null
    $tokens = $null
    $errors = $null
    $cursor = $null
    $PSReadLine::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)

    $tokenToChange = $null
    foreach ($token in $tokens) {
        $extent = $token.Extent
        if ($extent.StartOffset -le $cursor -and $extent.EndOffset -ge $cursor) {
            $tokenToChange = $token

            # If the cursor is at the end (it's really 1 past the end) of the previous token,
            # we only want to change the previous token if there is no token under the cursor
            if ($extent.EndOffset -eq $cursor -and $foreach.MoveNext()) {
                $nextToken = $foreach.Current
                if ($nextToken.Extent.StartOffset -eq $cursor)
                {
                    $tokenToChange = $nextToken
                }
            }
            break
        }
    }

    if ($tokenToChange -ne $null) {
        $extent = $tokenToChange.Extent
        $tokenText = $extent.Text
        if ($tokenText[0] -eq '"' -and $tokenText[-1] -eq '"') {
            $replacement = $tokenText.Substring(1, $tokenText.Length - 2) # Switch to no quotes
        }
        elseif ($tokenText[0] -eq "'" -and $tokenText[-1] -eq "'") {
            $replacement = '"' + $tokenText.Substring(1, $tokenText.Length - 2) + '"' # Switch to double quotes
        }
        else {
            $replacement = "'" + $tokenText + "'" # Add single quotes
        }

        $PSReadLine::Replace(
            $extent.StartOffset,
            $tokenText.Length,
            $replacement)
    }
}

# This example will replace any aliases on the command line with the resolved commands.
Set-PSReadLineKeyHandler -Key "Alt+%" `
                         -BriefDescription ExpandAliases `
                         -LongDescription "Replace all aliases with the full command" `
                         -ScriptBlock {
    param($key, $arg)

    $ast = $null
    $tokens = $null
    $errors = $null
    $cursor = $null
    $PSReadLine::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)

    $startAdjustment = 0
    foreach ($token in $tokens) {
        if ($token.TokenFlags -band [TokenFlags]::CommandName) {
            $alias = $ExecutionContext.InvokeCommand.GetCommand($token.Extent.Text, 'Alias')
            if ($alias -ne $null) {
                $resolvedCommand = $alias.ResolvedCommandName
                if ($resolvedCommand -ne $null) {
                    $extent = $token.Extent
                    $length = $extent.EndOffset - $extent.StartOffset
                    $PSReadLine::Replace(
                        $extent.StartOffset + $startAdjustment,
                        $length,
                        $resolvedCommand)

                    # Our copy of the tokens won't have been updated, so we need to # adjust by the difference in length
                    $startAdjustment += ($resolvedCommand.Length - $length)
                }
            }
        }
    }
}