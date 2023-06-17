-- main.lua

local lexer = require("lexer")
local parser = require("parser")
local analyzer = require("semantic_analyzer")
local generator = require("code_generator")
local runtime = require("runtime")

-- Read Kordi+ source code from a file
local function readSourceCode(filename)
  local file = io.open(filename, "r")
  if not file then
    error("Failed to open source file: " .. filename)
  end
  local sourceCode = file:read("*all")
  file:close()
  return sourceCode
end

-- Compile Kordi+ source code
local function compile(sourceCode)
  -- Lexical analysis
  local tokens = lexer.lex(sourceCode)

  -- Syntactic analysis
  local ast = parser.parse(tokens)

  -- Semantic analysis
  analyzer(ast)

  -- Code generation
  local code = generator.generate(ast)

  -- Return the compiled code
  return code
end

-- Execute the compiled code
local function run(code)
  -- Set up the runtime environment
  runtime.init()

  -- Execute the compiled code
  local chunk, err = load(code)
  if not chunk then
    error("Failed to load compiled code:\n" .. (err or "Unknown error"))
  end

  -- Run the compiled code
  local success, result = pcall(chunk)
  if not success then
    error("Error occurred during execution:\n" .. (result or "Unknown error"))
  end
end

-- Entry point
local function main(filename)
  -- Read the Kordi+ source code
  local sourceCode = readSourceCode(filename)

  -- Compile the source code
  local compiledCode = compile(sourceCode)

  -- Execute the compiled code
  run(compiledCode)
end

-- Run the compiler with the specified Kordi+ source file
main("app.kp")
