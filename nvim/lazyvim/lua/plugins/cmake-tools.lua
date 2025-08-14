return {
  {
    "Civitasv/cmake-tools.nvim",
    config = function()
      require("cmake-tools").setup({
        cmake_notifications = {
          executor = {
            enabled = false, -- filtering is not working...
          },
        },
        cmake_dap_configuration = {
          type = "gdb",
        },
      })
    end,
    -- commit = "d6fa304", -- somehow latest patch from May 18, 2025 is buggy when building
    -- commit = "f1f917b",
    -- how to selectively provide cmake-tools command?
    -- how to use require("cmake-tools").is_cmake_project()
    keys = {
      {
        "<Leader>cm",
        desc = "+cmake-tools",
      },
      {
        "<Leader>cma",
        function()
          vim.api.nvim_feedkeys(
            ":CMakeLaunchArgs " .. table.concat(require("cmake-tools").get_launch_args(), " "),
            "t",
            false
          )
        end,
        desc = "CMake launch args",
      },
      {
        "<Leader>cmb",
        "<cmd>CMakeBuild<cr>",
        desc = "CMake build",
      },
      {
        "<Leader>cmB",
        "<cmd>CMakeBuild!<cr>",
        desc = "CMake rebuild",
      },
      {
        "<Leader>cmc",
        "<cmd>CMakeClean<cr>",
        desc = "CMake clean",
      },
      {
        "<Leader>cmd",
        "<cmd>CMakeDebug<cr>",
        desc = "CMake Debug",
      },
      {
        "<Leader>cmg",
        "<cmd>CMakeGenerate<cr>",
        desc = "CMake generate",
      },
      {
        "<Leader>cmG",
        "<cmd>CMakeGenerate!<cr>",
        desc = "CMake re-generate",
      },
      {
        "<Leader>cmp",
        "<cmd>CMakeSelectBuildPreset<cr>",
        desc = "CMake select build preset",
      },
      {
        "<Leader>cmr",
        "<cmd>CMakeRun<cr>",
        desc = "CMake run",
      },
      {
        "<Leader>cmt",
        "<cmd>CMakeSelectBuildTarget<cr>",
        desc = "CMake select build target",
      },
      {
        "<Leader>cmx",
        "<cmd>CMakeStopRunner<cr><cmd>CMakeStopExecutor<cr>",
        desc = "CMake Stop",
      },
    },
  },
}
