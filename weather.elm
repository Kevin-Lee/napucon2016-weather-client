import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket

main =
  Html.program
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }


-- MODEL

type alias Model =
  { input : String
  , messages : List String
  }

init : (Model, Cmd Msg)
init =
  (Model "" [], Cmd.none)


  -- UPDATE

type Msg
  = Input String
  | Send
  | NewMessage String

update : Msg -> Model -> (Model, Cmd Msg)
update msg { input, messages } =
  case msg of
    Input newInput ->
        (Model newInput messages, Cmd.none)
    Send ->
      (Model "" messages, WebSocket.send "ws://localhost:9000/ws" input)

    NewMessage str ->
      (Model input (str :: messages), Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen "ws://localhost:9000/ws" NewMessage


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ p [] [ text "지역 코드를 넣으신 후 Send 버튼을 눌러 주세요. 예) Seoul,KR 혹은 Sydney,AU" ]
    , div [] (List.map viewMessage model.messages)
    , input [onInput Input] []
    , button [onClick Send] [text "Send"]
    ]

viewMessage : String -> Html msg
viewMessage msg =
  div [] [ text msg ]

