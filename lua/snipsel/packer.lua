return {
    startup = function(packages)
        -- install packer
        local ensure_packer = function()
            local fn = vim.fn
            local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
            if fn.empty(fn.glob(install_path)) > 0 then
                fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
                vim.cmd [[packadd packer.nvim]]
                return true
            end
            return false
        end

        local packer_bootstrap = ensure_packer()

        -- automatically run PackerCompile if this file is changed
        vim.api.nvim_exec(
            [[
                augroup Packer
                autocmd!
                autocmd BufWritePost init.lua PackerCompile
                augroup end
            ]],
            false
        )

        return require('packer').startup({
            function(use)
                use 'wbthomason/packer.nvim'
                packages(use)
                if packer_bootstrap then
                    require('packer').sync()
                end
            end,
            config = {
                display = {
                    open_fn = require('packer.util').float,
                }
            }
        })
    end
}
