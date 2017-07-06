port module Json2Xls exposing (buildXls, builtSub)

import Json.Encode as Encode


builtSub : (String -> msg) -> Sub msg
builtSub builtMsg =
    xlsBuilt builtMsg


port buildXls : Encode.Value -> Cmd msg


port xlsBuilt : (String -> msg) -> Sub msg
