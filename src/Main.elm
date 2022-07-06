module Main exposing (main)

import Browser
import Browser.Navigation
import Element exposing (Element)
import Element.Border
import Element.Font
import Graphql.Http
import Html exposing (Html)
import People exposing (Person)
import Url exposing (Url)



-- Entry point


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }



-- MAIN TYPES


type alias Flags =
    { window : { width : Int, height : Int }
    , apiUrl : String
    }


type alias Model =
    { dataUrl : Url
    , list : List Person
    }


type alias GraphqlResult value =
    Result (Graphql.Http.Error value) value


type Msg
    = GotPeopleList (GraphqlResult (List Person))



-- INIT


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        dataUrl =
            flags.apiUrl
                |> Url.fromString
                |> Maybe.withDefault
                    { protocol = Url.Http
                    , host = "localhost"
                    , port_ = Nothing
                    , path = ""
                    , query = Nothing
                    , fragment = Nothing
                    }
    in
    ( { dataUrl = dataUrl
      , list = []
      }
    , Graphql.Http.send GotPeopleList
        (Graphql.Http.queryRequest
            (Url.toString dataUrl)
            People.getList
        )
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        dataUrl =
            model.dataUrl
    in
    case msg of
        GotPeopleList res ->
            case res of
                Ok list ->
                    ( { model | list = list }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    Element.layoutWith
        { options =
            [ Element.focusStyle
                { borderColor = Nothing
                , backgroundColor = Nothing
                , shadow = Nothing
                }
            ]
        }
        [ Element.paddingXY 10 10
        , Element.Font.size 16
        ]
        (Element.column
            [ Element.width Element.fill
            , Element.height Element.fill
            ]
            [ Element.el []
                (Element.table
                    [ Element.Border.width 1 ]
                    { data = model.list
                    , columns =
                        [ { header =
                                Element.el
                                    [ Element.Border.width 1
                                    , Element.paddingXY 5 5
                                    , Element.Font.center
                                    ]
                                    (Element.text "ID")
                          , width = Element.px 150
                          , view =
                                \person ->
                                    Element.el
                                        [ Element.Border.width 1
                                        , Element.paddingXY 5 5
                                        ]
                                        (Element.text <| People.getId person)
                          }
                        , { header =
                                Element.el
                                    [ Element.Border.width 1
                                    , Element.paddingXY 5 5
                                    , Element.Font.center
                                    ]
                                    (Element.text "Name")
                          , width = Element.px 250
                          , view =
                                \person ->
                                    Element.el
                                        [ Element.Border.width 1
                                        , Element.paddingXY 5 5
                                        ]
                                        (Element.text <| Maybe.withDefault "no name" person.name)
                          }

                        -- New Column
                        ]
                    }
                )
            ]
        )
