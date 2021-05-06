module Pages.SiteConfig exposing (SiteConfig)

import ApiRoute
import DataSource exposing (DataSource)
import Head
import Pages.Manifest


type alias SiteConfig route data =
    List route
    ->
        { data : DataSource data
        , canonicalUrl : String
        , manifest : data -> Pages.Manifest.Config
        , apiRoutes : List (ApiRoute.Done ApiRoute.Response)
        , head :
            data
            -> List Head.Tag
        }
