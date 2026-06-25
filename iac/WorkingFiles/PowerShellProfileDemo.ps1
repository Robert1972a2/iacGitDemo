# Keyhandler
## Ctrl + 8 Keyhandler
Set-PSReadLineKeyHandler -Chord 'Ctrl+8' -ScriptBlock {

    [Microsoft.PowerShell.PSConsoleReadLine]::BeginningOfLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('(')
    [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert(')')
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('.')

}
## Alt + #
Set-PSReadLineKeyHandler -Chord 'Alt+#' -ScriptBlock {

    [Microsoft.PowerShell.PSConsoleReadLine]::BeginningOfLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('#')
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert(' ')
    [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
}
