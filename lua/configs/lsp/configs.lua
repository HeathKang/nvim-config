local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

local lspconfig = require("lspconfig")

local servers = {"jsonls", "sumneko_lua","markdown", "pyright", "hls", "yamlls", "gopls", "tsserver"}

lsp_installer.setup {
	ensure_installed = servers
}

for _, server in pairs(servers) do
	local opts = {
		on_attach = require("configs.lsp.handlers").on_attach,
		capabilities = require("configs.lsp.handlers").capabilities,
	}
	local has_custom_opts, server_custom_opts = pcall(require, "configs.lsp.settings." .. server)
	if has_custom_opts then
	 	opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
	end
	lspconfig[server].setup(opts)
end

-- config scala-metals

local metals_installed, metals = pcall(require, "metals")
local metals_setting = {}
local has_custom_opts, service_custom_opts = pcall(require, "user.lsp.settings.metals")
if has_custom_opts then
  metals_setting = service_custom_opts
end

if metals_installed then
  -- metals config
  local metals_config = metals.bare_config()
  for key, value in pairs(metals_setting) do

    metals_config[key] = value
  end
  -- metals attach
  require("configs.lsp.handlers").keymaps()

  local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = {"scala", "sbt", "java"},
    callback = function ()
      metals.initialize_or_attach(metals_config)
    end,
    group = nvim_metals_group,
  })
else
  vim.notify("scala-metals doesn't installed")
end

