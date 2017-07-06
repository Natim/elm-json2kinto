let app = Elm.Main.embed(document.getElementById("root"));

app.ports.buildXls.subscribe(function(json) {
  let xls = json2xls(JSON.parse(json));
  app.ports.builtXls.send(xls);
});
