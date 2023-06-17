-- parser.lua

local TokenType = require("lexer").TokenType

local function parser(tokens)
  local currentTokenIndex = 1

  local function advanceToken()
    currentTokenIndex = currentTokenIndex + 1
  end

  local function getCurrentToken()
    return tokens[currentTokenIndex]
  end

  local function parsePrimaryExpression()
    local currentToken = getCurrentToken()

    if currentToken.type == TokenType.Number or currentToken.type == TokenType.String or currentToken.type == TokenType.Identifier then
      advanceToken()
    else
      error("Invalid primary expression at line " .. currentToken.line .. ", column " .. currentToken.column)
    end
  end

  local function parseUnaryExpression()
    local currentToken = getCurrentToken()

    if currentToken.type == TokenType.Operator and (currentToken.value == "-" or currentToken.value == "not") then
      advanceToken()
      parseUnaryExpression()
    else
      parsePrimaryExpression()
    end
  end

  local function parseMultiplicativeExpression()
    parseUnaryExpression()

    local currentToken = getCurrentToken()

    while currentToken.type == TokenType.Operator and (currentToken.value == "*" or currentToken.value == "/") do
      advanceToken()
      parseUnaryExpression()
      currentToken = getCurrentToken()
    end
  end

  local function parseAdditiveExpression()
    parseMultiplicativeExpression()

    local currentToken = getCurrentToken()

    while currentToken.type == TokenType.Operator and (currentToken.value == "+" or currentToken.value == "-") do
      advanceToken()
      parseMultiplicativeExpression()
      currentToken = getCurrentToken()
    end
  end

  local function parseRelationalExpression()
    parseAdditiveExpression()

    local currentToken = getCurrentToken()

    while currentToken.type == TokenType.Operator and (currentToken.value == "<" or currentToken.value == ">" or currentToken.value == "<=" or currentToken.value == ">=") do
      advanceToken()
      parseAdditiveExpression()
      currentToken = getCurrentToken()
    end
  end

  local function parseEqualityExpression()
    parseRelationalExpression()

    local currentToken = getCurrentToken()

    while currentToken.type == TokenType.Operator and (currentToken.value == "==" or currentToken.value == "!=") do
      advanceToken()
      parseRelationalExpression()
      currentToken = getCurrentToken()
    end
  end

  local function parseLogicalAndExpression()
    parseEqualityExpression()

    local currentToken = getCurrentToken()

    while currentToken.type == TokenType.Operator and currentToken.value == "and" do
      advanceToken()
      parseEqualityExpression()
      currentToken = getCurrentToken()
    end
  end

  local function parseLogicalOrExpression()
    parseLogicalAndExpression()

    local currentToken = getCurrentToken()

    while currentToken.type == TokenType.Operator and currentToken.value == "or" do
      advanceToken()
      parseLogicalAndExpression()
      currentToken = getCurrentToken()
    end
  end

  local function parseExpression()
    parseLogicalOrExpression()
  end

  local function parseBlock()
    local currentToken = getCurrentToken()
    
    if currentToken.type == TokenType.Operator and currentToken.value == "{" then
      advanceToken()

      while getCurrentToken().type ~= TokenType.Operator or getCurrentToken().value ~= "}" do
        parseStatement()
      end

      if getCurrentToken().type == TokenType.Operator and getCurrentToken().value == "}" then
        advanceToken()
      else
        error("Missing closing '}' at line " .. getCurrentToken().line .. ", column " .. getCurrentToken().column)
      end
    else
      error("Missing opening '{' at line " .. currentToken.line .. ", column " .. currentToken.column)
    end
  end

  local function parseIfStatement()
    local currentToken = getCurrentToken()

    if currentToken.type == TokenType.Keyword and currentToken.value == "if" then
      advanceToken()
      parseExpression()

      parseBlock()

      currentToken = getCurrentToken()

      if currentToken.type == TokenType.Keyword and currentToken.value == "else" then
        advanceToken()
        parseBlock()
      end
    else
      error("Invalid if statement at line " .. currentToken.line .. ", column " .. currentToken.column)
    end
  end

  local function parseForLoop()
    local currentToken = getCurrentToken()

    if currentToken.type == TokenType.Keyword and currentToken.value == "for" then
      advanceToken()

      if getCurrentToken().type == TokenType.Identifier then
        advanceToken()

        if getCurrentToken().type == TokenType.Operator and getCurrentToken().value == "=" then
          advanceToken()
          parseExpression()

          if getCurrentToken().type == TokenType.Operator and getCurrentToken().value == "," then
            advanceToken()
            parseExpression()

            if getCurrentToken().type == TokenType.Operator and getCurrentToken().value == "," then
              advanceToken()
              parseExpression()
            end
          end

          parseBlock()
        else
          error("Missing '=' in for loop at line " .. getCurrentToken().line .. ", column " .. getCurrentToken().column)
        end
      else
        error("Missing identifier in for loop at line " .. getCurrentToken().line .. ", column " .. getCurrentToken().column)
      end
    else
      error("Invalid for loop at line " .. currentToken.line .. ", column " .. currentToken.column)
    end
  end

  local function parseWhileLoop()
    local currentToken = getCurrentToken()

    if currentToken.type == TokenType.Keyword and currentToken.value == "while" then
      advanceToken()
      parseExpression()
      parseBlock()
    else
      error("Invalid while loop at line " .. currentToken.line .. ", column " .. currentToken.column)
    end
  end

  local function parseFunctionDeclaration()
    local currentToken = getCurrentToken()

    if currentToken.type == TokenType.Keyword and currentToken.value == "function" then
      advanceToken()

      if getCurrentToken().type == TokenType.Identifier then
        advanceToken()

        if getCurrentToken().type == TokenType.Operator and getCurrentToken().value == "(" then
          advanceToken()

          while getCurrentToken().type == TokenType.Identifier do
            advanceToken()

            if getCurrentToken().type == TokenType.Operator and getCurrentToken().value == "," then
              advanceToken()
            end
          end

          if getCurrentToken().type == TokenType.Operator and getCurrentToken().value == ")" then
            advanceToken()
          else
            error("Missing closing ')' for function parameters at line " .. getCurrentToken().line .. ", column " .. getCurrentToken().column)
          end
        end

        parseBlock()
      else
        error("Missing function name at line " .. getCurrentToken().line .. ", column " .. getCurrentToken().column)
      end
    else
      error("Invalid function declaration at line " .. currentToken.line .. ", column " .. currentToken.column)
    end
  end

  local function parseVariableDeclaration()
    local currentToken = getCurrentToken()

    if currentToken.type == TokenType.Keyword and currentToken.value == "var" then
      advanceToken()

      if getCurrentToken().type == TokenType.Identifier then
        advanceToken()

        if getCurrentToken().type == TokenType.Operator and getCurrentToken().value == "=" then
          advanceToken()
          parseExpression()
        end
      else
        error("Missing variable name at line " .. getCurrentToken().line .. ", column " .. getCurrentToken().column)
      end
    else
      error("Invalid variable declaration at line " .. currentToken.line .. ", column " .. currentToken.column)
    end
  end

  local function parseStatement()
    local currentToken = getCurrentToken()

    if currentToken.type == TokenType.Keyword and currentToken.value == "if" then
      parseIfStatement()

    elseif currentToken.type == TokenType.Keyword and currentToken.value == "for" then
      parseForLoop()

    elseif currentToken.type == TokenType.Keyword and currentToken.value == "while" then
      parseWhileLoop()

    elseif currentToken.type == TokenType.Keyword and currentToken.value == "function" then
      parseFunctionDeclaration()

    elseif currentToken.type == TokenType.Keyword and currentToken.value == "var" then
      parseVariableDeclaration()

    else
      error("Invalid statement at line " .. currentToken.line .. ", column " .. currentToken.column)
    end
  end

  local function parseProgram()
    while getCurrentToken().type ~= TokenType.EOF do
      parseStatement()
    end
  end

-- Make parseStatement global
_G.parseStatement = parseStatement

  parseProgram()
end

return parser
