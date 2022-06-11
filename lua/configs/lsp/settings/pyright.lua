local status_ok, nvim_lsp = pcall(require, "lspconfig")

if status_ok then
  return {
    root_dir = nvim_lsp.util.root_pattern(".git");
  }
else
  return {}
end

