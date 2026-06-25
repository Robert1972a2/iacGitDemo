function Expand-AdditionalProperties {
    param (
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        $AdditionalProperties,
        [switch]
        $DoNotConvertToDateTime
    )

    process {
        $hash = @{}
        foreach ($key in $AdditionalProperties.Keys) {
            if (!$DoNotConvertDateTime -and $AdditionalProperties.$key -match '^\d{4}(-\d\d){2}T\d\d(:\d\d){2}Z$') {
                $hash.Add($key,[datetime]$AdditionalProperties.$key)
            } else {
                $hash.Add($key,$AdditionalProperties.$key)
            }
        }
        [PSCustomObject]$hash
    }
}