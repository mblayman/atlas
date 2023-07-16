local Response = require "atlas.response"
local state = require "atlas.templates.state"
local environment = state.environment

local templates = {}

-- Render the template.
--
-- The request is made available with the context.
--
--       request: An HTTP request
-- template_name: The name of the template
--       context: Context data to include in the template
function templates.render(request, template_name, context)
  local template = environment:get_template(template_name)
  if not template then error(string.format("Template not found: %s", template_name)) end

  context.request = request
  local content = template:render(context)
  return Response(content)
end

return templates
