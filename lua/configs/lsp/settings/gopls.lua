local status_ok, nvim_lsp = pcall(require, "lspconfig")

if status_ok then
  return {
    cmd = {"gopls", "serve"},
    filetypes = {"go", "gomod"},
    root_dir = nvim_lsp.util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
    gopls = {
      analyses = {
           unusedparams = true,
         },
      staticcheck = true,
    }
  }
}
else
  return {}
end
