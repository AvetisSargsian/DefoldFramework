local GUI_Box = require "main.frameworck.ui.common.GUI_Box"

local Text_Box = {}

function Text_Box.new(node_name)
	local super = GUI_Box.new(node_name);
	local this = {};

	setmetatable(this, super);
	super.__index = super;

	function this.set_text(text)
		gui.set_text(this.node, text);
	end

	return this;
end

return Text_Box;