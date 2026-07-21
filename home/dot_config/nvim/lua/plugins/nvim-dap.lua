return {
  "mfussenegger/nvim-dap",
  config = function()
    local dap = require("dap")
    dap.adapters.gdb = {
      type = "executable",
      command = "/home/linuxbrew/.linuxbrew/bin/gdb",
      args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
    }
    dap.configurations.cpp = {
      {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        stopAtBeginningOfMainSubprogram = false,
      },
    }
  end,
}
