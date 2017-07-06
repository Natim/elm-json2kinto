let app = Elm.Main.embed(document.getElementById("root"));

app.ports.buildXls.subscribe(function(json) {
  let xls = json2xls(json);
  app.ports.xlsBuilt.send(btoa(xls));
});
