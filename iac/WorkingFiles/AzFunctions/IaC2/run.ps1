using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata, $InputBlob)

$name = $TriggerMetadata.name
$result = "The filename provided in the request is: $name `n"
$result += "The blob content is: $InputBlob `n"

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $result
})
