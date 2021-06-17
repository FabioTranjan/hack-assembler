NEW_LINE = "\r\n"
COMMAND = '//'

OPERATIONS = {
  arithmetic: 'C_ARITHMETIC',
  push: 'C_PUSH',
  pop: 'C_POP',
  label: 'C_LABEL',
  goto: 'C_GOTO',
  'if-goto': 'C_IF',
  function: 'C_FUNCTION',
  return: 'C_RETURN',
  call: 'C_CALL'
}

ARITHMETIC = [
  'add',
  'sub',
  'neg',
  'eq',
  'gt',
  'lt',
  'and',
  'or',
  'not'
]

ARG_COMMANDS = [
  'push',
  'pop',
  'function',
  'call'
]