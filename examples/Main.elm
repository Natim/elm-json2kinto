module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Encode as Encode
import Json2Xls


type Msg
    = Download
    | XlsBuilt Base64


type alias Base64 =
    String


type alias Model =
    { records : List Record
    , xls : Maybe Base64
    }


type alias Record =
    { title : String
    , content : String
    }


init : ( Model, Cmd Msg )
init =
    ( { records =
            [ { title = "Bonjour", content = "les amis" }
            , { title = "Bonsoir", content = "Mariane" }
            ]
      , xls = Nothing
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Json2Xls.builtSub XlsBuilt
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Download ->
            let
                data =
                    Encode.list <| List.map encodeRecord model.records
            in
                ( model, Json2Xls.buildXls data )

        XlsBuilt xls ->
            ( { model | xls = Just xls }, Cmd.none )


view : Model -> Html Msg
view model =
    let
        file =
            case model.xls of
                Nothing ->
                    button [ onClick Download ]
                        [ text "Prepare XLS file"
                        ]

                Just xls ->
                    a
                        [ attribute "download" "file.xls"
                        , "data:application/vnd.ms-excel;base64," ++ xls |> href
                        ]
                        [ text "Download XLS file" ]
    in
        Html.div [] [ file ]


encodeRecord : Record -> Encode.Value
encodeRecord record =
    Encode.object
        [ ( "title", Encode.string record.title )
        , ( "content", Encode.string record.content )
        ]


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
