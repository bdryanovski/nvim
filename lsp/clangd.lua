return {
	cmd = { "clangd", "--clang-tidy" },
	filetypes = { "h", "hpp", "c", "cpp", "cuh", "cu", "objc", "objcpp", "proto" },
	single_file_support = true,
	capabilities = {
		textDocument = {
			completion = {
				editsNearCursor = true,
			},
		},
		offsetEncoding = { "utf-8", "utf-16" },
	},
}
