module People exposing (Person, getId, getList)

import Data.InputObject as InputObject
import Data.Object as Object
import Data.Object.PeopleConnection as ObjectPeopleConnection
import Data.Object.Person as ObjectPerson
import Data.Query as Query
import Data.Scalar as Scalar
import Graphql.Operation exposing (RootMutation, RootQuery)
import Graphql.OptionalArgument as OptionalArgument exposing (OptionalArgument)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)



-- TYPES


type alias Person =
    { id : Scalar.Id
    , name : Maybe String
    }



-- API


getList : SelectionSet (List Person) RootQuery
getList =
    SelectionSet.map (unwrapMaybe >> Maybe.withDefault [] >> filterMaybe)
        (Query.allPeople
            (\options -> { options | first = OptionalArgument.Present 10 })
            (ObjectPeopleConnection.people
                (SelectionSet.map2 Person
                    ObjectPerson.id
                    ObjectPerson.name
                )
            )
        )



-- HELPERS


getId : Person -> String
getId person =
    case person.id of
        Scalar.Id id ->
            id


unwrapMaybe : Maybe (Maybe a) -> Maybe a
unwrapMaybe =
    Maybe.andThen identity


filterMaybe : List (Maybe a) -> List a
filterMaybe =
    List.foldl
        (\item list ->
            case item of
                Just val ->
                    list ++ [ val ]

                Nothing ->
                    list
        )
        []
