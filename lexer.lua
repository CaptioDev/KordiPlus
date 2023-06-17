-- lexer.lua

local lexer = {}

function lexer.lex(sourceCode)
  local tokens = {}
  local position = 1

  local function createToken(type, value)
    return { type = type, value = value }
  end

  local function isWhitespace(char)
    return char == " " or char == "\t" or char == "\n"
  end

  local function isDigit(char)
    return char >= "0" and char <= "9"
  end

  local function isAlpha(char)
    return (char >= "a" and char <= "z") or (char >= "A" and char <= "Z")
  end

  local function lexNumber()
    local start = position

    while isDigit(sourceCode[position]) do
      position = position + 1
    end

    local value = tonumber(sourceCode:sub(start, position - 1))
    table.insert(tokens, createToken("NUMBER", value))
  end

  local function lexIdentifierOrKeyword()
    local start = position

    while isAlpha(sourceCode[position]) do
      position = position + 1
    end

    local value = sourceCode:sub(start, position - 1)

    -- Check if the identifier is a keyword
    if value == "if" or value == "else" or value == "for" or value == "while" or value == "function" then
      table.insert(tokens, createToken(value:upper()))
    else
      table.insert(tokens, createToken("IDENTIFIER", value))
    end
  end

  while position <= #sourceCode do
    local char = sourceCode[position]

    if isWhitespace(char) then
      position = position + 1
    elseif isDigit(char) then
      lexNumber()
    elseif isAlpha(char) then
      lexIdentifierOrKeyword()
    else
      -- Handle other characters as individual tokens
      table.insert(tokens, createToken(char))
      position = position + 1
    end
  end

  return tokens
end

return lexer
