local bindings = {}

bindings = {
  lsp = {
    definition = "gd",
    type_definition = "gt",
    implementation = "gi",
    references = "gr",
    ws_symbols = "gw",
    symbols = "gs",
    diagnostics = "gt",
    ----
    format = "\\f",
    declaration = "gD",
    hover = "K",
    lsp_rename = "gn",
    diag_go_next = "]d",
    diag_go_prev = "[d",
    signature = "gs",
  },
}

return bindings
