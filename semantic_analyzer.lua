-- semantic_analyzer.lua

local function analyze(ast)
    local symbolTable = {}
  
    local function analyzeBlock(block)
      for _, statement in ipairs(block.statements) do
        analyzeStatement(statement)
      end
    end
  
    local function analyzeIfStatement(ifStatement)
      analyzeExpression(ifStatement.condition)
      analyzeBlock(ifStatement.ifBlock)
  
      if ifStatement.elseBlock then
        analyzeBlock(ifStatement.elseBlock)
      end
    end
  
    local function analyzeForLoop(forLoop)
      analyzeStatement(forLoop.init)
      analyzeExpression(forLoop.condition)
      analyzeStatement(forLoop.update)
      analyzeBlock(forLoop.block)
    end
  
    local function analyzeWhileLoop(whileLoop)
      analyzeExpression(whileLoop.condition)
      analyzeBlock(whileLoop.block)
    end
  
    local function analyzeFunctionDeclaration(functionDeclaration)
      for _, param in ipairs(functionDeclaration.parameters) do
        symbolTable[param] = true
      end
  
      analyzeBlock(functionDeclaration.block)
    end
  
    local function analyzeVariableDeclaration(variableDeclaration)
      symbolTable[variableDeclaration.name] = true
  
      if variableDeclaration.initializer then
        analyzeExpression(variableDeclaration.initializer)
      end
    end
  
    local function analyzeStatement(statement)
      if statement.type == "IfStatement" then
        analyzeIfStatement(statement)
      elseif statement.type == "ForLoop" then
        analyzeForLoop(statement)
      elseif statement.type == "WhileLoop" then
        analyzeWhileLoop(statement)
      elseif statement.type == "FunctionDeclaration" then
        analyzeFunctionDeclaration(statement)
      elseif statement.type == "VariableDeclaration" then
        analyzeVariableDeclaration(statement)
      else
        error("Invalid statement type: " .. statement.type)
      end
    end
  
    local function analyzeExpression(expression)
      if expression.type == "BinaryExpression" then
        analyzeExpression(expression.left)
        analyzeExpression(expression.right)
      elseif expression.type == "UnaryExpression" then
        analyzeExpression(expression.operand)
      elseif expression.type == "Identifier" then
        if not symbolTable[expression.name] then
          error("Undeclared variable: " .. expression.name)
        end
      end
    end
  
--Make analyzeStatement & analyzeExpression global
_G.analyzeStatement = analyzeStatement
_G.analyzeExpression = analyzeExpression

    analyzeBlock(ast)
  end
  
  return analyze
  