window.onload = function () {
  Elm.Main.init({
    node: document.body,
    flags: {
      window: {
        width: window.screen.width < window.innerWidth ? window.screen.width : window.innerWidth,
        height: window.screen.height < window.innerHeight ? window.screen.height : window.innerHeight,
      },
      apiUrl: "https://swapi-graphql.netlify.app/.netlify/functions/index"
    }
  })
}
