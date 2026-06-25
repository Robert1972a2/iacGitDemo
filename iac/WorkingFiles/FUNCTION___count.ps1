function count {
    [CmdletBinding()]
    param (
        [Parameter( ValueFromPipeline)]
        [psobject[]]
        $InputObject
    )

    begin {
        $count = 0
    }

    process {
        foreach ( $obj in $InputObject ) {
            $count++
        }
    }

    end {
        $count
    }
}