-- code_generator.lua

local function generateCode(ir)
    local output = ""
  
    local function indent(level)
      level = level or 1
      return string.rep("  ", level)
    end
  
    local function generateStatement(statement, level)
      level = level or 1
  
      if statement.type == "Assignment" then
        local symbol = statement.symbol.name
        local expression = generateExpression(statement.expression, level)
        output = output .. indent(level) .. symbol .. " = " .. expression .. "\n"
      elseif statement.type == "IfStatement" then
        local condition = generateExpression(statement.condition, level)
        output = output .. indent(level) .. "if " .. condition .. " then\n"
        output = output .. generateBlock(statement.trueBlock, level + 1)
        if statement.falseBlock then
          output = output .. indent(level) .. "else\n"
          output = output .. generateBlock(statement.falseBlock, level + 1)
        end
        output = output .. indent(level) .. "end\n"
      elseif statement.type == "ForLoop" then
        local init = generateStatement(statement.init, level)
        local condition = generateExpression(statement.condition, level)
        local update = generateStatement(statement.update, level)
        output = output .. indent(level) .. "for " .. init .. "; " .. condition .. "; " .. update .. " do\n"
        output = output .. generateBlock(statement.block, level + 1)
        output = output .. indent(level) .. "end\n"
      elseif statement.type == "WhileLoop" then
        local condition = generateExpression(statement.condition, level)
        output = output .. indent(level) .. "while " .. condition .. " do\n"
        output = output .. generateBlock(statement.block, level + 1)
        output = output .. indent(level) .. "end\n"
      elseif statement.type == "FunctionDeclaration" then
        local name = statement.name
        local parameters = table.concat(statement.parameters, ", ")
        output = output .. indent(level) .. "function " .. name .. "(" .. parameters .. ")\n"
        output = output .. generateBlock(statement.block, level + 1)
        output = output .. indent(level) .. "end\n"
      elseif statement.type == "ReturnStatement" then
        local expression = generateExpression(statement.expression, level)
        output = output .. indent(level) .. "return " .. expression .. "\n"
      else
        error("Invalid statement type: " .. statement.type)
      end
    end
  
    local function generateExpression(expression, level)
      level = level or 1
  
      if expression.type == "Symbol" then
        return expression.name
      elseif expression.type == "FunctionCall" then
        local name = expression.name
        local arguments = {}
        for _, arg in ipairs(expression.arguments) do
          table.insert(arguments, generateExpression(arg, level))
        end
        return name .. "(" .. table.concat(arguments, ", ") .. ")"
      elseif expression.type == "BinaryExpression" then
        local operator = expression.operator
        local left = generateExpression(expression.left, level)
        local right = generateExpression(expression.right, level)
        return left .. " " .. operator .. " " .. right
      elseif expression.type == "UnaryExpression" then
        local operator = expression.operator
        local operand = generateExpression(expression.operand, level)
        return operator .. operand
      elseif expression.type == "NumberLiteral" then
        return tostring(expression.value)
      elseif expression.type == "StringLiteral" then
        return '"' .. expression.value .. '"'
      else
        error("Invalid expression type: " .. expression.type)
      end
    end
  
    local function generateBlock(block, level)
      level = level or 1
  
      local blockOutput = ""
      for _, statement in ipairs(block) do
        blockOutput = blockOutput .. generateStatement(statement, level)
      end
      return blockOutput
    end
  
    --Make generateExpression & generateBlock global
    _G.generateExpression = generateExpression
    _G.generateBlock = generateBlock

    generateBlock(ir)
  
    return output
  end
  
  return generateCode
  