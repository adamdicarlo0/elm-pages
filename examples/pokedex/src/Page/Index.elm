module Page.Index exposing (Data, Model, Msg, page)

import Bytes exposing (Bytes)
import Bytes.Decode
import Bytes.Encode
import DataSource exposing (DataSource)
import DataSource.Http
import Head
import Head.Seo as Seo
import Html exposing (..)
import OptimizedDecoder as Decode
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Route
import Secrets
import Shared
import Types
import View exposing (View)


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


data : DataSource Data
data =
    DataSource.Http.get (Secrets.succeed "https://pokeapi.co/api/v2/pokemon/?limit=100&offset=0")
        (Decode.field "results"
            (Decode.list (Decode.field "name" Decode.string))
        )
        |> DataSource.distillBytes "pokedex-index" encode decode


encode : Data -> Bytes
encode items =
    Bytes.Encode.encode (Types.w3_encode_Data items)



--w3_encode_Data


decode : Bytes -> Result String Data
decode items =
    Bytes.Decode.decode Types.w3_decode_Data items
        |> Result.fromMaybe "Decoding error"



--w3_decode_Data |> Result.fromMaybe "Decoding error"


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages Pokedex"
        , image =
            { url = Pages.Url.external ""
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "This is a simple app to showcase server-rendering with elm-pages."
        , locale = Nothing
        , title = "Elm Pages Pokedex Example"
        }
        |> Seo.website


type alias Data =
    List String


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Pokedex"
    , body =
        [ ul []
            (List.indexedMap
                (\index name ->
                    let
                        pokedexNumber =
                            index + 1
                    in
                    li []
                        [ Route.link (Route.PokedexNumber_ { pokedexNumber = String.fromInt pokedexNumber })
                            []
                            [ text name ]
                        ]
                )
                static.data
            )
        ]
    }
