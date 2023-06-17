-- ir.lua

-- Define the IR structures

-- IR Statement
local function IRStatement(type, ...)
    return {
      type = type,
      arguments = {...}
    }
  end
  
  -- IR Expression
  local function IRExpression(type, ...)
    return {
      type = type,
      arguments = {...}
    }
  end
  
  -- IR Symbol
  local function IRSymbol(name)
    return {
      type = "Symbol",
      name = name
    }
  end
  
  -- IR Function Call
  local function IRFunctionCall(name, arguments)
    return {
      type = "FunctionCall",
      name = name,
      arguments = arguments
    }
  end
  
  -- IR Assignment
  local function IRAssignment(symbol, expression)
    return {
      type = "Assignment",
      symbol = symbol,
      expression = expression
    }
  end
  
  -- IR If Statement
  local function IRIfStatement(condition, trueBlock, falseBlock)
    return {
      type = "IfStatement",
      condition = condition,
      trueBlock = trueBlock,
      falseBlock = falseBlock
    }
  end
  
  -- IR For Loop
  local function IRForLoop(init, condition, update, block)
    return {
      type = "ForLoop",
      init = init,
      condition = condition,
      update = update,
      block = block
    }
  end
  
  -- IR While Loop
  local function IRWhileLoop(condition, block)
    return {
      type = "WhileLoop",
      condition = condition,
      block = block
    }
  end
  
  -- IR Function Declaration
  local function IRFunctionDeclaration(name, parameters, block)
    return {
      type = "FunctionDeclaration",
      name = name,
      parameters = parameters,
      block = block
    }
  end
  
  -- IR Return Statement
  local function IRReturnStatement(expression)
    return {
      type = "ReturnStatement",
      expression = expression
    }
  end
  
  -- IR Binary Expression
  local function IRBinaryExpression(operator, left, right)
    return {
      type = "BinaryExpression",
      operator = operator,
      left = left,
      right = right
    }
  end
  
  -- IR Unary Expression
  local function IRUnaryExpression(operator, operand)
    return {
      type = "UnaryExpression",
      operator = operator,
      operand = operand
    }
  end
  
  -- IR Number Literal
  local function IRNumberLiteral(value)
    return {
      type = "NumberLiteral",
      value = value
    }
  end
  
  -- IR String Literal
  local function IRStringLiteral(value)
    return {
      type = "StringLiteral",
      value = value
    }
  end
  
  -- Export the IR functions
  return {
    IRStatement = IRStatement,
    IRExpression = IRExpression,
    IRSymbol = IRSymbol,
    IRFunctionCall = IRFunctionCall,
    IRAssignment = IRAssignment,
    IRIfStatement = IRIfStatement,
    IRForLoop = IRForLoop,
    IRWhileLoop = IRWhileLoop,
    IRFunctionDeclaration = IRFunctionDeclaration,
    IRReturnStatement = IRReturnStatement,
    IRBinaryExpression = IRBinaryExpression,
    IRUnaryExpression = IRUnaryExpression,
    IRNumberLiteral = IRNumberLiteral,
    IRStringLiteral = IRStringLiteral
  }
  